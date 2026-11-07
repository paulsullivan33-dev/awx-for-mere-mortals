# Execution environments

Outcome: what an execution environment
is — the container image a job actually
runs inside — why AWX pins Ansible into
an image instead of installing it on the
server, and what the operator's release
says the defaults are. Documented-only,
with the defaults read from the operator
2.19.1 release the lab downloaded.

## The problem an image solves

Chapter 3's version output carried a
quiet warning: Ansible is a Python
program, with an interpreter version, a
Jinja version, and a set of collections —
and playbooks behave differently across
those. On a laptop that is your problem
to notice. On a shared server running
fifty teams' playbooks it is chaos: one
playbook needs a collection another
breaks on; an Ansible upgrade on Monday
changes a run's meaning on Tuesday,
under a schedule nobody is watching.

AWX's answer is to run each job inside a
**container image** — an **execution
environment** (EE) — that bundles
ansible-core, its Python, and a chosen
set of collections into one named,
versioned thing. The job template (or
its organization, or the whole system)
selects the image; the job runs in it;
the record names it. The run's meaning
is then reproducible in the strong
sense: same playbook revision, same
inventory, same image — same engine,
bit for bit, whoever launches it and
whenever the schedule fires.

Chapter 5's discipline survives the
move, unchanged: the image decides
*which* Ansible runs your playbook, and
the playbook is still the playbook.

## The defaults, from the release

The operator's installer defaults
(`roles/installer/defaults/main.yml` in
awx-operator 2.19.1; transcript
`awx-lab/transcripts/t09-operator-inspection.txt`)
name the images an install starts with:

- `ee_images` lists the stock execution
  environment, `quay.io/ansible/awx-ee:latest`,
  and a versioned one,
  `quay.io/ansible/awx-ee:<AWX version>` —
  the image released alongside the server.
- `_control_plane_ee_image` is that same
  versioned image: AWX's own control
  plane (its housekeeping jobs, its
  project updates) runs in an EE too.
- `ee_resource_requirements` gives each
  EE container a default request of
  100m CPU and 64Mi of memory — the
  scheduler's floor for a job's container,
  adjustable per install (chapter 13).

Teams build their own images — the
Ansible project's builder tooling exists
for exactly this — when their playbooks
need collections the stock image lacks.
An EE is a project's dependency list made
into an artifact: reviewed, built,
published to a registry, and pinned,
instead of installed by hand on a server
and forgotten.

## Where the jobs actually run

On the install chapter 13 describes, the
EE container is started by the task
machinery wherever the job is assigned:
on the control plane for small installs,
or on separate **execution nodes** and
**container groups** (a Kubernetes
namespace AWX may start job pods in, on
demand) for larger ones — the project's
clustering and container-group documents
in the AWX source describe both. The
**Receptor** mesh carries the work to
those nodes and the results back. From
the template author's chair, none of
this changes the job: pick the image,
launch, read the record. From the
operator's chair it is the scaling story
of chapter 13 — jobs are pods, and pods
are the cluster's problem.

One honest footnote from this guide's
own lab: the lab's ansible-core ran with
no EE at all, directly in a Python
virtual environment — the pre-container
way, and still the right way to develop
a playbook. The EE matters when the
playbook leaves your machine. That is
the same sentence as chapter 6's, about
projects, in a different accent.

Check: name the Ansible version, Python
version, and collections your most
important playbook needs, from memory.
If you cannot, that playbook's execution
environment currently lives in one
machine's install history — which is
the exact condition EEs exist to cure.
