# What AWX is

By the end of this chapter you can say,
in one sentence, what AWX takes off your
hands — and state the one rule that
decides whether it will help your team
or merely give its mistakes a bigger
stage. You can also say, honestly, what
this guide's lab did and did not run.

## The problem: a playbook only one person can run

**Ansible** is a tool for describing the
state you want a machine to be in — this
package installed, that file with these
contents, this service running — in a
text file called a **playbook**, and
then making real machines match it. One
person with a laptop can run a playbook
against a hundred hosts with one command:

```
ansible-playbook -i inventory.ini site.yml
```

This guide's lab ran exactly that command,
for real, in chapter 4. It works. And the
moment a second person needs it, the
questions start:

- The playbook needs a password or an SSH
  key. Where does the second person get
  it — a chat message? A shared spreadsheet?
- A junior operator may restart the web
  servers, but must not touch the database
  playbook. Who enforces that? Goodwill?
- The security update should run every
  Tuesday at 03:00. Whose laptop stays on?
- Three months later, an auditor asks who
  ran the firewall change in March. The
  answer lives in one person's shell
  history, if it lives anywhere.

None of these are Ansible problems.
Ansible did its job. They are *control*
problems — about people, permission,
timing, secrets, and records.

## What AWX is

**AWX** is the control room built over
Ansible. The project describes itself as
providing "a web-based user interface,
REST API, and task engine built on top of
Ansible", and that sentence is the whole
map:

- A **web interface** where playbooks,
  host lists, and credentials are held
  centrally, and a run is a button —
  with a form for the choices the run
  is allowed to make.
- A **task engine** that runs the
  playbooks itself, on its own schedule
  as well as on demand, and keeps the
  full output of every run.
- A **REST API** (a way for programs to
  ask AWX to do things over HTTP) under
  both of those, so anything the button
  can do, a script can do.
- **Access control**: users, teams, and
  roles that decide who may run which
  playbook, against which hosts, using
  which credentials — where the person
  running the job never sees the
  credential itself.

AWX is free and open source. It is the
upstream project from which Red Hat's
commercial Ansible Automation Platform
is built, in the same way Fedora stands
to Red Hat Enterprise Linux: the
community version, moving faster,
supported by its community.

## The rule: control, not capability

Everything AWX adds sits *around* the
run, never inside it. When a job starts,
AWX hands a playbook, an inventory, and
a set of credentials to the same Ansible
engine you can run from a laptop — in
AWX's case, through a component called
ansible-runner, a fact the AWX source
states in its own integration notes —
and Ansible does the work. So:

> **AWX adds nothing to what Ansible can
> do. It adds control over who may run
> it, when, with what credentials, and a
> record that it happened. The playbook
> is still the thing that runs — so a bad
> playbook under AWX is just a bad
> playbook with an audience.**

Hold onto both halves. The first half is
why AWX is worth having: the questions in
the section above are real, and AWX
answers them properly. The second half is
why AWX is not magic: it will not make a
playbook **idempotent** (safe to run
twice, changing nothing the second time),
will not test it, and will not stop it
doing damage — it will run a destructive
playbook punctually, as the authorised
user, with the correct credential, and
keep an excellent record of the disaster.
Chapter 5 measures idempotency on the
lab playbook precisely because AWX
cannot give it to you; it can only show
you, in the record, whether you had it.

## What this guide's lab ran — and did not

This guide is built on an unusual lab,
and it says so everywhere it matters:

- **Ran for real:** ansible-core 2.21.6,
  the engine AWX schedules, running this
  guide's playbook against two fictional
  hosts on loopback (chapters 4 and 5);
  and awxkit 24.6.1, the official `awx`
  command-line client, exercised against
  the empty address where a server would
  be (chapter 11).
- **Read for real:** the awx-operator
  2.19.1 release — the software that
  installs AWX on Kubernetes — its
  manifests, defaults, and samples,
  quoted in chapter 13.
- **Never ran:** AWX itself. It needs a
  Kubernetes cluster; this lab has none
  and did not pretend to. The web UI, job
  launches, surveys, and everything else
  in the running product are
  documented-only in this guide, taken
  from the official AWX user guide for
  version 24.6.1 and the operator's own
  documentation, and listed as such in
  `criteria.md`.

That split is not an apology; it is the
shape of the tool. Most of what a new
AWX user must understand first — that
the playbook is the product and AWX is
its control room — is exactly the part
the lab *could* run.

Check: state the rule in your own words,
and name the four things AWX controls —
who, when, credentials, record. Then say
which parts of this guide's lab ran and
which were only read. If you can do all
three, you have this chapter.
