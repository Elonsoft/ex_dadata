defmodule ExDadataTest do
  use ExUnit.Case, async: false

  alias ExDadata.NoConfigError

  defmodule ValidConfig do
    use ExDadata, otp_app: :ex_dadata
  end

  describe "__using__/1" do
    test "creates a client function that returns configured client" do
      Application.put_env(:ex_dadata, ValidConfig,
        api_key: "api_key",
        secret_key: "secret_key",
        adapter: ExDadata.HTTPoison
      )

      assert client = ValidConfig.client()
      assert client.api_key == "api_key"
      assert client.secret_key == "secret_key"
      assert client.adapter == ExDadata.HTTPoison.Backoffed
    end

    test "raises an error in case :otp_app is not provided in the wrapper module" do
      assert_raise ArgumentError, "no :otp_app key provided", fn ->
        defmodule NoOtpAppConfig do
          use ExDadata
        end
      end
    end

    test "raises an error in case :otp_app is not an atom" do
      assert_raise ArgumentError, "expected :otp_app to be an atom", fn ->
        defmodule InvalidOtpAppConfig do
          use ExDadata, otp_app: 1
        end
      end
    end

    test "raises a runtime error if no api_key is set" do
      Application.put_env(:ex_dadata, ValidConfig,
        secret_key: "secret_key",
        adapter: ExDadata.HTTPoison
      )

      assert_raise NoConfigError, fn ->
        ValidConfig.client()
      end
    end

    test "raises a runtime error if no secret_key is set" do
      Application.put_env(:ex_dadata, ValidConfig,
        api_key: "api_key",
        adapter: ExDadata.HTTPoison
      )

      assert_raise NoConfigError, fn ->
        ValidConfig.client()
      end
    end

    test "raises a runtime error if no adapter is set" do
      Application.put_env(:ex_dadata, ValidConfig,
        api_key: "api_key",
        secret_key: "secret_key"
      )

      assert_raise NoConfigError, fn ->
        ValidConfig.client()
      end
    end
  end
end
