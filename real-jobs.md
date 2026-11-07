# Real jobs

Outcome: three jobs in the shape AWX
exists to run, assembled from the pieces
the earlier chapters built. The playbook
at the centre ran for real (chapters 4
and 5); its assembly into AWX objects is
a worked example, written from the
documented behaviour of chapters 6 to 10
and labelled as such — no job in this
chapter was launched, because no AWX ran.

## Job one: the Northlight rollout, governed

The story so far, in one paragraph. The
Northlight Hosting Co-op — fictional,
two web servers — rolls a configuration
change. By hand (chapter 4) it was one
person, one terminal, one command. The
co-op has grown a second operator and an
auditor, and the change now deserves the
control room. The assembly:

- **Project:** Northlight's automation
  repository, `site.yml` at its root,
  updated from source before each launch
  (chapter 6).
- **Inventory:** the two web servers as
  real hosts over SSH, in `webservers`,
  hand-held — two hosts do not need a
  synced source, and the co-op likes
  knowing exactly what is on the list
  (chapter 7).
- **Credential:** one machine credential,
  the SSH key for the web servers,
  entered by the senior operator
  (chapter 8).
- **Job template:** "Roll status-page
  config" — the project, `site.yml`, the
  inventory, the credential; job type
  **Run**; a survey with exactly one
  question, release channel, a choice
  between `stable` and `beta` (chapter 9).
- **Roles:** the junior operator's team
  gets **Execute** on the template and
  nothing else; the inventory and
  credential are attached to the template,
  so no separate grants are needed for
  the launch; the auditor gets **Read**
  (chapter 10).
- **Notifications:** failure, to the
  co-op's chat (chapter 9).

Now watch chapter 1's four controls do
their work in one ordinary night. The
junior launches the template, picks
`beta` from a list that cannot be
misspelled, and never sees the SSH key.
The job record shows who launched, what
the survey answered, the recap —
`ok=7, changed=2`, if the lab's third
run is any guide — and the auditor reads
it in the morning without asking anyone
for a terminal scrollback. Nothing about
the *playbook* improved. Everything
about its governance did. That
difference is the product.

## Job two: the scheduled check

A compliance playbook — users, packages,
open ports, compared against a policy —
is a different shape: nobody launches it,
and its value is that it runs when
nobody remembers. Its template's job
type is **Check**, Ansible's dry run:
it changes nothing and reports what
*would* change, which for an audit is
the entire point. A schedule runs it
weekly; a failure notification goes to
the team; the job history becomes the
audit trail — a year's worth of
"we checked, here is what we found",
kept by the system that did the
checking. The idempotency lesson of
chapter 5 cuts both ways here: a check
job against a drifting fleet *should*
report changes, and the record is where
drift stops being a rumour.

## Job three: the workflow

Patch night, as a workflow template:
snapshot the inventory (job one of the
chain), run the patching template, and
on success run the verification template;
on failure, run the rollback template
and stop, with an approval node before
anything touches the database group.
Each step is an ordinary job template a
person could launch alone; the workflow
adds order, branching, and the pause for
a human — and one record page in the
morning showing the whole night,
including the branch not taken. The
honest caveat from chapter 9 stands:
the workflow choreographs playbooks. If
the patching playbook is wrong, the
graph will execute the wrongness in the
right order, on time, with approvals.
Review the steps; the graph is the easy
part.

## The pattern underneath

Every job in this chapter is the same
four questions, answered in advance:
who may run it (roles), when (launch or
schedule), with what (credential and
execution environment), and where the
record lives (the job list, kept). If a
proposed AWX job cannot state those
four in a sentence each, it is not
ready to be a template — it is still a
person's habit, and habits are what
chapters 4 and 5 are for: run it by
hand, twice, until its recaps are
boring. Then govern it.

Check: take one recurring task from your
own work and fill in the four answers —
who, when, with what, record where —
plus the survey question, if any, it
genuinely needs. If you can also state
its second-run recap from experience,
you have a job ready for a control room.
