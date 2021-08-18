defmodule ExDadata.Address.GeolocateAddress.Suggestion do
  @moduledoc false

  use Ecto.Schema

  alias __MODULE__.Data
  alias Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :value, :string
    field :unrestricted_value, :string

    embeds_one :data, Data
  end

  @fields ~w(value unrestricted_value)a

  def changeset(suggestion, attrs) do
    suggestion
    |> Changeset.cast(attrs, @fields)
    |> Changeset.cast_embed(:data, required: true)
  end
end
