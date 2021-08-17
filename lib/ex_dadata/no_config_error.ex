defmodule ExDadata.NoConfigError do
  @moduledoc """
  An error raised in case you did not provided required config key.
  """

  defexception [:key, :otp_app, :module]

  def exception(opts) do
    {key, opts} = Keyword.pop!(opts, :key)
    {otp_app, opts} = Keyword.pop!(opts, :otp_app)
    {module, _opts} = Keyword.pop!(opts, :module)
    %__MODULE__{key: key, otp_app: otp_app, module: module}
  end

  def message(%__MODULE__{key: key, otp_app: otp_app, module: module}) do
    "failed to provide #{key} in the application config\n\n" <>
      "try adding the following code in your config.exs file:\n\n" <>
      "  config :#{otp_app}, #{module},\n" <>
      "    api_key: \"<api_key>\",\n" <>
      "    secret_key: \"<secret_key>\",\n" <>
      "    adapter: <adapter_module>"
  end
end
