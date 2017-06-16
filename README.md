# CrmSync

This application run to keep your CRM data in synch with a 
[National Voter File](www.nationalvoterfile.org)data warehouse.

## Configuration
The app needs access to your CRM. Currently it supports NationBuilder.

Create `dev.secret.exs` in the config directory and set the endpoint 
for your connection to NationBuilder (including your API key) as
```elixir
use Mix.Config

config :crm_sync, NationBuilder.API,
    endpoint: <your endpoint here>
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
