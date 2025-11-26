🚦 Traffic Light & Crosswalk Controller
Group Project – Arduino UNO R3

This project implements a fully functional traffic intersection controller using an Arduino UNO R3, two breadboards, LEDs, buttons, and hardware interrupts.
It simulates a real-world intersection with North/South and East/West lanes, each with their own traffic lights and pedestrian crosswalks.

📌 Project Overview

The circuit includes:

Two-direction traffic lights (North/South and East/West), each with:

Red, Yellow, and Green LEDs

Two pedestrian crosswalks, each with:

A crosswalk button

White “Walk” LED

Red “Don’t Walk” LED

A wiring layout showing resistors, LEDs, buttons, and Arduino UNO R3 connections.

The goal of this project is to write Arduino code that correctly controls the full traffic cycle, pedestrian signals, and interrupt-driven crosswalk requests.

✅ Requirements
1. Traffic Light Timing

Implement the standard traffic sequence:

Green → Yellow → Red

Both-Red phase (safety delay)

Both directions remain Red briefly before switching

This reflects real-world intersections, giving time to clear the intersection and avoid collisions.

⏱ Timing Rule:
No phase may be shorter than 2–3 seconds, ensuring the sequence is clearly observable.

2. Crosswalk Control

Each crosswalk button:

Uses an external interrupt to set a “walk requested” flag

Triggers the White “Walk” LED during the next Red phase for that direction

Activates the Red “Don’t Walk” LED during unsafe periods

3. Hardware Timers & Interrupts (Required)
✔ Hardware Timer Interrupt

A periodic interrupt (e.g., every 10–100 ms) updates timing counters that drive the traffic state machine.

✔ External Interrupts

Each pedestrian button has an ISR that sets a request flag:

walkRequested_NS

walkRequested_EW

The main loop checks these flags and starts the walk cycle during the next available Red phase.

4. Extra Credit (+5%)

During the second half of the pedestrian walk interval, the White LED blinks, signaling the pedestrian to finish crossing.

📂 Deliverables

This repository includes:

Arduino source code (.ino) implementing:

Full traffic light timing sequence

Crosswalk behavior with interrupts

Hardware timer usage

Documentation and comments explaining the design

🛠 Technologies Used

Arduino UNO R3

Hardware timers (Timer1 recommended)

External interrupts (attachInterrupt())

LEDs, resistors, push-buttons

Breadboard-based wiring

🎯 Learning Outcomes

State machine design

Real-time embedded system behavior

Interrupt-driven programming

Timing control using hardware timers

Practical traffic engineering concepts
