# Run it again — idempotency

Outcome: the single most important habit
in all of automation, measured on the
lab playbook: run the same thing twice,
and read the difference — then change
one variable and read it again. All run
for real; the numbers below are the
transcripts' numbers.

## The word

A playbook is **idempotent** when running
it a second time, with nothing changed
in between, changes nothing. Each task
describes a desired state — this file,
with these contents — rather than a
command to perform, and Ansible reports,
honestly, whether the machine already
matched (`ok`) or had to be moved
(`changed`). Idempotency is not a
courtesy. It is what makes automation
safe to schedule: a job that runs every
night must be a job whose second,
third, and hundredth runs are boring.

And it is a property of the playbook,
not of the tool that launches it —
chapter 1's rule again. AWX will happily
schedule a non-idempotent playbook every
night and keep beautiful records of the
mess. This chapter is how you know,
before AWX ever sees a playbook, whether
it deserves scheduling.

## The second run

The lab ran the identical command again,
immediately (transcript
`awx-lab/transcripts/t03-playbook-second-run-idempotent.txt`).
Every task reported `ok`. The handler
did not run at all — nothing notified
it, because nothing changed. The recap:

```
northlight-web-01 : ok=6  changed=0  unreachable=0  failed=0
northlight-web-02 : ok=6  changed=0  unreachable=0  failed=0
```

Two differences from chapter 4's run,
and both are the lesson:

- **ok dropped from 7 to 6.** The seventh
  task last time was the handler. A
  handler that runs on a no-change run
  would be a bug in the playbook's logic;
  its absence here is the design working.
- **changed dropped from 5 to 0.** The
  directory exists, the files match their
  templates, the checklist line is
  present. Ansible compared desired state
  with actual state and found nothing to
  do, on both hosts, in every task.

That pair of recaps — 5, then 0 — is the
certificate a playbook should carry into
AWX. When you evaluate any playbook,
yours or a stranger's, this is the test:
twice in a row, and the second run must
be all `ok`.

## The third run: change one thing

Then the lab changed exactly one
variable — `release_channel: stable`
became `beta` in
`group_vars/webservers.yml` — and ran a
third time (transcript
`awx-lab/transcripts/t04-playbook-after-variable-change.txt`):

```
northlight-web-01 : ok=7  changed=2  unreachable=0  failed=0
northlight-web-02 : ok=7  changed=2  unreachable=0  failed=0
```

Changed=2, and the transcript shows
precisely which two: the configuration
template (the one file the variable
appears in) and the handler it notified.
The banner, which does not use that
variable, stayed `ok`. The directory
stayed `ok`. This is the granularity
that makes Ansible's reporting worth
reading: a change's blast radius,
itemised per host, in the run's own
output — the same output an AWX job
would store, word for word.

Notice, too, what this third run is in
AWX terms. A variable changed; a run
followed; only the affected tasks
moved. Chapter 9's surveys and schedules
are ways of producing exactly this
moment — a person answering a form, or
a clock reaching Tuesday — with the
variables set by the template instead
of by an editor. The engine underneath
does not know or care which happened.

## The failure mode to fear

A task written as a raw command — "append
this line", "restart the service" — with
no state to compare reports `changed`
every time, or worse, *makes* a change
every time: a duplicated line, a service
bounced nightly for no reason. Under
plain Ansible you notice, because you
read recaps. Under AWX the same playbook
runs at 03:00 while nobody reads
anything, which is why the check belongs
here, before the control room: **run it
twice on your own machine first.** AWX
adds the audience; it does not add the
discipline.

Check: run the lab playbook twice in a
fresh copy and compare recaps — changed
must fall to 0. Then change
`release_channel` and run once more:
changed must be exactly 2 per host, and
the rendered `app.conf` must say `beta`.
If your numbers differ, a task is not
describing state — find it in the
transcript before you trust the playbook
anywhere else.
