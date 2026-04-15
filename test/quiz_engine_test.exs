defmodule QuizEngineTest do
  use ExUnit.Case
  doctest QuizEngine

  test "greets the world" do
    assert QuizEngine.hello() == :world
  end
end
