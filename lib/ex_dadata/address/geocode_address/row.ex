defmodule ExDadata.Address.GeocodeAddress.Row do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset

  @primary_key false
  embedded_schema do
      field :source, :string
      field :result, :string
      field :postal_code, :string
      field :country, :string
      field :region, :string
      field :city_area, :string
      field :city_district, :string
      field :street, :string
      field :house, :string
      field :geo_lat, :float
      field :geo_lon, :float
      field :qc_geo, :integer
  end

  @fields ~w(source result postal_code country region city_area city_district street house geo_lat geo_lon qc_geo)a

  def changeset(row, attrs) do
    row
    |> Changeset.cast(attrs, @fields)
    |> Changeset.validate_required(@fields)
  end
end
