# Troubleshooting

Outcome: the surprises this guide's lab
actually met, and the ones the
documented product reliably produces,
each with the check that names it.
Entries from the lab say so; the rest
are the documentation's failure modes,
labelled documented.

## "awx fails with ModuleNotFoundError: No module named 'pkg_resources'" — lab

You have met chapter 3's bug, kept in
transcript
`awx-lab/transcripts/t08-awxkit-first-attempt-failure.txt`.
awxkit 24.6.1 imports `pkg_resources`;
setuptools 81 and later no longer ship
it, and a fresh environment today
resolves a newer setuptools. Pin it —
`pip install 'setuptools<81'` — in the
environment that holds awxkit. The
client then works, warning you about
the deprecation, and naming the same
pin itself.

## "Connection refused" from any awx command — lab

Read the failure the way chapter 11
did: it names the host, the port, and
`/api/`. Then ask the only question
that matters — *is a server supposed to
be listening there?* In this lab the
answer was no, by design. In yours,
work the list: wrong `--conf.host` or
`CONTROLLER_HOST` (run `awx config` and
read the `base_url` it confesses); the
server not up (check the AWX pods and
service in the cluster, chapter 13);
the port or ingress not what the client
assumes (the default is 443 on
`127.0.0.1` — almost never a real
install's address). The client is
blameless in this entry more often than
not; it is a telephone reporting that
nobody picked up.

## "It worked from my laptop" — documented

The playbook that runs by hand and fails
as a job has a short list of usual
causes, all from the chapters that built
the job: it assumed your SSH key (the
template's credential is a different
one, chapter 8), your working directory
or a path on your machine (the project
is a fresh copy on the server,
chapter 6), a collection your laptop has
and the execution environment does not
(chapter 12), or a variable you used to
type that is now a survey question
nobody set (chapter 9). The job's own
output is the first witness: AWX keeps
the full stream, and the failing task
in the record says more than the
recap's `failed=1` ever will.

## "Every run changes everything" — lab, one level down

Chapter 5's disease, presenting in the
control room: the job history shows
`changed` on every run, so schedules
fire handlers, restarts, and
notifications nightly for no reason.
The diagnosis is not in AWX at all —
run the playbook twice by hand and read
the second recap. A task that reports
changed forever is describing a command,
not a state; fix the task (or give it an
honest `changed_when`), and the job
history goes quiet by itself. Do not
treat this in AWX by narrowing the
schedule: you would be hiding the one
signal the record exists to give you.

## "The operator says AWX exists, but nothing answers" — documented

The custom resource applied cleanly and
the demo file's promise has not
arrived. The operator's world has its
own order of suspicion: are the AWX
pods pending (storage class and the
8Gi PostgreSQL claim are the classic
first stop, chapter 13), failing to
pull images (registry access; the
operator's install doc names
ImagePullBackOff and its usual cause),
or crash-looping on a secret or config
map the install expected to find? The
operator's logs and the install
documentation's troubleshooting section
are the route; this guide's contribution
is upstream of all of it — confirm from
chapter 13's transcript that the
deployment you *asked* for is the one
you think you asked for, spec field by
spec field, before blaming the cluster.

## "A user can launch but the job fails on credentials" — documented

Launch permission and credential
permission are separate grants
(chapter 10): Execute on the template
lets the user press the button; the
template must also be able to *use* its
credential and inventory. And the
mirror image — a user who "cannot see"
a credential launching jobs with it
perfectly well — is not a bug at all.
It is chapter 8 working as designed:
Use without sight. Learn to tell the
two apart before granting anything
broader; Admin is the usual overcorrection,
and chapter 16 has views about it.

## "The survey accepted that?" — documented

A free-text survey answer lands in extra
variables, and extra variables outrank
nearly everything (chapter 9). If a job
did something the playbook's defaults
forbid, read the job's recorded
variables before the playbook: the form
is part of the system, and an
unvalidated text field wired to a
powerful variable is a permission, not
a convenience. Constrain the question —
a choice list, a pattern, a length — or
remove the variable's teeth.

Check: for the last AWX-world failure
you met, name which entry of this page
it was — and whether its fix lived in
the client, the playbook, the template,
the roles, or the cluster. The page's
whole claim is that the naming is the
diagnosis, most of the time.
