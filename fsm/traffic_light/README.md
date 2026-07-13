# Traffic Light FSM
## State Diagram
'''mermaid
stateDiagram-v2

[*] --> ns_green

ns_green --> ns_amber: timer
ns_amber --> ew_green: timer
ew_green --> ew_amber: timer
ew_amber --> ns_green: timer

ns_green --> all_red: emergency
ns_amber --> all_red: emergency
ew_green --> all_red: emergency
ew_amber --> all_red: emergency

all_red --> ns_green: emergency cleared
'''

## Description
This project implements a traffic light controller using a finite state machine
