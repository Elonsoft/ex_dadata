defmodule ExDadata.HTTPAdapter do
  @moduledoc """
  An interface to provide an HTTP client.
  """

  @typedoc """
  An http method.
  """
  @type method :: :get | :post | :patch | :put | :delete | :head

  @typedoc """
  Full url for the request.

  Note: You'll need to compose a proper full url with query params and
  everything else.
  """
  @type url :: String.t()

  @typedoc """
  A headers provided for the request.
  """
  @type header :: {String.t(), String.t()}

  @typedoc """
  JSON-body for the request. Provided as a map. May contain atoms.
  """
  @type body :: map

  @typedoc """
  Opts provided for specific adapters.
  """
  @type opts :: term

  defmodule Response do
    @moduledoc """
    Response struct.
    """

    defstruct ~w(status headers body)a

    @typedoc """
    A headers provided for the request.
    """
    @type header :: {String.t(), String.t()}

    @typedoc """
    JSON-body for the request. Provided as a map. May contain atoms.
    """
    @type body :: map

    @typedoc """
    The response struct on which the main logic depends.
    """
    @type t :: %__MODULE__{
            status: non_neg_integer,
            headers: [header],
            body: body
          }
  end

  @doc """
  Provides an ability to do an arbitrary request with json data.
  """
  @callback request(method, url, [header], body, opts) ::
              {:ok, Response.t()} | {:error, term}
end
