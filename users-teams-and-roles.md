# Users, teams and roles

Outcome: who may do what in AWX — the
control in the control room — and how to
hand it out without handing over the
keys to everything. Documented-only,
from the AWX user guide for 24.6.1.

## The cast

- A **user** is a person (or, with a
  token, a script). Each has a type:
  **system administrator** (everything,
  everywhere), **system auditor**
  (everything, read-only — the rarest
  honest job in IT, given a seat of its
  own), or a **normal user**, whose
  powers come entirely from the roles
  below.
- A **team** is a group of users inside
  one organization. Teams hold roles so
  people do not have to be granted things
  one by one; a person joins the patching
  team and inherits the patching powers.
- An **organization** (chapter 2) is the
  boundary roles live inside. Its own
  roles — organization admin, and
  read — sit above the object roles.

External identity systems can feed all
three: the AWX documentation covers
LDAP, SAML, OAuth2 and other social and
enterprise authentication (the AWX source
keeps those notes under `docs/auth/`),
so the team list can come from the
directory the company already keeps,
instead of becoming one more list to
maintain.

## Roles: small verbs on single objects

The unit of permission is a **role**: a
verb granted to a user or team on one
object. The verbs are few and plainly
named — among them **Admin** (full
control of the object, including granting
it), **Execute** (launch it), **Use**
(attach it to your own templates —
the credential and inventory verb from
chapters 7 and 8), **Update** (refresh a
project or inventory), **Adhoc** (run
one-off commands), and **Read**. Roles
exist per kind of object: a job template
has Admin, Execute and Read; a credential
has Admin, Use and Read; and so on.

Two consequences follow from that design,
both pleasant:

- **Granting the run does not grant the
  edit.** Execute on the rollout template,
  Use on the webservers inventory and the
  machine credential: an operator can roll
  Northlight's change at 2 a.m. and cannot
  change what the change *is*. Chapter 1's
  questions — who may run this, with what,
  against where — are answered by exactly
  three role grants.
- **Auditing is a read, not a favour.**
  Read roles, and the system auditor type
  above them, let a reviewer see every
  template, credential assignment, and job
  record without holding any power to run
  anything. The record and the right to
  inspect it arrive together.

## How it goes wrong

The failure modes are administrative, not
technical, and this guide lists them so
they can be recognised in the wild:

- **Admin as a default.** Granting
  organization admin because it was
  quicker than three precise roles undoes
  the product's reason to exist. AWX
  cannot protect a playbook from the
  people you made administrators of it.
- **One shared user.** A "team" account
  destroys the record's value: the job
  says *who* launched it, and if the
  answer is always "ops", it says nothing.
  Users are free; make them per person,
  and let scripts have tokens of their
  own.
- **Roles nobody reviews.** A person who
  left the patching team in March and
  kept Execute is a schedule nobody set.
  The auditor role exists so this review
  can be someone's read-only job — use it.

Notice what is absent from this chapter:
any mention of Ansible. Roles decide
who may *launch*; the playbook decides
what happens next, with the credential's
privileges on the target. AWX's control
ends at the moment chapter 4's command
begins — the rule, one final time, from
the permission side.

Check: for the Northlight rollout, write
the smallest set of grants that lets a
junior operator run it — which template,
which verb; which inventory, which verb;
which credential, which verb. If your
answer contains the word Admin anywhere,
start again.
