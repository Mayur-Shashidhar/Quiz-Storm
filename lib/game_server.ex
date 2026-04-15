defmodule QuizEngine.GameServer do
  use GenServer


  # Public API

  # Starts a new room process and registers it via Registry
  def start_link(room_name) do
    GenServer.start_link(__MODULE__, room_name, name: via_tuple(room_name))
  end

  # Player joins a room
  def join_room(room_name, player_name) do
    GenServer.call(via_tuple(room_name), {:join, player_name})
  end

  # Get current room state (useful for debugging / UI later)
  def get_state(room_name) do
    GenServer.call(via_tuple(room_name), :get_state)
  end

  # Set a question for the room
  def set_question(room_name, question, correct_answer) do
    GenServer.call(via_tuple(room_name), {:set_question, question, correct_answer})
  end

  # Player submits answer
  def submit_answer(room_name, player, answer) do
    GenServer.call(via_tuple(room_name), {:answer, player, answer})
  end


  # Internal logic

  @impl true
  def init(room_name) do
    # Each room maintains its own isolated state
    state = %{
      room: room_name,
      players: %{},
      question: nil,
      answer: nil,
      answered: MapSet.new(),
      timer_ref: nil,
      deadline: nil
    }

    IO.puts("✅ Room #{room_name} created")
    {:ok, state}
  end

  # Player joins
  @impl true
  def handle_call({:join, player}, _from, state) do
    if Map.has_key?(state.players, player) do
      {:reply, {:error, "Player already exists"}, state}
    else
      new_players = Map.put(state.players, player, 0)
      new_state = %{state | players: new_players}

      IO.puts("👤 #{player} joined #{state.room}")
      {:reply, :ok, new_state}
    end
  end

  # Return current state
  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  # Set question + timer
  @impl true
  def handle_call({:set_question, question, correct_answer}, _from, state) do
    # Cancel old timer if it exists
    if state.timer_ref do
      Process.cancel_timer(state.timer_ref)
    end

    duration = 10_000
    deadline = System.monotonic_time(:millisecond) + duration

    # Send async message after 10 seconds
    timer_ref = Process.send_after(self(), :end_question, duration)

    new_state = %{
      state
      | question: question,
        answer: correct_answer,
        answered: MapSet.new(),
        timer_ref: timer_ref,
        deadline: deadline
    }

    IO.puts("📢 New Question: #{question} (10s timer started)")
    {:reply, :ok, new_state}
  end

  # Handle answers safely
  @impl true
  def handle_call({:answer, player, answer}, _from, state) do
    now = System.monotonic_time(:millisecond)

    cond do
      not Map.has_key?(state.players, player) ->
        {:reply, {:error, "Player not in room"}, state}

      state.question == nil ->
        {:reply, {:error, "No active question"}, state}

      state.deadline && now > state.deadline ->
        {:reply, {:error, "Time is up"}, state}

      MapSet.member?(state.answered, player) ->
        {:reply, {:error, "Already answered"}, state}

      true ->
        new_answered = MapSet.put(state.answered, player)

        if answer == state.answer do
          new_players = Map.update!(state.players, player, &(&1 + 1))
          new_state = %{state | players: new_players, answered: new_answered}

          IO.puts("✅ #{player} got it RIGHT!")
          {:reply, :correct, new_state}
        else
          new_state = %{state | answered: new_answered}

          IO.puts("❌ #{player} got it WRONG!")
          {:reply, :wrong, new_state}
        end
    end
  end

  # Timer ends the question
  @impl true
  def handle_info(:end_question, state) do
    IO.puts("⏰ Time's up! Question ended.")

    new_state = %{
      state
      | question: nil,
        answer: nil,
        answered: MapSet.new(),
        timer_ref: nil,
        deadline: nil
    }

    {:noreply, new_state}
  end

  # Helper for Registry naming
  defp via_tuple(room_name) do
    {:via, Registry, {QuizEngine.RoomRegistry, room_name}}
  end
end
