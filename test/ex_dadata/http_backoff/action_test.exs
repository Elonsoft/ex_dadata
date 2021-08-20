defmodule ExDadata.HTTPBackoff.ActionTest do
  use ExUnit.Case

  alias ExDadata.HTTPAdapter.Response
  alias ExDadata.HTTPBackoff.Action

  test "returns return on any response that's not related to rate limits" do
    resp = %Response{status: 200}
    assert :return = Action.action(Action.new(), resp)
  end

  test "returns retry_after when catch rate limits" do
    resp = %Response{status: 429}
    assert {:retry_after, time} = Action.action(Action.new(), resp)
    assert div(time, 1_000) == 1
  end

  test "increases timeout for retries five times and then returns an error" do
    resp = %Response{status: 429}
    action = Action.new()
    assert {:retry_after, time} = Action.action(action, resp)
    assert div(time, 1_000) == 1

    action = Action.next(action)
    assert {:retry_after, time} = Action.action(action, resp)
    assert div(time, 1_000) == 2

    action = Action.next(action)
    assert {:retry_after, time} = Action.action(action, resp)
    assert div(time, 1_000) == 4

    action = Action.next(action)
    assert {:retry_after, time} = Action.action(action, resp)
    assert div(time, 1_000) == 8

    action = Action.next(action)
    assert {:retry_after, time} = Action.action(action, resp)
    assert div(time, 1_000) == 16

    action = Action.next(action)
    assert :return = Action.action(action, resp)
  end
end
