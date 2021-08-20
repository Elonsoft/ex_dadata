defmodule ExDadata.Address.GeocodeAddress do
  @moduledoc false

  use Ecto.Schema

  alias __MODULE__.{Metro, Row}
  alias Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :items, Row
  end

  def new!(attrs) when is_list(attrs) do
    %{items: items} = do_new!(attrs)

    Enum.map(items, fn
      %{metro: nil} = data ->
        %{data | metro: []}

      %{metro: list} = data when is_list(list) ->
        metro = Metro.cast_list!(list)
        %{data | metro: metro}
    end)
  end

  defp do_new!(items) when is_list(items) do
    %__MODULE__{}
    |> Changeset.cast(%{"items" => items}, [])
    |> Changeset.cast_embed(:items)
    |> Changeset.apply_action!(:insert)
  end
end
