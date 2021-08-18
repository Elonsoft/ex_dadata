defmodule ExDadata.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_dadata,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ExDadata",
      source_url: "https://github.com/Elonsoft/ex_dadata",
      homepage_url: "https://dadata.ru",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExDadata.Application, []}
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto, ">= 3.0.0"},
      {:ex_doc, "~> 0.25", only: [:dev], runtime: false}
    ]
  end

  defp docs do
    [
      main: "ExDadata",
      extras: ["README.md"],
      groups_for_modules: [
        Internals: [
          ExDadata.HTTPAdapter,
          ExDadata.HTTPAdapter.Response
        ]
      ]
    ]
  end
end
