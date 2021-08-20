defmodule ExDadata do
  @moduledoc """
  `ExDadata` provides a wrapper for DaData API.

  ## Example

  Firs we need to define a configuration module.

      defmodule MyApp.Dadata do
        use ExDadata, otp_app: :my_app
      end

  Then we can set our configuration in `config.exs` file:

      config :my_app, MyApp.Dadata,
        api_key: "<api_key>",
        secret_key: "<secret_key>",
        http_adapter: ExDadata.HTTPoisonHTTPAdapter,
        json_adapter: Jason

  And then we can use it to make requests to DaData API:

      client = MyApp.Dadata.client()
      {:ok, result} = ExDadata.Address.clean_address(client, ["мск сухонска 11/-89"])
  """

  alias __MODULE__.NoConfigError

  @doc false
  defmacro __using__(opts) do
    otp_app = fetch_otp_app!(opts)

    quote do
      @doc """
      Return a dadata client struct.

      See `ExDadata.Client` for more info.
      """
      def client do
        config = Application.get_env(unquote(otp_app), __MODULE__)
        api_key = fetch_config_opt!(config, :api_key)
        secret_key = fetch_config_opt!(config, :secret_key)
        http_adapter = fetch_config_opt!(config, :http_adapter)
        json_adapter = fetch_config_opt!(config, :json_adapter)
        ExDadata.Client.new(api_key, secret_key, http_adapter, json_adapter)
      end

      defp fetch_config_opt!(config, key) do
        case Keyword.fetch(config, key) do
          {:ok, value} ->
            value

          :error ->
            raise NoConfigError,
              key: key,
              otp_app: unquote(otp_app),
              module: __MODULE__
        end
      end
    end
  end

  defp fetch_otp_app!(opts) do
    case Keyword.fetch(opts, :otp_app) do
      {:ok, app} when is_atom(app) -> app
      {:ok, _term} -> raise ArgumentError, "expected :otp_app to be an atom"
      :error -> raise ArgumentError, "no :otp_app key provided"
    end
  end
end
