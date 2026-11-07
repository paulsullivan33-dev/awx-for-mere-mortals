# AWX for Mere Mortals

Ansible is easy to start and hard to
share. One person writes a playbook that
works. Then the team grows, and the
questions change. Who else may run this?
With which password — the one in whose
shell history? At 2 a.m., or only when
someone presses a button? And afterwards,
who can prove what ran, where, and what
it changed? **AWX** is the control room
built over Ansible to answer those
questions: a web interface, a REST API,
and a task engine that hold your
playbooks, inventories and credentials in
one place, run playbooks for the people
you allow, on the schedule you set, and
keep the record.

One rule governs everything it does, and
this guide states it in chapter 1 and
keeps pointing back to it: **AWX adds
nothing to what Ansible can do — it adds
control over who may run it, when, with
what credentials, and a record that it
happened. The playbook is still the thing
that runs, so a bad playbook under AWX is
just a bad playbook with an audience.**
AWX cannot make a playbook correct,
idempotent, or safe. It can only decide
who launches it, hand it the right
secrets without showing them, and write
down the result.

This guide is unusually honest about its
own lab, because the honest version is
the useful one. **AWX itself never ran
in this lab.** The full product runs on
Kubernetes, and this build machine has
no cluster; the guide does not fake one.
What the lab ran for real is the engine
AWX schedules: **ansible-core 2.21.6**,
installed in a Python virtual
environment, running a real playbook —
tasks, a template, variables, a handler —
against an inventory of two fictional
hosts on loopback, twice, so the second
run's `changed=0` is measured, not
asserted. The lab also installed
**awxkit 24.6.1**, the official `awx`
command-line client, and pointed it at
the empty port where an AWX server would
be: its exact connection-refused failure
is in the transcripts, because a client
with nothing to talk to is the clearest
possible proof of what the client is.
And the lab downloaded and read the real
thing it could not run: the
**awx-operator 2.19.1** release (the
operator released with AWX 24.6.1) —
its custom resource, its manifests, its
default images and resource requests —
quoted in chapter 13 from the files
themselves. Everything about the running
product — the web UI, job templates,
surveys, access control, schedules,
notifications — is described from the
official AWX documentation and those
manifests, and labelled documented-only
wherever it appears. `criteria.md` keeps
the full ledger.

## What this guide covers

- [**What AWX is**](what-awx-is.md) —
  the sharing problem, what a control
  room takes over, and the one rule
- [**The moving parts**](the-moving-parts.md) —
  projects, inventories, credentials,
  job templates, the web and task
  containers, and the database beneath
- [**Installing the pieces you can install**](installing-the-pieces.md) —
  ansible-core and awxkit for real, and
  where the AWX install itself begins
- [**Your first playbook run**](your-first-playbook-run.md) —
  ping, syntax check, and a full run of
  the lab playbook, with its real output
- [**Run it again**](run-it-again.md) —
  idempotency measured: changed 5, then
  changed 0, then changed 2 when one
  variable moves
- [**Projects**](projects.md) — where
  playbooks live, and how AWX keeps its
  copy in step with your repository
- [**Inventories**](inventories.md) —
  the hosts, from the lab's two-line
  inventory to synced sources
- [**Credentials**](credentials.md) —
  secrets the runner can use but never
  see, and the vault somebody still
  administers
- [**Job templates, surveys and schedules**](job-templates.md) —
  the launch button, the form that feeds
  it, and the clock that presses it
- [**Users, teams and roles**](users-teams-and-roles.md) —
  who may run what: the control in the
  control room
- [**The API and the awx command**](the-api-and-awxkit.md) —
  the REST API underneath everything,
  and the client this lab ran against
  an empty port
- [**Execution environments**](execution-environments.md) —
  the container images a job actually
  runs inside
- [**AWX on Kubernetes**](awx-on-kubernetes.md) —
  the operator, the custom resource,
  and what it deploys, read from the
  release itself
- [**Real jobs**](real-jobs.md) — the
  co-op rollout assembled as an AWX job,
  and two more jobs in the same shape
- [**The neighbours**](the-neighbours.md) —
  plain Ansible, the commercial platform,
  Semaphore, Rundeck, and a scheduler
  with SSH
- [**Limits**](limits.md) — a tenant on
  Kubernetes, not a program you install,
  and the rest of the honest boundary
- [**Troubleshooting**](troubleshooting.md) —
  the connection refused, the job that
  changes everything every time, and the
  credential nobody may use
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Running Kubernetes itself — AWX is a
tenant there, and chapter 13 says
plainly that if the cluster is beyond
you, AWX is too. Writing playbooks is
covered only as far as this guide's one
lab playbook; Ansible the language is a
guide of its own. The commercial Red Hat
Ansible Automation Platform, AWX's
downstream relative, is characterised in
chapter 15, not taught. Nothing here
runs anything on anyone else's machines:
the lab's hosts are fictional, and its
traffic is loopback talking to itself.

## How to use this guide

Read chapter 1 for the rule and chapter
2 for the map of parts. Chapters 3 to 5
are the live spine: install the engine,
run the playbook, run it again and read
the numbers. Chapters 6 to 12 describe
the control room itself — documented-only,
each anchored to something the lab
touched: the same playbook, the same
inventory, the same client. Chapter 13
reads the operator's manifests, which
are real files you can download and
check. The lab lives in `awx-lab/`: the
fictional Northlight project in
`awx-lab/fixtures/`, the drivers in
`awx-lab/drivers/`, and every claim's
evidence in `awx-lab/transcripts/`; its
distilled commands are
`examples/commands.txt` and its notes
`examples/lab-notes.txt`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Ansible for Mere Mortals](https://paulsullivan33-dev.github.io/ansible-for-mere-mortals/)
- [Kubernetes for Mere Mortals](https://paulsullivan33-dev.github.io/kubernetes-for-mere-mortals/)
- [Git for Mere Mortals](https://paulsullivan33-dev.github.io/git-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/awx-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/awx-for-mere-mortals/blob/main/LICENSE-CODE).
