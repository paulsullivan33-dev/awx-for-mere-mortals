# Inventories — the hosts

Outcome: what an inventory is in Ansible
and in AWX, how the lab's six-line file
grows into a centrally held, synced list
of hosts, and where the danger lives.
The AWX half is documented-only; the
Ansible half you have already run.

## The idea, from the lab

Chapter 4's inventory in full:

```
[webservers]
northlight-web-01 ansible_host=127.0.0.1 ansible_connection=local
northlight-web-02 ansible_host=127.0.0.1 ansible_connection=local
```

An **inventory** answers three questions
for a run: which hosts, in which groups,
with which variables. Groups are the unit
a playbook aims at (`hosts: webservers`),
host entries carry connection facts, and
variables — the lab kept them in
`group_vars/webservers.yml` — carry the
rest. Change the inventory and the same
playbook does different work in the
world, which is why chapter 6 separated
it from the project: the playbook says
*what*, the inventory says *where*.

In the lab the connection facts are the
fiction: `ansible_connection=local` and
an address of `127.0.0.1`. A real entry
names a real host and reaches it over
SSH, with the credential AWX supplies
(chapter 8). The playbook neither knows
nor cares — `--list-hosts` in chapter 4
resolved the group to its two members
without any host being contacted.

## Inventories inside AWX

An AWX inventory is the same object held
centrally, belonging to an organization:
hosts, groups, and variables, editable in
the web interface and through the API,
and selectable by job templates. Three
additions matter beyond the file:

- **Inventory sources.** An inventory (or
  a group within it) can be *sourced* —
  generated from somewhere else and kept
  in step by an **inventory update**, the
  inventory's analogue of a project
  update. Sources the documentation
  covers include another project (an
  inventory file kept in version control),
  cloud providers such as Amazon EC2,
  Microsoft Azure and Google Compute
  Engine, virtualization platforms, and a
  custom script of your own. The fleet you
  have becomes the inventory you run
  against, refreshed on a schedule or at
  launch, instead of a file somebody
  updates from memory.
- **Smart inventories.** A filtered view:
  hosts chosen by a search over facts and
  fields — all hosts tagged production,
  say — which updates itself as hosts
  change. Useful, and the closest thing
  in AWX to a loaded weapon (see below).
- **Variables at every level.** Host,
  group, and inventory variables layer in
  a stated precedence, with the job's own
  extra variables (chapter 9) on top.
  Chapter 5's third run is the small
  version of this: one variable moved,
  exactly the tasks using it changed.

## Where the danger lives

An inventory is a targeting list. Every
control AWX offers — who may launch,
which credential, what schedule — is
aimed through it, and its failure mode
is silent: a host added to the wrong
group does not error, it gets
*configured*, correctly, by the wrong
playbook, at production scale. Synced
and smart inventories sharpen both edges:
they keep the list true as the fleet
changes, and they can sweep a new host
into a job's path the night it is
provisioned, before anyone has reviewed
it. The defences are boring and
sufficient: read a sync source's diff
before trusting it, keep production
groups explicit where you can, and let
chapter 10's roles decide whose job
templates may point at the production
inventory at all. AWX gives you the
record afterwards; the inventory is
where you earn a quiet night instead.

Check: look at the lab inventory and name
what would change, line by line, to make
it real — real hostnames, SSH instead of
a local connection, and a credential
instead of your own key. Then say which
of your real host lists change often
enough to deserve a synced source, and
which you would keep hand-held on
purpose.
