if Code.ensure_loaded?(HTTPoison) do
  defmodule ExDadata.HTTPoisonHTTPAdapter do
    @moduledoc """
    Default HTTP Adapter for this library.
    """

    alias ExDadata.Client
    alias ExDadata.HTTPAdapter
    alias ExDadata.HTTPAdapter.Response

    require Logger

    @behaviour HTTPAdapter

    @impl HTTPAdapter
    def request(client, method, url, headers, body, opts) do
      adapter = Client.json_adapter(client)
      bin_body = adapter.encode!(body)

      bin_headers =
        Enum.map(headers, fn {k, v} ->
          {String.to_charlist(k), String.to_charlist(v)}
        end)

      with {:ok, response} <-
             HTTPoison.request(method, url, bin_body, bin_headers, opts) do
        {:ok, wrap_response(response, adapter)}
      end
    end

    defp wrap_response(response, json) do
      %HTTPoison.Response{
        status_code: status,
        headers: headers,
        body: body
      } = response

      try do
        erl_body = json.decode!(body)
        %Response{status: status, headers: headers, body: erl_body}
      rescue
        _ -> %Response{status: status, headers: headers, body: body}
      end
    end
  end
end
