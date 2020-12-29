# CA Project 2

## Members & Teamwork
Team Members & Contributions
Sylvia Liao (R09922136): Wrote most of project code, organized/participated in meetings, wrote report  
Seth Austin Harding (B06902101): Assisted with coding, organized/participated in meetings, wrote report  
Sangwoo Yoo (B04902126): Wrote report and added graphs for explanation, participated in meetings  

## Modules & Descriptions
The finite state machine for the cache controller is illustrated below
![FSM](FSM.png)
as shown in our FSM, the controller alternates between the above 5 states. The FSM starts at an Idle state, and waits until there is a request (if no request, the state will not change). Upon receiving a request, the state changes to Miss, and there are two possibilities; if the SRAM is dirty, the state will change to Writeback; otherwise, Readmiss will be initiated. If it changes to to Readmiss, Readmiss will wait to receive ack. If changes to to Writeback, then it will stay in Writeback until receiving an ack to go to Readmiss. Readmiss will wait to receive an ack before going to the Readmissok state before finally unconditionally returning to the Idle state.

The architecture and connection between the CPU and the Data Memory is illustrated here.
![Architecture](architecture.jpg)

## Development Environment

## Difficulties Encountered and Solutions in This Project

