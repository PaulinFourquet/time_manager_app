# front

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Customize configuration

See [Vite Configuration Reference](https://vitejs.dev/config/).

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Compile and Minify for Production

```sh
npm run build
```

### Lint with [ESLint](https://eslint.org/)

```sh
npm run lint
```

----------------------------------------------------------------------------------------------------------------------------------------

# API : TimeManager

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Init Project

- Installer elixir et postgreSQL
- mix phx.new timeManager --module TimeManager --no-html
- ficher dev.exs, update "password"
- mix ecto.create
- mix deps.get (not obligatory)

## Create Table

- mix phx.gen.json Account User users username:string email:string

- mix phx.gen.json Account Clock clocks time:utc_datetime status:boolean user_id:references:users

- mix phx.gen.json Account WorkingTime workingtime start:utc_datetime end:utc_datetime user_id:references:users