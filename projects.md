# Projects — where playbooks live

Outcome: what an AWX project is, how AWX
keeps it current, and how the folder you
ran by hand in chapter 4 becomes one.
This chapter is documented-only: projects
live inside the running product, which
this guide's lab did not run. It is
anchored throughout to the lab project
you have already seen work.

## A project is a playbook's home address

In chapter 4 the playbook was a folder on
disk: `site.yml`, an inventory, variables,
templates. AWX needs that folder to live
on the server, under its control, because
the person launching a job may have no
access to the machine the playbook lives
on — that separation is rather the point.
An AWX **project** is that folder, held by
AWX: a named bundle of playbooks belonging
to one organization, with a stated source
AWX can refresh.

Most projects name a **source control**
system — usually a Git repository, also
Subversion or a plain archive — and AWX
keeps a working copy of it. Before a job
runs, or on demand, AWX performs a
**project update**: it fetches the latest
version from the source, so the playbook
that runs is the playbook that is
committed, not a copy somebody edited on
the server last spring. An update is
itself a small job, with its own output
and result in the record.

## What that buys, and what it costs

The gain is the one chapter 1 promised:
control. The playbook's history is Git's
history — reviewed, revertible, attributed
— and AWX runs a known revision of it.
Pair that with a job template pinned to a
branch and "what ran in March?" has an
answer down to the commit.

The costs are real and worth naming:

- **The server needs the source.** AWX
  must reach your repository, with a
  credential for it if it is private
  (chapter 8's credential store holds
  source-control credentials too). A
  repository the server cannot reach is
  a project that never updates.
- **Stale is a state, not an error.** If
  updates are set to happen on a schedule
  rather than at launch, a job can run a
  project copy older than the repository.
  The setting that refreshes the project
  when a job launches exists precisely
  because this bites.
- **Local edits on the server are lost.**
  AWX also allows a "manual" project — a
  folder placed on the server by an
  administrator — and it is the route
  that quietly rots: no source, no
  history, no update. The documentation
  offers it; experience argues for the
  repository.

## The lab project, translated

Northlight's folder is already shaped
like a project: one playbook at the top,
its inventory and variables and templates
beside it. In AWX, Northlight would
commit that folder to a Git repository,
create a project pointing at it, and the
playbooks inside — `site.yml` — would
appear as choices when building job
templates. Nothing in the folder changes.
That is a sentence worth rereading: the
move from laptop Ansible to AWX does not
rewrite your automation. It re-homes it,
and starts keeping receipts.

One lab detail does *not* translate, and
the guide flags it rather than smoothing
it over: the lab inventory lives inside
the project folder, which is fine for
plain Ansible. In AWX, inventories are
their own objects (chapter 7) and a job
template picks a project and an inventory
separately — the same playbook can then
run against the test inventory on Monday
and the production inventory on Tuesday,
which is impossible when the host list is
baked into the folder.

Check: take any playbook folder you own
and answer three questions about it.
Could it be committed to a repository
as-is? Does anything in it assume it runs
from your laptop (a path, a key, your
user)? If AWX fetched it fresh onto a
server tomorrow, what would break first?
Those answers are your project's real
documentation.
