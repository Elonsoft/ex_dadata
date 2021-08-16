defmodule ExDadata.Client do
  @moduledoc """
  Keeps authorization information for DaData.
  """

  defstruct ~w(api_key secret_key adapter)a

  @opaque t :: %__MODULE__{}

  @doc """
  Create new client.
  """
  @spec new(String.t(), String.t(), module) :: t
  def new(api_key, secret_key, adapter) do
    %__MODULE__{api_key: api_key, secret_key: secret_key, adapter: adapter}
  end

  @doc false
  @spec adapter(t) :: module
  def adapter(%__MODULE__{adapter: adapter}) do
    adapter
  end

  @doc """
  Create headers needed to authorize for this client.
  """
  @spec to_headers(t) :: [{String.t(), String.t()}]
  def to_headers(%__MODULE__{api_key: api_key, secret_key: secret_key}) do
    [
      {"Authorization", "Bearer #{api_key}"},
      {"X-Secret", "#{secret_key}"}
    ]
  end
end
