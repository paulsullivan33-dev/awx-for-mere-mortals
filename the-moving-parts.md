# The moving parts

Outcome: a map of the parts inside AWX,
so that when a later chapter names a
thing — a project, a credential, a job
template — you know what it holds, what
it touches, and which parts of the map
this guide's lab ran, read, or only read
about.

## The parts you arrange

These are the objects a user creates and
combines. Chapters 6 to 10 take them one
at a time; all of them are
documented-only in this guide, because
they live inside the running product.

- **Organization.** The outer box.
  Projects, inventories, credentials, and
  templates belong to an organization,
  and access is granted inside one. A
  one-team shop has one organization and
  forgets the concept; a shared AWX
  serving several teams lives by it.
- **Project.** A bundle of playbooks,
  usually a copy of a version-control
  repository (a **Git** repository, most
  often) that AWX keeps in step with the
  original. Chapter 6.
- **Inventory.** The list of hosts a
  playbook may run against, with their
  groups and variables. The lab's
  inventory is a six-line file; an AWX
  inventory is the same idea held
  centrally, and it can be synced from
  outside sources. Chapter 7.
- **Credential.** A secret — a password,
  an SSH key, a cloud token — stored
  encrypted in AWX's database and handed
  to a job at run time. The person who
  launches the job uses the credential
  without ever seeing it. Chapter 8.
- **Job template.** The launch button:
  one playbook from one project, one
  inventory, one or more credentials,
  plus the options a run may be given —
  some fixed, some asked for at launch
  through a form called a **survey**, and
  some set by a **schedule**. A
  **workflow template** chains several
  job templates into one larger run.
  Chapter 9.
- **Job.** One actual run of a template:
  its output, its timing, its result,
  kept. The record the rule in chapter 1
  promises is, in practice, the list of
  jobs.

## The parts that run

Underneath the objects sits the product
itself. This layer the lab *read*, in the
operator's manifests (chapter 13), and
the file names below are the operator's
own:

- **The web deployment** (`web.yaml.j2`
  in the operator's templates): the
  container that serves the web interface
  and the API, with a **Redis** container
  beside it for messaging and a logging
  container. It runs the AWX image,
  `quay.io/ansible/awx`.
- **The task deployment**
  (`task.yaml.j2`): the container that
  does the running — receives jobs,
  prepares them, and dispatches the work.
  Inside a job, the actual
  `ansible-playbook` invocation is made
  through **ansible-runner**, and on
  larger installs the work is carried to
  execution nodes by **Receptor**, AWX's
  mesh networking component.
- **The database**: a **PostgreSQL**
  stateful set (`postgres.yaml.j2`), by
  default the `quay.io/sclorg/postgresql-15-c9s`
  image with 8Gi of storage — the home of
  every object above and every job record.
  An external database can replace it.
- **Execution environments**: the
  container images a job's playbook runs
  inside, carrying a pinned Ansible and
  its collections. Chapter 12.
- **The operator**: the Kubernetes
  program that installs and tends all of
  the above. You declare an AWX in a
  **custom resource** — a small YAML file
  — and the operator builds the
  deployments, services, secrets, and
  storage to match, and keeps matching
  them. Chapter 13.

## The parts you talk to it with

- **The web UI**, for people.
- **The REST API**, at `/api/` on the
  server — the lab knows this path from
  the client's own error message
  (chapter 11) — for programs.
- **`awx`**, the command-line client from
  the **awxkit** package, which speaks to
  the API. The lab installed and ran it;
  with no server to reach, its failure
  is this guide's most honest screenshot
  of the client-server split.
- **`ansible-playbook`**, which needs no
  AWX at all — the ground floor, and the
  subject of chapters 4 and 5. Everything
  in the control room exists to launch
  what this command runs.

Check: name the six arranged objects in
an order that builds a launch — project
and inventory and credential first, job
template last, job when it runs — and
name the three running parts the
operator deploys (web, task, PostgreSQL).
If you can, later chapters have
somewhere to hang.
