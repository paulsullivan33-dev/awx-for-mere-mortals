#!/bin/sh
# Run the awxkit half of the lab: the official AWX command-line
# client, with NO AWX server anywhere to talk to. The failures
# are the evidence. Usage: run-awxkit-lab.sh <venv-bin-dir> <transcript-dir>
set -u
VENV_BIN="$1"; T="$2"
export PATH="$VENV_BIN:$PATH"
mkdir -p "$T"
{
  echo '$ pip show awxkit | grep -E "^(Name|Version)"'
  pip show awxkit 2>/dev/null | grep -E '^(Name|Version)'
  echo; echo '$ awx --help'; awx --help 2>&1 | grep -v pkg_resources | grep -v '^  import pkg_resources'
  echo; echo '$ awx --version'; awx --version 2>&1 | grep -v pkg_resources | grep -v '^  import pkg_resources'
} > "$T/t05-awxkit-help-and-version.txt" 2>&1
{
  echo '$ awx config   (no server configured, no environment set)'
  env -u CONTROLLER_HOST -u CONTROLLER_USERNAME -u CONTROLLER_PASSWORD -u CONTROLLER_TOKEN \
    awx config 2>&1 | grep -v pkg_resources | grep -v '^  import pkg_resources'
  echo; echo '$ CONTROLLER_HOST=https://127.0.0.1:18082 awx config'
  CONTROLLER_HOST=https://127.0.0.1:18082 awx config 2>&1 | grep -v pkg_resources | grep -v '^  import pkg_resources'
} > "$T/t06-awxkit-config.txt" 2>&1
{
  echo '$ awx --conf.host https://127.0.0.1:18082 -k ping'
  echo '(127.0.0.1:18082 is this lab'\''s assigned loopback port; nothing listens there,'
  echo ' because no AWX server ran in this lab -- that is the point of the test.)'
  timeout 30 awx --conf.host https://127.0.0.1:18082 -k ping 2>&1 | grep -v pkg_resources | grep -v '^  import pkg_resources' | sed 's/\x1b\[[0-9;]*m//g' | head -12
  echo; echo '$ awx users list   (default host https://127.0.0.1:443)'
  timeout 30 awx users list 2>&1 | grep -v pkg_resources | grep -v '^  import pkg_resources' | sed 's/\x1b\[[0-9;]*m//g' | head -12
} > "$T/t07-awxkit-no-server.txt" 2>&1
echo "awxkit lab done"
