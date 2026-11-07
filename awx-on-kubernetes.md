# AWX on Kubernetes — the operator

Outcome: how AWX is actually installed —
not a program you run, but a small
declaration an operator turns into a
working system — read from the real
release this lab downloaded:
**awx-operator 2.19.1**, the operator
released with AWX 24.6.1. The reading is
live-verified; no cluster was involved,
and nothing here claims an install
happened.

## You do not install AWX. You declare it

Kubernetes is run by **operators**:
programs that watch for a declaration of
what you want and build it, continuously.
AWX's operator is built with the Operator
SDK and written in Ansible — the release's
own README says so, a pleasing recursion:
the control room for Ansible is installed
by Ansible.

The declaration is a **custom resource**:
a YAML file of a kind Kubernetes does not
know until the operator's **custom
resource definitions** (CRDs) teach it.
The release's smallest example is eight
lines, shipped as `awx-demo.yml`:

```yaml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
spec:
  service_type: nodeport
```

That is the entire request: an AWX,
named `awx-demo`, reachable by a NodePort
service. Everything else — deployments,
services, secrets, storage, the database —
the operator derives from defaults and
creates. The install route in the
operator's documentation
(`docs/installation/basic-install.md`) is
the shape chapter 3 promised: have a
cluster; deploy the operator with
Kustomize (`kubectl apply -k .`, and the
doc lists what springs into existence:
the CRDs, the operator's deployment, its
roles and bindings); then write the file
above and apply it. Await the pods. The
operator also ships a Helm route — the
release notes describe publishing the
chart with each release — and documents
kind and minikube installs for testing.
All documented-only here.

## What the declaration builds

The operator's installer role renders
three workload templates — the lab read
all three (transcript
`awx-lab/transcripts/t09-operator-inspection.txt`):

- `templates/deployments/web.yaml.j2` —
  the web deployment: the AWX image
  (`quay.io/ansible/awx`, from
  `_image` in the installer defaults)
  serving UI and API, a Redis container
  (`docker.io/redis`, version 7) in the
  same pod, and a logging sidecar.
- `templates/deployments/task.yaml.j2` —
  the task deployment: the same AWX image
  running the dispatcher side, with its
  own Redis container and the init
  containers that prepare the database
  and the Receptor mesh certificates.
- `templates/statefulsets/postgres.yaml.j2` —
  PostgreSQL as a stateful set, image
  `quay.io/sclorg/postgresql-15-c9s`, with
  its data on persistent storage.

Around those: services and (optionally)
an ingress or route, config maps, secrets
— including the admin account, whose
defaults the installer names plainly:
`admin_user: admin`, with
`admin_password_secret` pointing at a
Kubernetes secret you supply or the
operator generates — and storage for the
projects area, whose defaults are
`projects_storage_size: 8Gi` with
`ReadWriteMany` access, while
`projects_persistence` defaults to false
(a detail with teeth: a default install's
project copies are not promised survival;
production installs set it true).

## The size of the dial

The AWX CRD —
`config/crd/bases/awx.ansible.com_awxs.yaml`
— is 2,054 lines long. That number is the
chapter's honest summary of AWX's
configurability: nearly everything about
the system is a field on this resource.
The defaults the installer starts from
include `replicas: 1` and per-component
resource **requests** — web and task at
100m CPU and 128Mi memory, execution
environments at 100m and 64Mi, Redis at
50m and 64Mi, PostgreSQL at 10m and 64Mi
with 8Gi of storage. Requests are floors
for the scheduler, not appetites; the
sample file `awx_v1beta1_awx_resource_limits.yaml`
in the same release shows a production
shape, with limits of 4Gi on web, task,
and EE containers. Read both files side
by side and you have the sizing
conversation of every real install:
small to start, explicit to grow, and
always the cluster's arithmetic, not
AWX's promise (limits, chapter 16).

Four CRDs ship in the release, and the
other three complete the life cycle:
`AWXBackup` and `AWXRestore` (back the
whole system up to object storage and
bring it back) and `AWXMeshIngress`
(for the Receptor mesh of chapter 12).
Backup being a first-class resource —
declared, scheduled, recorded — is the
control-room habit applied to the
control room itself.

## What reading this does and does not prove

The lab verified: these files, these
fields, these images, these numbers, in
this release. It did not verify that
applying them produces a running AWX on
any particular cluster — versions of
Kubernetes, storage classes, ingress
controllers and registries all get a
vote, and the operator's troubleshooting
docs exist because the vote sometimes
goes against you. If you take one
sentence from this chapter to an install,
take the demo file's smallness
seriously: start from eight lines, watch
what the operator builds, and grow the
spec field by field, with the CRD open
beside you.

Check: from the transcript alone, name
the three workload templates, the four
container images (AWX, AWX EE, Redis,
PostgreSQL), and the default PostgreSQL
storage request. Then say, in one
sentence, why this chapter cannot end
with "and now log in".
