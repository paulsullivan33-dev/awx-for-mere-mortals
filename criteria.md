# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's traffic is the lab talking to itself.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** AWX is a tenant on Kubernetes, not
   a program you install: it is declared to an operator on a
   cluster you must already have, so if the cluster is beyond
   you, AWX is too. It does not make playbooks idempotent,
   tested, or safe — it runs the playbook it is given,
   punctually and with a good record. Its credential store is
   a vault people must still administer: rotation, revocation,
   and role reviews are continuing human work. And its scale
   and high availability are cluster questions — replicas,
   database replication, and storage are properties of the
   platform underneath, not features AWX switches on. The
   limits chapter labels which of these were read in the
   operator's manifests and documentation and which are this
   guide's reasoning.
8. **The one rule is in the text, early.** Chapter 1 and the
   README state the rule plainly — *AWX adds nothing to what
   Ansible can do; it adds control over who may run it, when,
   with what credentials, and a record that it happened; the
   playbook is still the thing that runs, so a bad playbook
   under AWX is just a bad playbook with an audience* — before
   any procedure depends on it, and later chapters point back
   to it where the rule bites: idempotency, surveys as
   permissions, and the workflow that choreographs a wrong
   playbook correctly.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is an Ubuntu 24.04 sandbox with no Kubernetes
cluster. **AWX itself never ran in this lab.** No AWX server,
web UI, or job was started, applied, or screenshotted, and
nothing in this guide claims otherwise.

What ran, and what was read:

- **ansible-core 2.21.6** (with awxkit, below) was installed
  from PyPI into a Python 3.12 virtual environment in the
  lab's scratch area — `pip install ansible-core` resolving
  ansible-core-2.21.6 — and run for real against the lab's
  fixture project (transcripts in `awx-lab/transcripts/`).
- **awxkit 24.6.1** was installed from PyPI in the same step
  (`awxkit-24.6.1`), the version matching the AWX release the
  operator ships. Its first run failed; see below.
- The **awx-operator 2.19.1** release was downloaded as the
  source archive `awx-operator-2.19.1.tar.gz` from the
  ansible/awx-operator GitHub releases (the release page
  states it was released with AWX **24.6.1**) and read, not
  applied. The AWX **24.6.1** source archive was likewise
  downloaded from the ansible/awx GitHub releases and its
  documentation read (the runner-integration notes, the
  credentials, clustering and capacity documents, and the
  administration docsite). GitHub's API was rate-limiting
  this batch, so both archives came from the plain
  release/download URLs, which worked; that route is the one
  recorded here. The AWX user-guide features described as
  documented-only are from the official AWX community
  documentation for 24.6.1.

Run for real, with transcripts as evidence:

- Versions and reachability (t00): `ansible --version` and
  `ansible-playbook --version` (core 2.21.6, Python 3.12.3,
  Jinja 3.1.6), and `ansible webservers -m ping` answering
  `pong` with `changed: false` from both fictional hosts.
- Soundness checks (t01): `--syntax-check` clean,
  `--list-hosts` resolving the `webservers` group to
  northlight-web-01 and northlight-web-02, `--list-tasks`
  listing the playbook's five tasks.
- The first run (t02): every task changed on both hosts; the
  handler ran once per host after being notified by the
  configuration template; recap **ok=7, changed=5** per host;
  the produced files listed and the rendered `app.conf`
  shown with its variables filled.
- The second run (t03), the identical command: every task ok,
  the handler absent, recap **ok=6, changed=0** per host —
  idempotency measured, not asserted.
- The third run (t04), after one variable changed by hand
  (`release_channel: stable` to `beta`): recap **ok=7,
  changed=2** per host — the configuration template and its
  handler, nothing else — and the rendered file shown
  carrying `beta`.
- awxkit (t05, t06): `awx --help` in full; `awx --version`
  answering `24.6.1`; `awx config` printing the client's
  defaults (base_url `https://127.0.0.1:443`, placeholder
  username `admin`, password `password`), and the same
  command honouring `CONTROLLER_HOST=https://127.0.0.1:18082`
  as its base_url. Port 18082 was this lab's assigned
  loopback port; nothing listened on it.
- awxkit against no server (t07): `awx --conf.host
  https://127.0.0.1:18082 -k ping` and `awx users list` both
  failing with the client's own message — a network error
  naming the host, the port, and the `/api/` path, cause
  `Connection refused`. The lab kept the failure verbatim:
  it is the evidence for what the client is.
- The operator, read (t09): the eight-line `awx-demo.yml`
  custom resource; the four CRDs shipped (`awxs`,
  `awxbackups`, `awxrestores`, `awxmeshingresses`) and the
  AWX CRD's 2,054 lines; the installer defaults naming the
  images (`quay.io/ansible/awx`,
  `quay.io/ansible/awx-ee`, `docker.io/redis` version 7,
  `quay.io/sclorg/postgresql-15-c9s`), `replicas: 1`, the
  per-component resource requests (web and task 100m CPU /
  128Mi, EE 100m / 64Mi, Redis 50m / 64Mi, PostgreSQL 10m /
  64Mi with 8Gi storage), `projects_storage_size: 8Gi`,
  `projects_persistence: false`, `admin_user: admin`; the
  three workload templates (web and task deployments, the
  PostgreSQL stateful set); the Kustomize entry point; and
  the resource-limits sample with its 4Gi limits.

Documented only — described from the official AWX user guide
for 24.6.1, the AWX and operator documentation in the
downloaded sources, and the manifests above, not run, and the
text does not claim otherwise:

- Installing AWX itself: deploying the operator (Kustomize or
  Helm), applying the AWX custom resource, kind and minikube
  test installs, ingress and routes, backup and restore.
- The web UI in its entirety; logging in; every screen.
- Projects and project updates, including source-control
  sync; inventories as AWX objects, inventory sources and
  updates, cloud and virtualization sources, smart
  inventories.
- The credential store in operation: creating credentials,
  credential types and custom types, external credential
  plugins and vault lookups, injection at run time.
- Job templates and workflow templates: creating, launching,
  prompt-on-launch, surveys, check mode as a job type,
  relaunching; schedules; notifications of every kind.
- Users, teams, organizations and roles in operation;
  external authentication (LDAP, SAML, OAuth2 and social
  auth).
- The REST API as a served, browsable interface; every
  successful `awx` command against a live server (`login`,
  resource verbs, `import`/`export`); token handling.
- Execution environments as used by jobs, custom EE builds,
  execution nodes, container groups, the Receptor mesh,
  capacity and clustering behaviour.
- Scaling, high availability, and upgrades of a running AWX.

Fixtures are this guide's own and deliberately generic: the
Northlight Hosting Co-op, its two invented web servers, its
status-page configuration and banner. No example is modelled
on any real person, network, service or organisation, and
every host in the lab resolves to the lab machine itself over
a local connection.

Two failures are kept in the record rather than tidied away.
First, awxkit's first run in a fresh environment failed with
`ModuleNotFoundError: No module named 'pkg_resources'`
(t08): pip had resolved setuptools 84.2.1, and setuptools 81
and later no longer ship the `pkg_resources` module awxkit
24.6.1 imports. Pinning `setuptools<81` fixed it — the pin
awxkit's own deprecation warning recommends — and the failure
was reproduced in a second fresh environment to confirm the
cause before the guide relied on it. Second, the lab's first
handler used a fact spelling (`ansible_date_time`) that
ansible-core 2.21.6 accepts but deprecates for removal in
2.24; the playbook was corrected to the `ansible_facts[...]`
spelling and the whole lab re-run, so the transcripts in
this checkout are free of the warning.
