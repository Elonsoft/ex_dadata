defmodule ExDadata.Address.GeocodeAddress do
  @moduledoc false

  use Ecto.Schema

  alias __MODULE__.Row
  alias Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :items, Row
  end

  def new!(items) when is_list(items) do
    %__MODULE__{}
    |> Changeset.cast(%{"items" => items}, [])
    |> Changeset.cast_embed(:items)
    |> Changeset.apply_action!(:insert)
  end
end
