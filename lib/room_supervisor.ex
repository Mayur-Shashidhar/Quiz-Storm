defmodule QuizEngine.RoomSupervisor do
  use DynamicSupervisor

  # Starts the supervisor when app boots
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    # Each room is independent
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # Start a new room process
  def start_room(room_name) do
    child_spec = {QuizEngine.GameServer, room_name}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
