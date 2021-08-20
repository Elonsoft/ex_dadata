defmodule ExDadata.Client do
  @moduledoc """
  Keeps authorization information for DaData.
  """

  alias ExDadata.HTTPBackoff

  defstruct ~w(api_key secret_key http_adapter json_adapter)a

  @opaque t :: %__MODULE__{}

  @doc """
  Create new client.
  """
  @spec new(String.t(), String.t(), module, module) :: t
  def new(api_key, secret_key, http_adapter, json_adapter) do
    backoffed_http_adapter = HTTPBackoff.functor(http_adapter)

    %__MODULE__{
      api_key: api_key,
      secret_key: secret_key,
      http_adapter: backoffed_http_adapter,
      json_adapter: json_adapter
    }
  end

  @doc false
  @spec http_adapter(t) :: module
  def http_adapter(%__MODULE__{http_adapter: adapter}) do
    adapter
  end

  @doc false
  @spec json_adapter(t) :: module
  def json_adapter(%__MODULE__{json_adapter: adapter}) do
    adapter
  end

  @doc """
  Create headers needed to authorize for this client.
  """
  @spec to_headers(t) :: [{String.t(), String.t()}]
  def to_headers(%__MODULE__{api_key: api_key, secret_key: secret_key}) do
    [
      {"Authorization", "Token #{api_key}"},
      {"X-Secret", "#{secret_key}"}
    ]
  end
end
