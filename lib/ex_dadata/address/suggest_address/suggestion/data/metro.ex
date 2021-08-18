defmodule ExDadata.Address.SuggestAddress.Suggestion.Data.Metro do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :line, :string
    field :distance, :integer
  end

  @fields ~w(name line distance)a

  def cast_list!(list) when is_list(list) do
    Enum.map(list, fn attrs ->
      %__MODULE__{}
      |> Changeset.cast(attrs, @fields)
      |> Changeset.apply_action!(:insert)
    end)
  end
end
