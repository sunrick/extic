defmodule ExticTest do
  use ExUnit.Case
  doctest Extic

  test "greets the world" do
    assert Extic.hello() == :world
  end
end
