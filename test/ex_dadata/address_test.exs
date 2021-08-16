defmodule ExDadata.AddressTest do
  use ExUnit.Case

  alias ExDadata.{Address, Client}

  describe "clean_address/2" do
    defmodule MockAddressHTTPAdapter do
      @behaviour ExDadata.HTTPAdapter

      alias ExDadata.HTTPAdapter.Response

      def request(:post, "https://cleaner.dadata.ru/api/v1/clean/address", _, _, _) do
        body = [
          %{
            "source" => "москва сухонская 11",
            "result" => "г Москва, ул Сухонская, д 11",
            "postal_code" => "127642",
            "country" => "Россия",
            "region" => "Москва",
            "city_area" => "Северо-восточный",
            "city_district" => "Северное Медведково",
            "street" => "Сухонская",
            "house" => "11",
            "geo_lat" => "55.8782557",
            "geo_lon" => "37.65372",
            "qc_geo" => 0
          }
        ]

        {:ok, %Response{status: 200, headers: [], body: body}}
      end
    end

    test "returns addresses on success" do
      client = Client.new(nil, nil, MockAddressHTTPAdapter)
      assert {:ok, %{items: [item]}} = Address.clean_address(client, [""])

      assert %{
               source: "москва сухонская 11",
               result: "г Москва, ул Сухонская, д 11",
               postal_code: "127642",
               country: "Россия",
               region: "Москва",
               city_area: "Северо-восточный",
               city_district: "Северное Медведково",
               street: "Сухонская",
               house: "11",
               geo_lat: 55.8782557,
               geo_lon: 37.65372,
               qc_geo: 0
             } = item
    end
  end
end
