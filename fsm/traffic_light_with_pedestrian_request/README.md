# Traffic Light FSM with Pedestrian Request
## State Diagram

```mermaid
stateDiagram-v2

[*] --> NS_GREEN

%%=========================
%% Normal traffic sequence
%%=========================
NS_GREEN --> NS_AMBER: GREEN_timeout\n!Pedestrian_request
NS_AMBER --> EW_GREEN: AMBER_timeout\n!Pedestrian_request
EW_GREEN --> EW_AMBER: GREEN_timeout\n!Pedestrian_request
EW_AMBER --> NS_GREEN: AMBER_timeout\n!Pedestrian_request

%%=====================
%% Pedestrian request
%%=====================

NS_GREEN --> ALL_RED_BEFORE_PED: GREEN_timeout\nPedestrian_request
NS_AMBER --> ALL_RED_BEFORE_PED: Pedestrian_request
EW_GREEN --> ALL_RED_BEFORE_PED: GREEN_timeout\nPedestrian_request
EW_AMBER --> ALL_RED_BEFORE_PED: Pedestrian_request

ALL_RED_BEFORE_PED --> PED_WALK: ALL_RED_timeout
PED_WALK --> ALL_RED_AFTER_PED: WALK_timeout

%%===========================
%% Resume interrupted traffic
%%===========================

ALL_RED_AFTER_PED --> NS_GREEN: return_state == EW_AMBER
ALL_RED_AFTER_PED --> NS_AMBER: return_state == NS_GREEN
ALL_RED_AFTER_PED --> EW_GREEN: return_state == NS_AMBER
ALL_RED_AFTER_PED --> EW_AMBER: return_state == EW_GREEN

```

## Description
This project implements a traffic light controller with pedestrian request.

## Simulation Waveform
![Simulation Waveform](traffic_pedestrian_waveform.png)

## Monitor Result
![Monitor Result](traffic_pedestrian_monitor_result_NS_GREEN_to_ALL_RED_BEFORE_PED.png)
![Monitor Result](traffic_pedestrian_monitor_result_ALL_RED_AFTER_PED_to_NS_AMBER.png)
![Monitor Result](traffic_pedestrian_monitor_result_EW_GREEN_to_ALL_RED_BEFORE_PED.png)
