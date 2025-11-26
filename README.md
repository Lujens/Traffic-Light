# 🚦 Traffic Light & Crosswalk Controller
**Group Project – Arduino UNO R3**

This project implements a fully functional **traffic intersection controller** using an Arduino UNO R3, two breadboards, LEDs, buttons, and hardware interrupts.  
It simulates a real-world intersection with **North/South** and **East/West** lanes, each with their own traffic lights and pedestrian crosswalks.

---

## 📌 Project Overview

**Circuit includes:**

### Traffic Lights (Two Directions)
- Red LED  
- Yellow LED  
- Green LED

### Pedestrian Crosswalks (Two total)
- Crosswalk push-button  
- White **“Walk”** LED  
- Red **“Don’t Walk”** LED

Also included: a wiring layout demonstrating Arduino UNO R3 connections, resistors, LEDs, and buttons.

**Goal:** implement Arduino code that controls the traffic cycle, pedestrian signals, and interrupt-driven crosswalk requests.

---

## ✅ Requirements

### 1. Traffic Light Timing
- Implement the standard traffic sequence: **Green → Yellow → Red**  
- Include a **Both-Red phase (safety delay)** where both directions display Red briefly before switching to the next Green.  
  - This reflects real-world intersections to allow vehicles to clear the intersection and reduce collision risk.

**Timing rule:** No phase may be shorter than **2–3 seconds** (each phase must be long enough to observe clearly).

---

### 2. Crosswalk Control
- Each crosswalk button uses an **external interrupt** to set a “walk requested” flag.  
- When the corresponding lane enters its next **Red** phase, the White **Walk** LED is activated if a request is pending.  
- The Red **Don’t Walk** LED is shown when crossing is not permitted.

---

### 3. Hardware Timers & Interrupts (Required)

#### ✔ Hardware Timer Interrupt
- Use a periodic hardware timer interrupt (e.g., every **10–100 ms**) to maintain counters that drive the traffic state machine.

#### ✔ External Interrupts
- Each pedestrian button has an ISR that sets a request flag, for example:
  - `walkRequested_NS`
  - `walkRequested_EW`
- The main loop checks these flags and begins the walk cycle during the next available Red phase.

---

### 4. Extra Credit (+5%)
- Blink the White **Walk** LED during the **last half** of the walk interval to signal pedestrians to finish crossing.

---

## 📂 Deliverables

This repository includes:

- Arduino source file: `traffic_controller.ino` implementing:
  - Full traffic light timing sequence
  - Crosswalk request behavior using interrupts
  - Hardware timer usage
- Documentation and inline comments explaining the design and state transitions

---

## 🛠 Technologies Used

- **Arduino UNO R3**  
- Hardware timers (e.g., `Timer1`)  
- External interrupts (`attachInterrupt()`)  
- LEDs, resistors, push-buttons  
- Breadboard wiring

---

## 🎯 Learning Outcomes

- State machine design  
- Real-time embedded system behavior  
- Interrupt-driven programming  
- Timing control using hardware timers  
- Practical traffic engineering concepts

---

## 📎 Notes / Suggestions
- Recommend using `Timer1` for the periodic timer and `attachInterrupt()` for button ISRs.  
- Ensure debouncing strategy for push-buttons (hardware or software).  
- Comment the code to explain why the both-Red safety delay exists (real-world justification).

