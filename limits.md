# Limits

Outcome: the honest boundary of the
tool, in one place. This chapter mixes
two kinds of statement, and labels each:
**[manifests/docs]** — read in the
operator 2.19.1 release or the AWX
documentation this lab downloaded; and
**[reasoning]** — this guide's own
conclusion from how the pieces fit,
offered as argument, not as citation.

## AWX is a tenant on Kubernetes, not a program you install [manifests/docs]

There is no AWX binary for your laptop,
no package for your server. The release
this lab read installs an operator onto
a Kubernetes cluster you already have,
and AWX lives there as pods, services,
and a database, sized by fields on a
custom resource (chapter 13). Every
prerequisite of the cluster is a
prerequisite of AWX: the cluster itself,
storage that can serve its claims,
ingress, a registry it can pull from,
and people who can run all of that. If
the cluster is beyond you, AWX is too —
not as an insult but as arithmetic: you
would be learning two systems, and the
harder one first. [reasoning] For a
small team, a neighbour from chapter 15
may fit the same need at a tenth of the
operational weight.

## It does not make playbooks idempotent, tested, or safe [reasoning, measured]

Chapter 5 is the evidence in miniature:
idempotency is a property the lab
measured in a playbook's recaps —
changed 5, then 0 — before AWX entered
the story at all. AWX contains no
machinery that inspects a playbook for
correctness, no test runner that stands
between a template and its fleet, no
sandbox a launch must survive first.
Check mode reports what a run *would*
change; nothing forces anyone to look.
A playbook that deletes, duplicates, or
exposes will do so under AWX exactly as
designed — punctually, with the right
credential, leaving an exemplary record.
The record is the mitigation; it is not
a prevention.

## The credential store is a vault people must still administer [manifests/docs + reasoning]

Chapter 8: secrets are encrypted in the
database, their protection resting on a
secret key the install manages as a
Kubernetes secret, and the whole
arrangement administered by people with
AWX and cluster rights. [manifests/docs]
Rotation, revocation, external-vault
wiring, and reviewing who holds Use on
what are continuing human work
[reasoning]. AWX ends the era of secrets
in chat messages. It does not end the
job of being their keeper, and an
unadministered AWX — stale credentials,
unreviewed roles, an admin password
from the first install — is a vault
with the door propped open.

## Scale and high availability are cluster questions [manifests/docs]

The defaults in the release are a
single replica (`replicas: 1`) with
small resource requests; the samples
show how limits are raised, and the AWX
documents describe multi-node capacity,
instance groups, and the Receptor mesh
(chapters 12 and 13). Nothing in AWX
itself makes one replica into three, a
single PostgreSQL into a replicated
one, or a cluster in one room into a
service that survives the room. Those
are properties of the Kubernetes
platform underneath and of the sizing
choices on the custom resource —
budgeted, built, and tested by the
people who run the cluster. [reasoning]
An AWX that must not go down is a
platform project, not an install.

## Smaller print, honestly stated

- **The record is only as complete as
  the work done inside AWX.** [reasoning]
  A playbook run from a laptop leaves no
  job; one person's direct SSH session
  leaves no trace at all. AWX governs
  the runs it launches — the discipline
  of launching work *through* it is
  yours, and partial adoption gives a
  partial audit trail that looks total.
- **The operator's defaults are starting
  points.** [manifests/docs]
  `projects_persistence: false`, single
  replicas, requests without limits in
  the default path — a demo-shaped
  install (its smallest example is
  literally named `awx-demo`) that
  production use must deliberately grow.
- **Version gravity is real.**
  [manifests/docs + lab] The client, the
  server, the operator, and the execution
  environments are versioned together —
  this lab's awxkit 24.6.1 matches the
  operator's AWX 24.6.1, and its first
  failure was a *dependency's* version,
  not AWX's at all. Budget for upgrades
  as a set, and expect small breakages
  at the seams (chapter 3's setuptools
  pin is the type specimen).
- **AWX governs Ansible-shaped work.**
  [reasoning] Its objects presume
  playbooks, inventories, and hosts. A
  task that is really "run this script
  somewhere" fits awkwardly, and forcing
  it in buys the overhead without the
  model. Chapter 15's Rundeck exists for
  that estate.

Check: name the limit in this chapter
that would bite your team first, and
whether it is labelled manifests/docs
or reasoning. If it is reasoning, you
are allowed to argue with it — that is
what the label is for.
