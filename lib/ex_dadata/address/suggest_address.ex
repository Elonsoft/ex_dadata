defmodule ExDadata.Address.SuggestAddress do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :suggestions, Suggestion, primary_key: false do
      field :value, :string
      field :unrestricted_value, :string

      embeds_one :data, Data, primary_key: false do
        field :postal_code, :string
        field :country, :string
        field :country_iso_code, :string

        field :federal_district, :string

        field :region_fias_id, Ecto.UUID
        field :region_kladr_id, :string
        field :region_iso_code, :string
        field :region_with_type, :string
        field :region_type, :string
        field :region_type_full, :string
        field :region, :string

        field :area_fias_id, Ecto.UUID
        field :area_kladr_id, :string
        field :area_with_type, :string
        field :area_type, :string
        field :area_type_full, :string
        field :area, :string

        field :city_fias_id, Ecto.UUID
        field :city_kladr_id, :string
        field :city_with_type, :string
        field :city_type, :string
        field :city_type_full, :string
        field :city, :string

        field :city_district_fias_id, Ecto.UUID
        field :city_district_kladr_id, :string
        field :city_district_with_type, :string
        field :city_district_type, :string
        field :city_district_type_full, :string
        field :city_district, :string

        field :settlement_fias_id, Ecto.UUID
        field :settlement_kladr_id, :string
        field :settlement_with_type, :string
        field :settlement_type, :string
        field :settlement_type_full, :string
        field :settlement, :string

        field :street_fias_id, Ecto.UUID
        field :street_kladr_id, :string
        field :street_with_type, :string
        field :street_type, :string
        field :street_type_full, :string
        field :street, :string

        field :house_fias_id, Ecto.UUID
        field :house_kladr_id, :string
        field :house_type, :string
        field :house_type_full, :string
        field :house, :string

        field :block_type, :string
        field :block_type_full, :string
        field :block, :string

        field :flat_fias_id, Ecto.UUID
        field :flat_type, :string
        field :flat_type_full, :string
        field :flat, :string

        field :postal_box, :string
        field :fias_id, Ecto.UUID
        field :fias_level, :integer

        field :kladr_id, :string
        field :geoname_id, :string
        field :capital_marker, :string
        field :okato, :string
        field :oktmo, :string
        field :tax_office, :string
        field :tax_office_legal, :string

        field :history_values, {:array, :string}

        # Additional fields for all plans.
        field :geo_lat, :float
        field :geo_lon, :float
        field :qc_geo, :integer
        field :fias_code, :string
        field :fias_actuality_state, :integer
        field :city_area, :string

        # For "Extended" and "Max" plans.
        field :beltway_hit, :boolean
        field :beltway_distance, :integer

        # Only for "Max" plan.
        field :flat_area, :integer
        field :flat_price, :decimal
        field :timezone, :string
        field :square_meter_price, :decimal

        field :metro, :any, virtual: true
      end
    end
  end

  defmodule Suggestion.Data.Metro do
    @moduledoc false

    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :name, :string
      field :line, :string
      field :distance, :integer
    end

    @metro_fields ~w(name line distance)a

    def cast_list!(list) when is_list(list) do
      Enum.map(list, fn attrs ->
        %__MODULE__{}
        |> Changeset.cast(attrs, @metro_fields)
        |> Changeset.apply_action!(:insert)
      end)
    end
  end

  def new!(attrs) when is_map(attrs) do
    response = do_new!(attrs)

    suggestions =
      Enum.map(response.suggestions, fn
        %{data: %{metro: nil} = data} = suggestion ->
          %{suggestion | data: %{data | metro: []}}

        %{data: %{metro: list} = data} = suggestion when is_list(list) ->
          metro = Suggestion.Data.Metro.cast_list!(list)
          %{suggestion | data: %{data | metro: metro}}
      end)

    %{response | suggestions: suggestions}
  end

  defp do_new!(response) do
    %__MODULE__{}
    |> Changeset.cast(response, [])
    |> Changeset.cast_embed(:suggestions, with: &suggestion_changeset/2)
    |> Changeset.apply_action!(:insert)
  end

  @suggestion_fields ~w(value unrestricted_value)a

  defp suggestion_changeset(suggestion, attrs) do
    suggestion
    |> Changeset.cast(attrs, @suggestion_fields)
    |> Changeset.cast_embed(:data, with: &data_changeset/2, required: true)
  end

  @data_fields ~w(postal_code country country_iso_code federal_district region_fias_id region_kladr_id region_iso_code region_with_type region_type region_type_full region area_fias_id area_kladr_id area_with_type area_type area_type_full area city_fias_id city_kladr_id city_with_type city_type city_type_full city city_district_fias_id city_district_kladr_id city_district_with_type city_district_type city_district_type_full city_district settlement_fias_id settlement_kladr_id settlement_with_type settlement_type settlement_type_full settlement street_fias_id street_kladr_id street_with_type street_type street_type_full street house_fias_id house_kladr_id house_type house_type_full house block_type block_type_full block flat_fias_id flat_type flat_type_full flat postal_box fias_id fias_level kladr_id geoname_id capital_marker okato oktmo tax_office tax_office_legal history_values geo_lat geo_lon qc_geo fias_code fias_actuality_state city_area beltway_hit beltway_distance flat_area flat_price timezone square_meter_price metro)a

  defp data_changeset(data, attrs) do
    Changeset.cast(data, attrs, @data_fields)
  end
end
