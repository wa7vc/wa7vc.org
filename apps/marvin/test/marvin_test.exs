defmodule MarvinTest do
  use ExUnit.Case, async: true
  doctest Marvin

  # Note that we can't test that this returns the /correct/ string, at least not without just copying the code
  # from the method we're testing, which is, of course, dumb.
  test "returns string for application version" do
    assert is_bitstring(Marvin.version()) == true
  end
end
