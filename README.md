# ExDadata

![](https://github.com/Elonsoft/ex_dadata/workflows/test/badge.svg)
![](https://github.com/Elonsoft/ex_dadata/workflows/lint/badge.svg)

`ExDadata` provides a wrapper for [DaData API](https://dadata.ru/api/).

## Installation

Add the package to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_dadata, "~> 0.1.0"}
  ]
end
```

Documentation is available on [HexDocs](https://hexdocs.pm/ex_dadata).

## Usage

Firs we need to define a configuration module.

```elixir
defmodule MyApp.Dadata do
  use ExDadata, otp_app: :my_app
end
```

Then we can set our configuration in `config.exs` file:

```elixir
config :my_app, MyApp.Dadata,
  api_key: "<api_key>",
  secret_key: "<secret_key>",
  http_adapter: ExDadata.HTTPoisonHTTPAdapter,
  json_adapter: Jason
```

And then we can use it to make requests to DaData API:

```elixir
client = MyApp.Dadata.client()
{:ok, result} = ExDadata.Address.clean_address(client, ["мск сухонска 11/-89"])
```

## Development

In `dev` mode `ExDadata.DevClient` is available. It's initialized from
`config/dev.exs` config. You can create it and put the following data:

```elixir
use Mix.Config

config :ex_dadata,
  api_key: "<your_api_key>",
  secret_key: "<your_secret_key>",
  http_adapter: ExDadata.HTTPoisonHTTPAdapter,
  json_adapter: Jason
```

After this you can create your client in `iex -S mix`:

```elixir
iex(2)> client = ExDadata.DevClient.new()
iex(3)> ExDadata.Address.suggest_address(client, %{query: "москва хабар"})
```

> **Note:** You'll need to start HTTPoison application:
>
> ```elixir
> iex(1)> Application.ensure_all_started(:httpoison)
> ```
