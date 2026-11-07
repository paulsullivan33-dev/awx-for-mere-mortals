# Job templates, surveys and schedules

Outcome: the launch button itself — what
a job template fixes, what it may ask at
launch, and what a schedule does to it —
plus the workflow that chains templates
together. Documented-only, from the AWX
user guide for 24.6.1; the engine it
launches is the one you ran in chapters
4 and 5.

## A template is a stored run

A **job template** binds together
everything a run needs, chosen once by
someone who knows, so it can be launched
many times by people who only need the
result:

- the **project** and the **playbook**
  within it (chapter 6),
- the **inventory** it runs against
  (chapter 7),
- the **credentials** it may use
  (chapter 8),
- and the run's options: job type (run,
  or **check** — Ansible's dry-run mode,
  which reports what would change and
  changes nothing), privilege escalation,
  verbosity, limits (run against a subset
  of the inventory), tags and skipped
  tags, extra variables, and how many
  hosts to work in parallel.

Launching produces a **job**: the stored
record of that run — who or what launched
it, when, the full output stream as it
happened, the recap, the result. Chapter
4's terminal output is what a job page
shows, preserved instead of scrolled
away. Relaunching a job re-applies the
template and its prompts; the record
keeps each attempt separate.

The Northlight translation is direct.
The co-op's rollout becomes one template:
the Northlight project, `site.yml`, the
webservers inventory, the co-op's machine
credential. What was an editor, a
terminal, and one person's memory in
chapter 4 is now a row in a list with a
rocket icon — and, chapter 10, a
permission.

## Prompt on launch, and surveys

Some choices should not be fixed. A
template can mark fields **prompt on
launch** — the inventory, the credential,
the limit, the extra variables — so the
person launching supplies them each time,
within what their permissions allow.
Beyond the built-in fields, a **survey**
is a form the template's author designs:
named questions with types (text, choice,
number, password and more), defaults, and
validation, whose answers become the
job's extra variables.

Chapter 5's third run is the survey's
whole argument in miniature. The lab
changed `release_channel` by editing a
file, and exactly two tasks per host
moved. As a survey question — "release
channel: stable or beta?" — that same
choice becomes something an operator may
be *allowed* to make at launch, in a
form that rejects a third, misspelled
option, without ever editing the project
or seeing the credential. The engine
receives the same variable either way.
Control, again, around the run.

Surveys have a sharp edge, and the guide
names it: a survey answer is still an
extra variable, and extra variables
outrank almost everything in Ansible's
precedence. A free-text survey question
wired to a powerful variable is a
playbook-editing permission wearing a
form's clothing. Design questions like
you would design permissions, because
that is what they are.

## Schedules and notifications

A **schedule** attaches a clock to a
template: a name, a start, a repetition
rule (the user guide expresses it in the
standard recurrence format calendars
use). At the appointed time AWX launches
the job itself — the answer to chapter
1's laptop-that-must-stay-on question.
Schedules can be put on templates,
project updates, and inventory updates
alike, which is how "sync the inventory
at 02:00, run the compliance playbook at
03:00" becomes a configuration instead
of a rota.

**Notifications** attach the other end:
on a job's start, success, or failure,
AWX can message the systems a team
actually reads — email, Slack, IRC,
webhooks to your own endpoints, and
several more in the user guide's list.
A scheduled job nobody watches is only
half governed; the failure notification
is what makes an unattended run an
attended system.

## Workflow templates

A **workflow template** chains job
templates into a small graph: run B if A
succeeded, C if A failed, D after both.
Convergence, branching on success or
failure, and approvals — a node that
pauses the workflow until a person
approves it — are all in the user guide.
Workflows are where AWX's record earns
its keep most visibly: one page showing
the night's patching, the branch that
failed, and the cleanup job that ran
because it did. They are also where
chapter 1's rule deserves its last
mention in this chapter: a workflow is
choreography around playbooks. It cannot
make any single step in the dance
correct.

Check: take the playbook you know best
and write its template on paper — project,
playbook, inventory, credential, and
every option you would fix. Then mark
the two things, at most, a survey should
ask. If your list of questions is longer,
the playbook wants splitting, not a
bigger form.
