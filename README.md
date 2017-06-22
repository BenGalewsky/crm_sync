# CrmSync

This application run to keep your CRM data in synch with a 
[National Voter File](http://www.nationalvoterfile.org)data warehouse.

It does this by polling for new people from your CRM and
writing them to staging database by Ecto.

The people records are stored as JSON blobs in this table. These blobs
are consumed by a Pentaho Data Integration transform in the National
Voter File project to load new records into the warehouse as 
`voter_report_fact` records owned by the campaign (as distinct from records owner by the Secretary of State)

## Configuration
The app needs access to your CRM. Currently it supports NationBuilder.

Create `dev.secret.exs` in the config directory and set the name for 
 your nation as well as a valid API key as
```elixir
use Mix.Config

config :crm_sync, NationBuilder.API,
    nation: <Your nation's slug here>,
    api_key: <Your API Key here>
```

## Polling Schedule
The app uses [Quantum](https://hexdocs.pm/quantum/readme.html) to schedule
polling of the CRM. The schedule is contained in `dev.exs`

```elixir
config :quantum, :crm_sync,
 cron: [
    # Every minute
    "* * * * *":      {CrmSync.PollPeople, :poll }
]

```
## Launch
To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
