# Installing the pieces you can install

Outcome: the two pieces of the AWX world
that install anywhere — ansible-core and
the `awx` client — installed for real and
proved by their version checks, and an
honest account of where the install of
AWX itself begins: someone else's
Kubernetes cluster, covered in chapter 13.

## The honest shape of "installing AWX"

There is no `apt install awx`, no tarball
you unpack and run. AWX is delivered as
container images and installed by its
**operator** onto a Kubernetes cluster:
you need the cluster first, then kubectl
access to it, then the operator, then a
small custom-resource file that asks for
an AWX. Chapter 13 walks that route from
the operator's own install documentation,
which the lab read in the 2.19.1 release.
This chapter installs what a laptop can
hold: the engine, and the client. Both
are genuinely useful on their own — the
engine is how you develop and test the
playbooks AWX will later guard, and the
client is how scripts talk to a server
once you have one.

## ansible-core, the route the lab used

The lab installed **ansible-core 2.21.6**
into a Python virtual environment (a
private folder of Python packages, so
nothing system-wide is touched) with
pip, Python's package installer:

```
python3 -m venv venv
venv/bin/pip install ansible-core
venv/bin/ansible --version
```

The version command is the check every
route must pass. The lab's answer
(transcript
`awx-lab/transcripts/t00-versions-and-ping.txt`):

```
ansible [core 2.21.6]
  config file = None
  configured module search path = [...]
  python version = 3.12.3 ...
  jinja version = 3.1.6
```

Two facts in that output matter later.
Ansible is a Python program — the
interpreter line is part of its identity,
which is why execution environments
(chapter 12) exist. And `config file =
None` means no `ansible.cfg` was steering
this run; the lab's results come from the
playbook and the command line alone.

Distribution packages for ansible-core
exist in most Linux distributions and
are a fine route; their versions lag the
pip route, and a version difference can
change defaults, so record which you
have. Your `ansible --version` outranks
this guide wherever the two disagree.

## awxkit, and the failure the lab kept

The client is also a pip package:

```
venv/bin/pip install awxkit
venv/bin/awx --help
```

The lab's first attempt at that second
command **failed**, and the failure is
kept on record (transcript
`awx-lab/transcripts/t08-awxkit-first-attempt-failure.txt`):

```
ModuleNotFoundError: No module named 'pkg_resources'
```

What happened: awxkit 24.6.1 imports a
small library called `pkg_resources`,
which older setuptools shipped and
setuptools 81 and later no longer do —
and pip had resolved setuptools 84.2.1
into the fresh environment. The fix is
one line, and awxkit's own deprecation
warning, once it runs, names it:

```
venv/bin/pip install 'setuptools<81'
```

After the pin, `awx --help` and
`awx --version` work (transcript
`awx-lab/transcripts/t05-awxkit-help-and-version.txt`);
`awx --version` answers `24.6.1` — the
*client's* version, matching the AWX
release it was built for. Notice what
that check does and does not prove: the
client is installed and alive. It proves
nothing about any server, because there
isn't one yet. Chapter 11 leans on that
distinction hard.

## What you cannot install here

A Kubernetes cluster is a prerequisite,
not a component. The operator's
documentation offers test routes — a
local cluster with kind or minikube for
evaluation — and chapter 13 describes
them as documented-only; this lab did
not run one, and a guide that needs a
real AWX for production will tell you to
learn the cluster first. If that sentence
stings, it is the most valuable one in
this chapter: AWX's install difficulty
is Kubernetes' install difficulty,
wearing an AWX badge (limits, chapter 16).

Check: `ansible --version` prints a
version, and `awx --version` prints
`24.6.1` (or your awxkit's version). If
the second fails with the `pkg_resources`
error, you have met the lab's own bug —
apply the setuptools pin and check again.
