defmodule ExDadata.Address.CleanAddressTest do
  use ExUnit.Case

  alias ExDadata.Address.CleanAddress

  describe "new!/1" do
    test "returns a struct with items" do
      data = [
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

      assert %CleanAddress{items: [item]} = CleanAddress.new!(data)

      assert %CleanAddress.Row{
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
