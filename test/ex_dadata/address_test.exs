defmodule ExDadata.AddressTest do
  use ExUnit.Case

  alias ExDadata.{Address, Client}

  describe "suggest_address/2" do
    defmodule MockSuggestAddressHTTPAdapter do
      @behaviour ExDadata.HTTPAdapter

      alias ExDadata.HTTPAdapter.Response

      @url "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address"

      def request(_, :post, @url, _, _, _) do
        body = %{
          "suggestions" => [
            %{
              "value" => "г Москва, ул Хабаровская",
              "unrestricted_value" => "г Москва, ул Хабаровская",
              "data" => %{
                "postal_code" => nil,
                "country" => "Россия",
                "country_iso_code" => "RU",
                "federal_district" => nil,
                "region_fias_id" => "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                "region_kladr_id" => "7700000000000",
                "region_iso_code" => "RU-MOW",
                "region_with_type" => "г Москва",
                "region_type" => "г",
                "region_type_full" => "город",
                "region" => "Москва",
                "area_fias_id" => nil,
                "area_kladr_id" => nil,
                "area_with_type" => nil,
                "area_type" => nil,
                "area_type_full" => nil,
                "area" => nil,
                "city_fias_id" => "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                "city_kladr_id" => "7700000000000",
                "city_with_type" => "г Москва",
                "city_type" => "г",
                "city_type_full" => "город",
                "city" => "Москва",
                "city_area" => nil,
                "city_district_fias_id" => nil,
                "city_district_kladr_id" => nil,
                "city_district_with_type" => nil,
                "city_district_type" => nil,
                "city_district_type_full" => nil,
                "city_district" => nil,
                "settlement_fias_id" => nil,
                "settlement_kladr_id" => nil,
                "settlement_with_type" => nil,
                "settlement_type" => nil,
                "settlement_type_full" => nil,
                "settlement" => nil,
                "street_fias_id" => "32fcb102-2a50-44c9-a00e-806420f448ea",
                "street_kladr_id" => "77000000000713400",
                "street_with_type" => "ул Хабаровская",
                "street_type" => "ул",
                "street_type_full" => "улица",
                "street" => "Хабаровская",
                "house_fias_id" => nil,
                "house_kladr_id" => nil,
                "house_cadnum" => nil,
                "house_type" => nil,
                "house_type_full" => nil,
                "house" => nil,
                "block_type" => nil,
                "block_type_full" => nil,
                "block" => nil,
                "flat_fias_id" => nil,
                "flat_cadnum" => nil,
                "flat_type" => nil,
                "flat_type_full" => nil,
                "flat" => nil,
                "flat_area" => nil,
                "square_meter_price" => nil,
                "flat_price" => nil,
                "postal_box" => nil,
                "fias_id" => "32fcb102-2a50-44c9-a00e-806420f448ea",
                "fias_code" => nil,
                "fias_level" => "7",
                "fias_actuality_state" => nil,
                "kladr_id" => "77000000000713400",
                "geoname_id" => nil,
                "capital_marker" => "0",
                "okato" => "45263564000",
                "oktmo" => "45305000",
                "tax_office" => "7718",
                "tax_office_legal" => "7718",
                "timezone" => nil,
                "geo_lat" => "55.8782557",
                "geo_lon" => "37.65372",
                "beltway_hit" => nil,
                "beltway_distance" => nil,
                "metro" => nil,
                "qc_geo" => nil,
                "qc_complete" => nil,
                "qc_house" => nil,
                "history_values" => [
                  "ул Черненко"
                ],
                "unparsed_parts" => nil,
                "source" => nil,
                "qc" => nil
              }
            }
          ]
        }

        {:ok, %Response{status: 200, headers: [], body: body}}
      end
    end

    test "returns suggestion on success" do
      client = Client.new(nil, nil, MockSuggestAddressHTTPAdapter, nil)

      assert {:ok, %{suggestions: [suggestion]}} =
               Address.suggest_address(client, %{query: "москва хабар"})

      assert %{
               value: "г Москва, ул Хабаровская",
               unrestricted_value: "г Москва, ул Хабаровская",
               data: %{
                 postal_code: nil,
                 country: "Россия",
                 country_iso_code: "RU",
                 federal_district: nil,
                 region_fias_id: "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                 region_kladr_id: "7700000000000",
                 region_iso_code: "RU-MOW",
                 region_with_type: "г Москва",
                 region_type: "г",
                 region_type_full: "город",
                 region: "Москва",
                 area_fias_id: nil,
                 area_kladr_id: nil,
                 area_with_type: nil,
                 area_type: nil,
                 area_type_full: nil,
                 area: nil,
                 city_fias_id: "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                 city_kladr_id: "7700000000000",
                 city_with_type: "г Москва",
                 city_type: "г",
                 city_type_full: "город",
                 city: "Москва",
                 city_area: nil,
                 city_district_fias_id: nil,
                 city_district_kladr_id: nil,
                 city_district_with_type: nil,
                 city_district_type: nil,
                 city_district_type_full: nil,
                 city_district: nil,
                 settlement_fias_id: nil,
                 settlement_kladr_id: nil,
                 settlement_with_type: nil,
                 settlement_type: nil,
                 settlement_type_full: nil,
                 settlement: nil,
                 street_fias_id: "32fcb102-2a50-44c9-a00e-806420f448ea",
                 street_kladr_id: "77000000000713400",
                 street_with_type: "ул Хабаровская",
                 street_type: "ул",
                 street_type_full: "улица",
                 street: "Хабаровская",
                 house_fias_id: nil,
                 house_kladr_id: nil,
                 house_type: nil,
                 house_type_full: nil,
                 house: nil,
                 block_type: nil,
                 block_type_full: nil,
                 block: nil,
                 flat_fias_id: nil,
                 flat_type: nil,
                 flat_type_full: nil,
                 flat: nil,
                 flat_area: nil,
                 square_meter_price: nil,
                 flat_price: nil,
                 postal_box: nil,
                 fias_id: "32fcb102-2a50-44c9-a00e-806420f448ea",
                 fias_code: nil,
                 fias_level: 7,
                 fias_actuality_state: nil,
                 kladr_id: "77000000000713400",
                 geoname_id: nil,
                 capital_marker: "0",
                 okato: "45263564000",
                 oktmo: "45305000",
                 tax_office: "7718",
                 tax_office_legal: "7718",
                 timezone: nil,
                 geo_lat: 55.8782557,
                 geo_lon: 37.65372,
                 beltway_hit: nil,
                 beltway_distance: nil,
                 metro: [],
                 qc_geo: nil,
                 history_values: ["ул Черненко"]
               }
             } = suggestion
    end
  end

  describe "geocode_address/2" do
    defmodule MockGeocodeAddressHTTPAdapter do
      @behaviour ExDadata.HTTPAdapter

      alias ExDadata.HTTPAdapter.Response

      def request(_, :post, "https://cleaner.dadata.ru/api/v1/clean/address", _, _, _) do
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

    test "returns addresses with coordinates on success" do
      client = Client.new(nil, nil, MockGeocodeAddressHTTPAdapter, nil)
      assert {:ok, [item]} = Address.geocode_address(client, [""])

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

  describe "geolocate_address/2" do
    defmodule MockGeolocateAddressHTTPAdapter do
      @behaviour ExDadata.HTTPAdapter

      alias ExDadata.HTTPAdapter.Response

      @url "https://suggestions.dadata.ru/suggestions/api/4_1/rs/geolocate/address"

      def request(_, :get, @url, _, _, _) do
        body = %{
          "suggestions" => [
            %{
              "value" => "г Москва, ул Хабаровская",
              "unrestricted_value" => "г Москва, ул Хабаровская",
              "data" => %{
                "postal_code" => nil,
                "country" => "Россия",
                "country_iso_code" => "RU",
                "federal_district" => nil,
                "region_fias_id" => "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                "region_kladr_id" => "7700000000000",
                "region_iso_code" => "RU-MOW",
                "region_with_type" => "г Москва",
                "region_type" => "г",
                "region_type_full" => "город",
                "region" => "Москва",
                "area_fias_id" => nil,
                "area_kladr_id" => nil,
                "area_with_type" => nil,
                "area_type" => nil,
                "area_type_full" => nil,
                "area" => nil,
                "city_fias_id" => "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                "city_kladr_id" => "7700000000000",
                "city_with_type" => "г Москва",
                "city_type" => "г",
                "city_type_full" => "город",
                "city" => "Москва",
                "city_area" => nil,
                "city_district_fias_id" => nil,
                "city_district_kladr_id" => nil,
                "city_district_with_type" => nil,
                "city_district_type" => nil,
                "city_district_type_full" => nil,
                "city_district" => nil,
                "settlement_fias_id" => nil,
                "settlement_kladr_id" => nil,
                "settlement_with_type" => nil,
                "settlement_type" => nil,
                "settlement_type_full" => nil,
                "settlement" => nil,
                "street_fias_id" => "32fcb102-2a50-44c9-a00e-806420f448ea",
                "street_kladr_id" => "77000000000713400",
                "street_with_type" => "ул Хабаровская",
                "street_type" => "ул",
                "street_type_full" => "улица",
                "street" => "Хабаровская",
                "house_fias_id" => nil,
                "house_kladr_id" => nil,
                "house_cadnum" => nil,
                "house_type" => nil,
                "house_type_full" => nil,
                "house" => nil,
                "block_type" => nil,
                "block_type_full" => nil,
                "block" => nil,
                "flat_fias_id" => nil,
                "flat_cadnum" => nil,
                "flat_type" => nil,
                "flat_type_full" => nil,
                "flat" => nil,
                "flat_area" => nil,
                "square_meter_price" => nil,
                "flat_price" => nil,
                "postal_box" => nil,
                "fias_id" => "32fcb102-2a50-44c9-a00e-806420f448ea",
                "fias_code" => nil,
                "fias_level" => "7",
                "fias_actuality_state" => nil,
                "kladr_id" => "77000000000713400",
                "geoname_id" => nil,
                "capital_marker" => "0",
                "okato" => "45263564000",
                "oktmo" => "45305000",
                "tax_office" => "7718",
                "tax_office_legal" => "7718",
                "timezone" => nil,
                "geo_lat" => "55.8782557",
                "geo_lon" => "37.65372",
                "beltway_hit" => nil,
                "beltway_distance" => nil,
                "metro" => nil,
                "qc_geo" => nil,
                "qc_complete" => nil,
                "qc_house" => nil,
                "history_values" => [
                  "ул Черненко"
                ],
                "unparsed_parts" => nil,
                "source" => nil,
                "qc" => nil
              }
            }
          ]
        }

        {:ok, %Response{status: 200, headers: [], body: body}}
      end
    end

    test "returns suggestion on success" do
      client = Client.new(nil, nil, MockGeolocateAddressHTTPAdapter, nil)

      assert {:ok, %{suggestions: [suggestion]}} =
               Address.geolocate_address(client, %{query: %{lat: 55.601983, lon: 37.359486}})

      assert %{
               value: "г Москва, ул Хабаровская",
               unrestricted_value: "г Москва, ул Хабаровская",
               data: %{
                 postal_code: nil,
                 country: "Россия",
                 country_iso_code: "RU",
                 federal_district: nil,
                 region_fias_id: "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                 region_kladr_id: "7700000000000",
                 region_iso_code: "RU-MOW",
                 region_with_type: "г Москва",
                 region_type: "г",
                 region_type_full: "город",
                 region: "Москва",
                 area_fias_id: nil,
                 area_kladr_id: nil,
                 area_with_type: nil,
                 area_type: nil,
                 area_type_full: nil,
                 area: nil,
                 city_fias_id: "0c5b2444-70a0-4932-980c-b4dc0d3f02b5",
                 city_kladr_id: "7700000000000",
                 city_with_type: "г Москва",
                 city_type: "г",
                 city_type_full: "город",
                 city: "Москва",
                 city_area: nil,
                 city_district_fias_id: nil,
                 city_district_kladr_id: nil,
                 city_district_with_type: nil,
                 city_district_type: nil,
                 city_district_type_full: nil,
                 city_district: nil,
                 settlement_fias_id: nil,
                 settlement_kladr_id: nil,
                 settlement_with_type: nil,
                 settlement_type: nil,
                 settlement_type_full: nil,
                 settlement: nil,
                 street_fias_id: "32fcb102-2a50-44c9-a00e-806420f448ea",
                 street_kladr_id: "77000000000713400",
                 street_with_type: "ул Хабаровская",
                 street_type: "ул",
                 street_type_full: "улица",
                 street: "Хабаровская",
                 house_fias_id: nil,
                 house_kladr_id: nil,
                 house_type: nil,
                 house_type_full: nil,
                 house: nil,
                 block_type: nil,
                 block_type_full: nil,
                 block: nil,
                 flat_fias_id: nil,
                 flat_type: nil,
                 flat_type_full: nil,
                 flat: nil,
                 flat_area: nil,
                 square_meter_price: nil,
                 flat_price: nil,
                 postal_box: nil,
                 fias_id: "32fcb102-2a50-44c9-a00e-806420f448ea",
                 fias_code: nil,
                 fias_level: 7,
                 fias_actuality_state: nil,
                 kladr_id: "77000000000713400",
                 geoname_id: nil,
                 capital_marker: "0",
                 okato: "45263564000",
                 oktmo: "45305000",
                 tax_office: "7718",
                 tax_office_legal: "7718",
                 timezone: nil,
                 geo_lat: 55.8782557,
                 geo_lon: 37.65372,
                 beltway_hit: nil,
                 beltway_distance: nil,
                 metro: [],
                 qc_geo: nil,
                 history_values: ["ул Черненко"]
               }
             } = suggestion
    end
  end
end
