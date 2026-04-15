defmodule QuizEngine.RoomManager do
  # Create a room only if it doesn't already exist
  def create_room(room_name) do
    case Registry.lookup(QuizEngine.RoomRegistry, room_name) do
      [] ->
        QuizEngine.RoomSupervisor.start_room(room_name)

      _ ->
        {:error, "Room already exists"}
    end
  end

  # List all active rooms
  def list_rooms do
    Registry.select(QuizEngine.RoomRegistry, [
      {
        {:"$1", :_, :_},
        [],
        [:"$1"]
      }
    ])
  end
end
