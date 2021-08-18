defmodule ExDadata.HTTPBackoff do
  @moduledoc false

  alias __MODULE__.Action

  # Create a new module that acts like HTTPAdapter from another one
  # implementing HTTPAdapter. The created module has backoff logic
  # mixed into it.
  def functor(adapter) do
    wrapped_module = Module.concat(adapter, Backoffed)

    case Code.ensure_compiled(wrapped_module) do
      {:module, module} -> module
      {:error, _} -> wrap_in_backoff(wrapped_module, adapter)
    end
  end

  defp wrap_in_backoff(wrapped_module, adapter) do
    ast =
      quote do
        defmodule unquote(wrapped_module) do
          def request(method, url, headers, body, opts) do
            unquote(__MODULE__).request(
              unquote(adapter),
              method,
              url,
              headers,
              body,
              opts,
              Action.new()
            )
          end
        end
      end

    [{module, _bytecode}] = Code.compile_quoted(ast)
    module
  end

  def request(adapter, method, url, headers, body, opts, action) do
    result = adapter.request(method, url, headers, body, opts)

    with {:ok, response} <- result do
      case Action.action(action, response) do
        {:retry_after, s} ->
          Process.sleep(s)
          request(adapter, method, url, headers, body, opts, Action.next(action))

        :return ->
          {:ok, response}
      end
    end
  end
end
