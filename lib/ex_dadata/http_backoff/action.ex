defmodule ExDadata.HTTPBackoff.Action do
  @moduledoc false

  alias ExDadata.HTTPAdapter.Response

  defstruct [:count]

  def new do
    %__MODULE__{count: 0}
  end

  def next(%__MODULE__{count: n}) do
    %__MODULE__{count: n + 1}
  end

  def action(%__MODULE__{count: n}, %Response{status: 429}) when n > 4 do
    :return
  end

  def action(%__MODULE__{count: n}, %Response{status: 429}) do
    {:retry_after, backoff_time(n)}
  end

  def action(%__MODULE__{}, _) do
    :return
  end

  defp backoff_time(n) do
    base = :erlang.floor(:math.pow(2, n) * 1_000)
    random_number = :rand.uniform(1_000)
    base + random_number
  end
end
