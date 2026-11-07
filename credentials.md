# Credentials — secrets without sharing them

Outcome: how AWX holds the secrets a job
needs — passwords, keys, tokens — so the
person who launches the job can use them
without ever seeing them, and the honest
limits of that arrangement. Documented-only:
the credential store lives inside the
running product this lab did not run.

## The problem, from the laptop

Run a playbook from your laptop and the
secrets live with you: your SSH key in
your home folder, a password you type,
a token in an environment variable. It
works, and it scales to exactly one
person. The moment a team shares
automation, the secrets become the
sharing problem — they end up in chat
messages, shared notes, and repository
files, each copy a small permanent risk,
and "who has the production key?" becomes
a question nobody can fully answer.

## What AWX does instead

A **credential** in AWX is a secret held
by the server: created by someone
authorised, stored encrypted in AWX's
database, and attached to job templates.
At run time AWX hands the secret to the
job — an SSH key written to a temporary
file for the run's duration, a password
passed to the connection — and the job's
output, the record everyone can read,
does not contain it. The launch button
and the secret travel separately:

- A user can be granted **use** of a
  credential — enough for their job
  templates to run with it — without any
  way to view it. Chapter 10 makes this a
  role; it is the single most valuable
  permission in the product.
- **Credential types** describe the shape
  of a secret: which fields it has and
  how a job injects them. Built-in types
  cover machine credentials (SSH and
  privilege-escalation passwords), source
  control, network devices, and the major
  clouds' tokens; administrators can
  define custom types for shapes AWX does
  not know.
- **External credential plugins** go one
  step further: instead of storing the
  secret, AWX stores a reference and
  fetches the secret at run time from an
  outside vault — HashiCorp Vault,
  Azure Key Vault, CyberArk and others
  are covered in the project's credential
  documentation in the AWX source
  (`docs/credentials/`). The secret then
  lives in exactly one system, and AWX
  holds directions, not treasure.

The operator's manifests show the same
pattern one level down: AWX's own
installation is configured by Kubernetes
secrets — an admin password secret
(`admin_password_secret` in the
installer's defaults, with the default
admin user named `admin`), a secret key
that protects the database's encrypted
fields, application credentials for the
database itself. The control room's own
keys live in a vault too. It is vaults
all the way down, and every one of them
has an administrator.

## The honest limits

Limits the limits chapter (16) repeats,
stated here where they belong:

- **The store is only as safe as its
  administrators.** Anyone with AWX admin
  rights, or access to the database and
  its secret key, stands where the secrets
  are. AWX narrows the circle of people
  who *handle* secrets; it does not
  abolish the circle.
- **Rotation is still a job.** A password
  changed on the target must be changed
  in AWX (or in the external vault) by a
  person or a process someone maintains.
  A stale credential fails at 03:00 like
  any other.
- **A job can leak what it is given.** A
  playbook that prints a secret into its
  output puts it in the record. AWX masks
  what it recognises; it cannot recognise
  everything, and chapter 5's discipline
  — know what your tasks print — applies
  to secrets most of all.

What the arrangement genuinely buys, and
it is a lot: secrets stop travelling.
They are entered once, by the person who
owns them, used by everyone authorised,
seen by almost nobody, and their use is
in the job record. For most teams that
is the difference between automation
they can share and automation they
quietly keep on one laptop.

Check: list the secrets your current
automation uses, and for each say where
it lives today and who could read it.
If any answer is "a chat" or "the
repository", you have found the first
credential AWX would hold for you — and
the measure of what chapter 10's roles
must protect.
