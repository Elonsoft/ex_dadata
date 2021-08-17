defmodule ExDadata.Address do
  @moduledoc """
  Entry point for address DaData API.

  For more information see [docs](https://dadata.ru/api/#address-clean).
  """

  alias __MODULE__.{CleanAddress, SuggestAddress, GeocodeAddress, GeolocateAddress}
  alias ExDadata.Client
  alias ExDadata.HTTPAdapter.Response

  @clean_address_url "https://cleaner.dadata.ru/api/v1/clean/address"

  @doc """
  Normalize the address.

  See [documentation](https://dadata.ru/api/clean/address/#restrictions)
  for more information.

  ## Example

      ExDadata.Address.clean_address(client, ["мск сухонска 11/-89"])
  """
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

  @doc """
  Search address by any part of an address from the region to the
  house. Also, you can search by zip-code.

  See [documentation](https://dadata.ru/api/suggest/address/) for more
  info.

  ## Example

      ExDadata.Address.suggest_address(client, %{query: "москва хабар"})
  """
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

  @geocode_address_url "https://cleaner.dadata.ru/api/v1/clean/address"

  @doc """
  Determine coordinates the address.

  See [documentation](https://dadata.ru/api/geocode/)
  for more information.

  ## Example

      ExDadata.Address.geocode_address(client, ["мск сухонска 11/-89"])
  """
  def geocode_address(client, data) do
    with {:ok, body} <- do_geocode_address(client, data) do
      {:ok, GeocodeAddress.new!(body)}
    end
  end

  defp do_geocode_address(client, data) do
    headers = Client.to_headers(client)
    adapter = Client.adapter(client)

    case adapter.request(:post, @geocode_address_url, headers, data, []) do
      {:ok, %Response{status: 200, body: response}} -> {:ok, response}
      {:ok, resp} -> {:error, resp}
      {:error, _} = error -> error
    end
  end

  @geolocate_address_url "https://suggestions.dadata.ru/suggestions/api/4_1/rs/geolocate/address"

  @doc """
  Search addresses which are close to coordinates.

  See [documentation](https://dadata.ru/api/geolocate/) for more
  info.

  ## Example

      ExDadata.Address.geolocate_address(client, %{lat: 55.601983, lon: 37.359486})
  """
  def geolocate_address(client, data) do
    with {:ok, body} <- do_geolocate_address(client, data) do
      {:ok, GeolocateAddress.new!(body)}
    end
  end

  defp do_geolocate_address(client, data) do
    headers =
      Client.to_headers(client) ++
        [
          {"Accept", "application/json"},
          {"Content-Type", "application/json"}
        ]

    adapter = Client.adapter(client)

    case adapter.request(:get, @geolocate_address_url, headers, data, []) do
      {:ok, %Response{status: 200, body: response}} -> {:ok, response}
      {:ok, resp} -> {:error, resp}
      {:error, _} = error -> error
    end
  end
end
