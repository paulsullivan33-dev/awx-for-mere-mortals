#!/bin/sh
# Run the ansible-core half of the AWX lab and capture transcripts.
# Usage: run-ansible-lab.sh <venv-bin-dir> <work-dir> <transcript-dir>
# The playbook runs against a FRESH COPY of the fixture project in
# <work-dir>, so the checkout's fixtures stay clean. Both fictional
# hosts use a local connection to 127.0.0.1. --forks 1 keeps the
# two local "hosts" serial so they do not race on the shared
# rollout checklist file -- on real separate hosts this is moot.
set -eu
VENV_BIN="$1"; WORK="$2"; T="$3"
export PATH="$VENV_BIN:$PATH"
mkdir -p "$WORK" "$T"
rm -rf "$WORK/northlight"
cp -r "$(dirname "$0")/../fixtures/northlight" "$WORK/northlight"
cd "$WORK/northlight"

{
  echo '$ ansible --version'; ansible --version
  echo; echo '$ ansible-playbook --version'; ansible-playbook --version
  echo; echo '$ python3 --version (the venv interpreter)'; "$VENV_BIN/python3" --version
  echo; echo '$ ansible webservers -i inventory.ini -m ping'
  ansible webservers -i inventory.ini -m ping
} > "$T/t00-versions-and-ping.txt" 2>&1

{
  echo '$ ansible-playbook -i inventory.ini site.yml --syntax-check'
  ansible-playbook -i inventory.ini site.yml --syntax-check
  echo; echo '$ ansible-playbook -i inventory.ini site.yml --list-hosts'
  ansible-playbook -i inventory.ini site.yml --list-hosts
  echo; echo '$ ansible-playbook -i inventory.ini site.yml --list-tasks'
  ansible-playbook -i inventory.ini site.yml --list-tasks
} > "$T/t01-syntax-and-lists.txt" 2>&1

{
  echo 'FIRST RUN'
  echo '$ ansible-playbook -i inventory.ini site.yml --forks 1'
  ansible-playbook -i inventory.ini site.yml --forks 1
  echo; echo 'Files the first run produced (under output/):'
  find output -type f | sort
  echo; echo '--- output/northlight-web-01/app.conf ---'; cat output/northlight-web-01/app.conf
  echo '--- output/rollout-checklist.txt ---'; cat output/rollout-checklist.txt
} > "$T/t02-playbook-first-run.txt" 2>&1

{
  echo 'SECOND RUN -- the same command, nothing changed by hand'
  echo '$ ansible-playbook -i inventory.ini site.yml --forks 1'
  ansible-playbook -i inventory.ini site.yml --forks 1
} > "$T/t03-playbook-second-run-idempotent.txt" 2>&1

{
  echo 'THIRD RUN -- after editing ONE variable by hand:'
  echo 'release_channel: stable -> beta in group_vars/webservers.yml'
  sed -i 's/release_channel: stable/release_channel: beta/' group_vars/webservers.yml
  grep release_channel group_vars/webservers.yml
  echo; echo '$ ansible-playbook -i inventory.ini site.yml --forks 1'
  ansible-playbook -i inventory.ini site.yml --forks 1
  echo; echo '--- output/northlight-web-01/app.conf after the change ---'
  cat output/northlight-web-01/app.conf
} > "$T/t04-playbook-after-variable-change.txt" 2>&1
echo "ansible lab done"
