defmodule ExDadata.HTTPBackoffTest do
  use ExUnit.Case

  alias ExDadata.HTTPAdapter
  alias ExDadata.HTTPAdapter.Response
  alias ExDadata.HTTPBackoff

  describe "functor/1" do
    defmodule SomeHTTPAdapter do
      @behaviour HTTPAdapter

      def request(_, url, _, body, _) do
        send(url, body)
        {:ok, %Response{status: 200}}
      end
    end

    test "generates module that calls request/5 function" do
      adapter = HTTPBackoff.functor(SomeHTTPAdapter)
      assert {:ok, %Response{status: 200}} = adapter.request(nil, self(), nil, :sent, nil)
      assert_receive :sent
    end
  end

  describe "request/7" do
    defmodule SuccessfulHTTPAdapter do
      @behaviour HTTPAdapter
      def request(_, _, _, _, _) do
        {:ok, %Response{status: 200}}
      end
    end

    defmodule SuccessOnSecondHTTPAdapter do
      @behaviour HTTPAdapter
      def request(_, _, _, _, _) do
        case Process.get({self(), :success_on_second}) do
          nil ->
            Process.put({self(), :success_on_second}, :some)
            {:ok, %Response{status: 403}}

          :some ->
            Process.delete({self(), :success_on_second})
            {:ok, %Response{status: 200}}
        end
      end
    end

    test "SuccessOnSecondHTTPAdapter works" do
      assert {:ok, %Response{status: 403}} =
               SuccessOnSecondHTTPAdapter.request(nil, nil, nil, nil, nil)

      assert {:ok, %Response{status: 200}} =
               SuccessOnSecondHTTPAdapter.request(nil, nil, nil, nil, nil)
    end

    test "returns on first success" do
      adapter = HTTPBackoff.functor(SuccessfulHTTPAdapter)
      assert {:ok, %Response{status: 200}} = adapter.request(nil, nil, nil, nil, nil)
    end

    test "returns on second success" do
      adapter = HTTPBackoff.functor(SuccessOnSecondHTTPAdapter)
      assert {:ok, %Response{status: 200}} = adapter.request(nil, nil, nil, nil, nil)
    end
  end
end
