# The API and the awx command

Outcome: the REST API as AWX's real
interface, and the `awx` command-line
client examined the only way this lab
honestly could — installed, configured,
and pointed at a server that does not
exist. The client half of this chapter
ran for real; the server it describes
did not.

## Everything is the API

AWX's web interface is a client of its
own **REST API**: every object in
chapter 2 — organizations, projects,
inventories, credentials, templates,
jobs — is a resource at a URL under
`/api/` on the server, readable and
writable over HTTPS with the caller's
permissions, in JSON. The UI, the `awx`
command, and your own scripts are three
doors into the same room, which is why
anything done in one can be automated
through another. A browsable, self-
describing API root is part of the
design in the project's documentation;
this lab never browsed it, because no
server ran, and the text does not
pretend otherwise.

One detail of the API the lab *can*
swear to, because it appears in the
client's own error message below: a
request begins at `/api/` on the
configured host. Even the failure knows
the address.

## The client: awxkit and the awx command

The official client is **awxkit**, a
Python package (chapter 3 installed
version 24.6.1) providing the `awx`
command. Its help, captured in full
(transcript
`awx-lab/transcripts/t05-awxkit-help-and-version.txt`),
shows the shape: global options first —
`--conf.host`, `--conf.token`,
`--conf.username`, `--conf.password`,
`-k` for insecure connections, output
format choices (`json`, `yaml`, `jq`,
`human`) — and then a *resource* and a
verb: `awx job_templates launch`,
`awx jobs list`, `awx users list`, and
the utility commands `login` (exchange
a username and password for an OAuth2
token), `config`, `import` and `export`
(move whole resource sets between
servers, the sanctioned way to treat an
AWX's contents as code).

Three commands need no server, and the
lab ran all three:

- `awx --version` answers `24.6.1` — the
  client's version, stamped to match the
  server release it belongs to.
- `awx --help` prints the usage above.
- `awx config` prints the client's
  current idea of its configuration
  (transcript
  `awx-lab/transcripts/t06-awxkit-config.txt`):

```
{
     "base_url": "https://127.0.0.1:443",
     "token": "",
     "use_sessions": false,
     "credentials": {
          "default": {
               "username": "admin",
               "password": "password"
          }
     }
}
```

Read that carefully, because it is the
client confessing its defaults: with
nothing configured it aims at
`https://127.0.0.1:443` — this machine,
the standard HTTPS port — with the
placeholder username `admin` and password
`password`. Those are not your server's
credentials; they are packing material,
and a client left at its defaults is a
client that has not been introduced to
its server yet. The introduction can
come from flags (`--conf.host ...`), or
from environment variables: the lab set
`CONTROLLER_HOST=https://127.0.0.1:18082`
and `awx config` reported exactly that
as its `base_url`. (18082 is this lab's
assigned loopback port — the address
where an AWX would be, if this lab had
one. It does not.)

## The failure that proves the design

Then the lab asked the client to work
(transcript
`awx-lab/transcripts/t07-awxkit-no-server.txt`):

```
$ awx --conf.host https://127.0.0.1:18082 -k ping

There was a network error of some kind trying to reach https://127.0.0.1:18082.
You might need to specify (or double-check) --conf.host

HTTPSConnectionPool(host='127.0.0.1', port=18082): Max retries exceeded
with url: /api/ (Caused by NewConnectionError(... Failed to establish
a new connection: [Errno 111] Connection refused))
```

`awx users list` against the default host
failed the same way, at port 443.
Connection refused, both times, because
nothing listens: there is no AWX here.

This guide treats that failure as a
result, not an embarrassment, for three
reasons. It is *exact* — host, port, path
(`/api/`), cause. It demonstrates the
architecture better than a success
screenshot could: the client holds no
state, runs no jobs, and is precisely as
useful as the server it can reach — the
control room is the server, never the
tool in your hand. And it is the honest
boundary of this lab, drawn by the
software itself. Where a server exists,
the same commands list users, launch
templates, and stream job output; the
user guide and the client's `--help` for
each resource describe that surface, and
this guide labels it documented-only
rather than borrowing a stranger's
screenshot.

Check: install awxkit (chapter 3,
including the setuptools pin if your
first attempt fails the way the lab's
did), run `awx config`, and explain
every line of the output — especially
why the password says `password`. Then
run `awx ping` and read the refusal.
If you can say what each line of the
failure names, you understand the
client better than a successful login
would have taught you.
