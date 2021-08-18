defmodule ExDadata.Address.SuggestAddress do
  @moduledoc false

  use Ecto.Schema

  alias __MODULE__.Suggestion
  alias Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :suggestions, Suggestion
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
    |> Changeset.cast_embed(:suggestions)
    |> Changeset.apply_action!(:insert)
  end
end
