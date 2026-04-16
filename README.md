# ⚡ QuizStorm – Real-Time Multiplayer Quiz Engine (Elixir)

> A highly concurrent, fault-tolerant backend system built using **Elixir and OTP**, designed to simulate real-time multiplayer quiz environments with strong guarantees on **state consistency, isolation, and scalability**.

---

## 📌 Overview

**QuizStorm** is not just a quiz app — it is a **distributed systems-inspired backend engine** that demonstrates how modern systems handle:

* Massive concurrency using lightweight processes
* Stateful interactions in real time
* Fault isolation and recovery
* Deterministic timing (question deadlines)
* Safe concurrent updates without race conditions

Built on the **BEAM VM**, this project leverages Elixir’s strengths to model **real-world backend architectures** used in systems like chat apps, gaming servers, and live collaboration tools.

---

## 🚀 Key Highlights

* ⚡ **Process-based concurrency** (millions of lightweight processes)
* 🧠 **Stateful servers using GenServer**
* 🧩 **OTP Supervision Trees for fault tolerance**
* ⏱️ **Timer-driven events (real-time question deadlines)**
* 🔒 **Race-condition-free logic using message passing**
* 🏗️ **Dynamic room-based architecture**
* 📡 **Registry-based process discovery**

---

## 🏗️ System Architecture

```
Application (QuizEngine.Application)
        │
        ▼
Supervisor (RoomSupervisor)
        │
        ▼
Dynamic Workers (GameServer per room)
        │
        ▼
Registry (room_name → PID mapping)
```

### 🔍 Breakdown

| Component       | Responsibility                       |
| --------------- | ------------------------------------ |
| **Application** | Entry point, starts supervision tree |
| **Supervisor**  | Dynamically manages game rooms       |
| **GameServer**  | Handles room state (GenServer)       |
| **Registry**    | Maps room names to process IDs       |

---

## 🧠 Core Concepts Demonstrated

### 1. Actor Model

Each game room is an **independent process**, ensuring:

* No shared memory
* Message-driven communication
* Full isolation

---

### 2. GenServer (State Management)

Each room maintains structured state:

```elixir
%{
  room: "room1",
  players: %{"Mayur" => 1},
  question: "2+2?",
  answer: "4",
  answered: MapSet.new(),
  deadline: timestamp
}
```

---

### 3. Supervision (Fault Tolerance)

* If a room crashes → it can be restarted automatically
* Failures are **contained and isolated**
* System remains stable under load

---

### 4. Registry (Service Discovery)

Efficient mapping:

```
"room1" → PID
```

Allows:

* Fast lookup
* Scalable multi-room handling

---

### 5. Timer-based Events

```elixir
Process.send_after(self(), :end_question, 10_000)
```

* Enables real-time deadlines
* Non-blocking scheduling
* Fully asynchronous execution

---

## 🔄 System Workflow

### 🏠 Room Creation

```elixir
QuizEngine.RoomManager.create_room("room1")
```

Flow:

1. Check if room exists via Registry
2. Start GameServer using Supervisor
3. Register process

---

### 👥 Player Join

```elixir
QuizEngine.GameServer.join_room("room1", "Mayur")
```

* Updates player state
* Ensures no duplication
* Maintains consistent state

---

### ❓ Question Flow

```elixir
QuizEngine.GameServer.set_question("room1", "5+5?", "10")
```

* Sets question + answer
* Starts timer
* Resets answer tracking

---

### ✅ Answer Submission

```elixir
QuizEngine.GameServer.submit_answer("room1", "Mayur", "10")
```

* Validates answer
* Enforces **one-attempt rule**
* Prevents race conditions

---

## ⏱️ Features

* 🏠 Multi-room support (dynamic processes)
* 👥 Concurrent players per room
* ⏳ Timer-based questions
* 🚫 One-attempt per user per question
* 🔒 Race-condition-safe logic
* 🔁 Fault recovery via OTP
* ⚡ High concurrency scalability

---

## 📂 Project Structure

```
Quiz-Storm/
│
├── lib/                # Core application logic
│   ├── quiz_engine/
│   │   ├── application.ex
│   │   ├── room_manager.ex
│   │   ├── game_server.ex
│   │   └── ...
│
├── test/               # Unit & integration tests
│
├── mix.exs             # Project configuration
├── .formatter.exs      # Code formatting rules
├── .gitignore
├── LICENSE
└── README.md
```

---

## ⚙️ Setup & Installation

### 1️⃣ Install Elixir

```bash
brew install elixir
```

Check version:

```bash
elixir -v
```

---

### 2️⃣ Clone Repository

```bash
git clone https://github.com/Mayur-Shashidhar/Quiz-Storm.git
cd Quiz-Storm
```

---

### 3️⃣ Install Dependencies

```bash
mix deps.get
```

---

### 4️⃣ Compile Project

```bash
mix compile
```

---

### 5️⃣ Run Interactive Shell

```bash
iex -S mix
```

---

## 🧪 Usage Examples

### Create Room

```elixir
QuizEngine.RoomManager.create_room("room1")
```

### Join Players

```elixir
QuizEngine.GameServer.join_room("room1", "Mayur")
QuizEngine.GameServer.join_room("room1", "Rhea")
```

### Set Question

```elixir
QuizEngine.GameServer.set_question("room1", "5+5?", "10")
```

### Submit Answer

```elixir
QuizEngine.GameServer.submit_answer("room1", "Mayur", "10")
```

---

## 🧪 Testing

Run tests using:

```bash
mix test
```

Covers:

* Room creation
* Player joining
* Answer validation
* State transitions

---

## 🔮 Future Enhancements

* 🌐 WebSocket-based real-time frontend (Phoenix Channels)
* 📊 Leaderboard system
* 🧠 Question bank with categories/difficulty
* 🗄️ Persistent storage (ETS / Database)
* 📡 Distributed node support (multi-server scaling)

---

## 📜 License

Licensed under the **GPL-3.0 License**.

---

## ⭐ Why This Project Matters

This project demonstrates:

* Real-world backend engineering concepts
* Deep understanding of concurrency models
* Practical use of Elixir/OTP for scalable systems

> 💡 Ideal for showcasing **systems design + backend engineering skills** in interviews and portfolios.
