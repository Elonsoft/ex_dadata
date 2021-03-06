defmodule ExDadata.Address do
  @moduledoc """
  Entry point for address DaData API.

  For more information see [docs](https://dadata.ru/api/#address-clean).
  """

  alias __MODULE__.{GeocodeAddress, GeolocateAddress, SuggestAddress}
  alias ExDadata.Client
  alias ExDadata.HTTPAdapter.Response

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

    adapter = Client.http_adapter(client)

    case adapter.request(client, :post, @suggest_address_url, headers, data, []) do
      {:ok, %Response{status: 200, body: response}} -> {:ok, response}
      {:ok, resp} -> {:error, resp}
      {:error, _} = error -> error
    end
  end

  @geocode_address_url "https://cleaner.dadata.ru/api/v1/clean/address"

  @doc """
  Determine coordinates for the address.

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
    adapter = Client.http_adapter(client)

    case adapter.request(client, :post, @geocode_address_url, headers, data, []) do
      {:ok, %Response{status: 200, body: response}} -> {:ok, response}
      {:ok, resp} -> {:error, resp}
      {:error, _} = error -> error
    end
  end

  @geolocate_address_url "https://suggestions.dadata.ru/suggestions/api/4_1/rs/geolocate/address"

  @doc """
  Search addresses which are close to the coordinates.

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

    adapter = Client.http_adapter(client)
    url = compose_geolocate_url(data)

    case adapter.request(client, :get, url, headers, %{}, []) do
      {:ok, %Response{status: 200, body: response}} -> {:ok, response}
      {:ok, resp} -> {:error, resp}
      {:error, _} = error -> error
    end
  end

  defp compose_geolocate_url(data) do
    uri = %URI{
      URI.parse(@geolocate_address_url)
      | query: URI.encode_query(data)
    }

    URI.to_string(uri)
  end
end
