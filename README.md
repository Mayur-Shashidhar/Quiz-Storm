# ⚡ QuizStorm – Real-Time Multiplayer Quiz Engine (Elixir)

QuizStorm is a **highly concurrent, fault-tolerant quiz engine** built using Elixir and OTP principles.  
It demonstrates how real-world backend systems handle **state, concurrency, timing, and process isolation** at scale.

---

## 🚀 What Makes This Project Different?

QuizStorm focuses on:

- ⚡ Process-based concurrency (not threads)
- 🧠 Stateful systems using GenServer
- ⏱️ Real-time event handling
- 🔒 Race-condition-safe logic
- 🧩 Fault-tolerant architecture (OTP)

---

## 🏗️ System Architecture

Application (Entry point)
 
   ↓

Supervisor (RoomSupervisor)

   ↓

Dynamic Workers (GameServer per room)

   ↑

Registry (room_name → PID mapping)

---

## 🧠 How the System Works

### Room Creation Flow

RoomManager.create_room("room1")

- Checks Registry
- Starts GameServer via Supervisor
- Registers process

---

### State Example

%{
  room: "room1",
  players: %{"Mayur" => 1},
  question: "2+2?",
  answer: "4",
  answered: MapSet.new(),
  deadline: timestamp
}

---

### Timer Logic

Process.send_after(self(), :end_question, 10_000)

---

## 📂 Project Structure

quiz_engine/
├── lib/
│   ├── game_server.ex
│   ├── room_supervisor.ex
│   ├── room_manager.ex
│   └── quiz_engine/application.ex
├── mix.exs
└── README.md

---

## ⚙️ Setup

brew install elixir

cd quiz_engine

mix deps.get
mix compile
iex -S mix

---

## 🧪 Usage

QuizEngine.RoomManager.create_room("room1")

QuizEngine.GameServer.join_room("room1", "Mayur")
QuizEngine.GameServer.join_room("room1", "Rhea")

QuizEngine.GameServer.set_question("room1", "5+5?", "10")

QuizEngine.GameServer.submit_answer("room1", "Mayur", "10")

---

## ⏱️ Features

- Multi-room concurrency
- Timer-based questions
- One-attempt rule
- Race-condition-safe logic
- Fault isolation

---

## 🧠 Concepts Used

- GenServer
- Supervisor
- Registry
- Actor Model
- BEAM VM
