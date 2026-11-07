# Glossary

The terms, collected in one place. Each
is defined the way this guide uses it.

**ansible-core** — The Ansible engine
itself: the `ansible` and
`ansible-playbook` commands, their
modules and language. The part that
runs playbooks, with or without AWX.
This lab ran version 2.21.6.

**ansible-runner** — The component AWX
uses to invoke Ansible for a job:
AWX assembles the run — playbook,
inventory, credentials, variables — and
ansible-runner performs it and streams
the events back.

**AWX** — The open-source control room
over Ansible: web interface, REST API,
and task engine for governing who runs
playbooks, when, with what credentials,
with a record kept. The upstream of Red
Hat Ansible Automation Platform.

**awxkit** — The Python package that
provides the `awx` command-line client
for AWX's API. This lab ran version
24.6.1 — and, with no server to reach,
mostly ran its error messages.

**Check mode** — Ansible's dry run:
reports what a playbook would change
and changes nothing. A job template's
"Check" job type.

**Credential** — A secret held by AWX —
a password, SSH key, or token — stored
encrypted and handed to a job at run
time. Usable by people who cannot see
it, via the Use role.

**Custom resource** — A Kubernetes
object of a kind defined by an
operator's CRD. An AWX install is one:
`kind: AWX`, a name, and a spec.

**Custom resource definition (CRD)** —
The file that teaches Kubernetes a new
kind of object. The AWX CRD in
operator 2.19.1 runs to 2,054 lines.

**Execution environment (EE)** — The
container image a job runs inside,
bundling ansible-core, its Python, and
chosen collections into one pinned,
named artifact.

**Handler** — An Ansible task that runs
only when notified by a changed task —
the conventional way to restart a
service when, and only when, its
configuration moved.

**Idempotent** — Safe to run again: a
playbook whose second run, with nothing
changed in between, changes nothing.
Measured in this lab: changed 5, then 0.

**Inventory** — The list of hosts a
playbook may run against, with groups
and variables. In AWX, a central object
that can be synced from outside sources.

**Job** — One run of a job template,
with its launcher, timing, full output,
and result — the record itself.

**Job template** — The stored, launchable
definition of a run: project, playbook,
inventory, credentials, and options,
some fixed and some prompted.

**Operator** — A Kubernetes program that
builds and tends a system from a custom
resource. AWX's operator is written in
Ansible and shipped as awx-operator.

**Organization** — AWX's outer box:
projects, inventories, credentials, and
templates belong to one, and roles are
granted inside one.

**Playbook** — The Ansible file that
describes desired state as plays and
tasks. The thing that runs, under AWX
or not.

**Project** — An AWX object holding
playbooks, usually a working copy of a
version-control repository that AWX
keeps updated.

**Project update / inventory update** —
The refresh jobs by which AWX brings a
project's or inventory's contents in
step with their source. Each is itself
a recorded job.

**Receptor** — AWX's mesh networking
component, carrying work from the
control plane to execution nodes and
results back.

**Recap** — The closing summary of an
Ansible run: per host, how many tasks
were ok, changed, unreachable, failed.
The line this guide quotes most.

**Role** — In AWX, a verb granted to a
user or team on one object: Admin,
Execute, Use, Update, Read, and kin.

**Survey** — A form attached to a job
template; its answers become the job's
extra variables at launch.

**Task (two senses)** — In Ansible, one
step of a playbook. In AWX's plumbing,
also the name of the deployment that
dispatches jobs. The chapters say which
is meant.

**Workflow template** — A job template
that chains other job templates into a
graph, branching on success or failure,
with optional approvals.
