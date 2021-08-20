defmodule ExDadata.DevClient do
  @moduledoc false

  alias ExDadata.Client

  def new do
    api_key = Application.fetch_env!(:ex_dadata, :api_key)
    secret_key = Application.fetch_env!(:ex_dadata, :secret_key)
    http_adapter = Application.fetch_env!(:ex_dadata, :http_adapter)
    json_adapter = Application.fetch_env!(:ex_dadata, :json_adapter)

    %Client{
      api_key: api_key,
      secret_key: secret_key,
      http_adapter: http_adapter,
      json_adapter: json_adapter
    }
  end
end
