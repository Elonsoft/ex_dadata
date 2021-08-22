defmodule ExDadata.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_dadata,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),

      # Docs
      name: "ExDadata",
      source_url: "https://github.com/Elonsoft/ex_dadata",
      homepage_url: "https://dadata.ru",
      docs: docs(),

      # Hex
      description: description(),
      package: package()
    ]
  end

  defp elixirc_paths(:dev), do: ["lib", "dev"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger],
      mod: {ExDadata.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto, ">= 3.0.0"},
      {:ex_doc, "~> 0.25", only: [:dev], runtime: false},
      {:httpoison, "~> 1.8", optional: true},
      {:jason, "~> 1.2", optional: true}
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

  defp description do
    """
    DaData.ru API wrapper library for Elixir
    """
  end

  defp package do
    [
      links: %{"GitHub" => "https://github.com/Elonsoft/ex_dadata"},
      licenses: ["MIT"],
      files: ~w(.formatter.exs mix.exs README.md lib)
    ]
  end
end
