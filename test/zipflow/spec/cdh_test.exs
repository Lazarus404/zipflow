defmodule Zipflow.Spec.CDHTest do
  use ExUnit.Case, async: true

  alias Zipflow.Spec.CDH

  test "encode returns ()" do
    ans = CDH.encode(fn x ->
      assert is_binary(x)
      nil
    end, [])
    assert nil == ans
  end

end
