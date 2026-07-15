# Traffic Light FSM
## State Diagram

```mermaid
stateDiagram-v2

[*] --> ns_green

ns_green --> ns_amber: timer_60s
ns_amber --> ew_green: timer_3s
ew_green --> ew_amber: timer_60s
ew_amber --> ns_green: timer_3s

ns_green --> all_red: emergency
ns_amber --> all_red: emergency
ew_green --> all_red: emergency
ew_amber --> all_red: emergency

all_red --> ns_green: emergency cleared
```

## Description
This project implements a traffic light controller using a finite state machine

## Simulation Waveform
![Simulation Waveform](traffic_light_waveform.png)
