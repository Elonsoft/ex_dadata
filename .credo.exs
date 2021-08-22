# This file contains the configuration for Credo.
#
# See https://hexdocs.pm/credo for more info.
#
%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "dev/", "test/"],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/"]
      },
      strict: true,
      checks: [
        {Credo.Check.Readability.MaxLineLength, false}
      ]
    }
  ]
}
