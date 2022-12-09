defmodule DougTest do
  use ExUnit.Case
  doctest Doug

  test "greets the world" do
    assert Doug.hello() == :world
  end
end
