# The neighbours

Outcome: where AWX sits among the tools
that touch the same problem, each
characterised on its own terms — what it
is, what it governs, what it costs — so
"should we use AWX?" becomes a question
with edges. Characterised from each
project's own description, not
benchmarked; none of these were run in
this lab.

## Plain Ansible, well kept

The baseline, and this guide's lab: playbooks
in Git, a disciplined operator, a bastion
host, `ansible-playbook` by hand or from
a scheduler. It governs nothing by
itself — access is SSH access, records
are logs you arrange, secrets are files
you protect — and for one or two
operators it is not a lesser choice, it
is the correct size. AWX's case begins
exactly where this stops scaling: the
third operator, the first auditor, the
first "who ran that?" with no answer.
Everything AWX adds, it adds to this;
if this is broken — playbooks nobody
dares run twice — fix this first
(chapters 4 and 5).

## Red Hat Ansible Automation Platform

AWX's commercial downstream: the same
ideas, productised — a supported
controller (AWX's direct relative),
event-driven automation, a services
catalogue, content collections with
support behind them, and a subscription
price. Organisations choose it when the
question is not "does it work?" but
"who answers when it doesn't, and what
does our auditor accept?". Choosing
between them is a support and lifecycle
decision, not a capability contest —
and skills transfer almost entire,
because the concepts, objects, and API
shape are the same family.

## Semaphore

An open-source web interface for Ansible
(and Terraform and friends) with a much
smaller footprint: a single Go binary
and a database, no Kubernetes anywhere.
It offers task templates, schedules,
access control, and history — a real
subset of AWX's control room at a
fraction of the operational weight. For
a team that wants a launch button and a
record without adopting a cluster,
Semaphore is the honest comparison, and
often the right answer. What it does
not attempt is AWX's scale story —
execution meshes, container groups,
operator-managed everything.

## Rundeck

A job scheduler and runbook automation
platform, older and broader than Ansible:
it runs *steps* — commands, scripts,
and yes, Ansible playbooks among many
integrations — with access control,
schedules, and history, aimed at
operations teams whose estate is not
Ansible-shaped. Choose it when the unit
of work is "the runbook", mixed across
tools; choose AWX when the unit of work
is the playbook and Ansible is the
estate's native language.

## Cron, systemd timers, and a CI system

The neighbours nobody buys: a timer on a
bastion host running `ansible-playbook`
covers scheduling; a CI system (GitLab
CI, GitHub Actions, Jenkins) covers
launch-on-event, records, and secrets
management surprisingly far, and many
teams' "control room" is a pipeline with
a manual approval step. What these lack
is the inventory-and-credential model
and the always-on, purpose-built record
— and what they offer is that you
already run them. AWX must beat *your*
incumbent, not a vacuum: if the
pipeline answers who, when, with what,
and keeps the record, the honest
verdict may be to keep it.

## The one-line test

Each neighbour answers chapter 1's four
questions differently — who, when, with
what credentials, and what record. Line
the answers up for your team's actual
size and auditors, and the choice
usually makes itself. AWX is the answer
when the questions have outgrown a
laptop and a pipeline but the estate is
Ansible to the bone.

Check: for your team, write the four
answers twice — once for what you run
today, once for AWX. The gaps in the
first column are the entire case for
moving; if there are no gaps, this
guide has just saved you a Kubernetes
cluster.
