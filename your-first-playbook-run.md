# Your first playbook run

Outcome: a real playbook, run for real —
the same kind of run AWX exists to
schedule — with its output read line by
line. Everything in this chapter was run
in the lab; the transcripts are the
evidence.

## The fixture: a small co-op rolls a change

The lab's project belongs to the
**Northlight Hosting Co-op**, an invented
small hosting co-operative. Northlight
runs two web servers, and it is rolling a
small configuration change to both: a new
application configuration file, a login
banner, and a note in the rollout
checklist, with a record kept that the
service was told to restart. The project
is in `awx-lab/fixtures/northlight/`:

- `inventory.ini` — the hosts. Two
  fictional names, `northlight-web-01`
  and `northlight-web-02`, in one group,
  `webservers`. In the lab both point at
  `127.0.0.1` with a local connection, so
  the playbook configures the machine it
  runs on, twice over, and touches no
  other machine. In Northlight's real
  life — and in yours — those names would
  be real hosts reached over SSH. That
  difference is the inventory's business,
  not the playbook's (chapter 7).
- `group_vars/webservers.yml` — the
  variables: the co-op's name, the
  application name, its port (8080, a
  value in a config file; nothing listens
  anywhere in this lab), and the release
  channel.
- `templates/` — two templates, the
  application configuration and the
  banner, with blanks the variables fill.
- `site.yml` — the playbook itself: five
  tasks and one **handler** (a task that
  runs only when another task reports a
  change and *notifies* it — here, the
  "record a service restart" task,
  notified by the configuration deploy).

## Step one: prove the hosts answer

Before any playbook, the lab asked both
hosts to say hello, with Ansible's
`ping` module — which, despite the name,
is not a network ping; it connects the
way Ansible connects and runs a stub of
Python on the far end:

```
ansible webservers -i inventory.ini -m ping
```

Both fictional hosts answered `pong`
with `"changed": false` (transcript
`awx-lab/transcripts/t00-versions-and-ping.txt`).
The transcript also keeps the interpreter
warnings Ansible printed — it discovered
the lab environment's Python on each
"host". On real hosts that warning is
worth reading; here it is the sound of
the loopback fiction working.

## Step two: prove the playbook is sound

Three read-only checks come before any
run, and the lab captured all three
(transcript
`awx-lab/transcripts/t01-syntax-and-lists.txt`):

```
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml --list-hosts
ansible-playbook -i inventory.ini site.yml --list-tasks
```

The first answers only `playbook: site.yml`
— no errors found. The second names the
play, its pattern `webservers`, and the
two hosts it matched. The third lists
the five tasks in order — directory,
configuration, banner, checklist,
report — so a reader can see the run's
shape before anything changes. Hold
these three in mind when chapter 9
arrives: a job template in AWX is, in
large part, a stored promise to run
checks like these and then this command,
with chosen options.

## Step three: the run

```
ansible-playbook -i inventory.ini site.yml --forks 1
```

(`--forks 1` runs the two local "hosts"
one at a time so they do not race on the
shared checklist file; on real, separate
hosts it would not be needed.)

The full output is transcript
`awx-lab/transcripts/t02-playbook-first-run.txt`.
Its shape, per host: a facts task
(Ansible first asks each host what it
is), the five tasks — each reporting
`changed` on this first run — then the
handler, run once, because the
configuration task notified it. The last
lines are the ones this guide will keep
quoting, the **play recap**:

```
northlight-web-01 : ok=7  changed=5  unreachable=0  failed=0
northlight-web-02 : ok=7  changed=5  unreachable=0  failed=0
```

Read it as a sentence: each host
completed seven tasks (five tasks, the
facts task, and the handler), five of
them changed something, none failed.
The files are on disk to prove it — the
transcript lists them and shows the
rendered configuration, variables filled:

```
app_name=northlight-status-page
listen_port=8080
release_channel=stable
operator=Northlight Hosting Co-op
```

This — this exact command, this recap —
is the atom AWX is built from. A job in
AWX is this run, started by a template
instead of a person, with a credential
AWX supplied, on a schedule AWX kept,
leaving a record AWX stored. Nothing
about the run itself is different.
Chapter 1's rule, at ground level.

Check: run the three read-only checks on
the fixture project and then the playbook
itself, in a copy of the folder. Your
recap should match: ok=7, changed=5 per
host. If a task reports `failed`, the
recap says so and the output above it
says why — read that before re-running.
