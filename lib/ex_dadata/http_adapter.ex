defmodule ExDadata.HTTPAdapter do
  @moduledoc false

  @type method :: :get | :post | :patch | :put | :delete | :head
  @type url :: String.t()
  @type header :: {String.t(), String.t()}
  @type body :: map
  @type opts :: term

  defmodule Response do
    @moduledoc false
    defstruct ~w(status headers body)a

    @type header :: {String.t(), String.t()}
    @type body :: map

    @type t :: %__MODULE__{
            status: non_neg_integer,
            headers: [header],
            body: body
          }
  end

  @callback request(method, url, [header], body, opts) ::
              {:ok, Response.t()} | {:error, term}
end
