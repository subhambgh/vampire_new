defmodule VTest do
  use ExUnit.Case
  doctest V

  test "greets the world" do
    assert V.hello() == :world
  end
end
