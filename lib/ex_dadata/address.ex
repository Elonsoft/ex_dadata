defmodule ExDadata.Address do
  @moduledoc """
  Entry point for address DaData API.

  For more information see [docs](https://dadata.ru/api/#address-clean).
  """

  alias __MODULE__.{CleanAddress, SuggestAddress}
  alias ExDadata.Client
  alias ExDadata.HTTPAdapter.Response

  @clean_address_url "https://cleaner.dadata.ru/api/v1/clean/address"

  def clean_address(client, data) do
    with {:ok, body} <- do_clean_address(client, data) do
      {:ok, CleanAddress.new!(body)}
    end
  end

  defp do_clean_address(client, data) do
    headers = Client.to_headers(client)
    adapter = Client.adapter(client)

    case adapter.request(:post, @clean_address_url, headers, data, []) do
      {:ok, %Response{status: 200, body: response}} -> {:ok, response}
      {:ok, resp} -> {:error, resp}
      {:error, _} = error -> error
    end
  end

  @suggest_address_url "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address"

  def suggest_address(client, data) do
    with {:ok, body} <- do_suggest_address(client, data) do
      {:ok, SuggestAddress.new!(body)}
    end
  end

  defp do_suggest_address(client, data) do
    headers =
      Client.to_headers(client) ++
        [
          {"Accept", "application/json"},
          {"Content-Type", "application/json"}
        ]

    adapter = Client.adapter(client)

    case adapter.request(:post, @suggest_address_url, headers, data, []) do
      {:ok, %Response{status: 200, body: response}} -> {:ok, response}
      {:ok, resp} -> {:error, resp}
      {:error, _} = error -> error
    end
  end
end
