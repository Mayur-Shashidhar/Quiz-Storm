defmodule QuizEngine.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Registry handles mapping room_name → process
      {Registry, keys: :unique, name: QuizEngine.RoomRegistry},

      # Supervisor manages all room processes
      QuizEngine.RoomSupervisor
    ]

    opts = [strategy: :one_for_one, name: QuizEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
