//FSM - traffic light system
module traffic_light
(input logic clk, rst_n,
 input logic sixty, three,
 input logic emergency,
 output logic ns_green, ns_amber, ns_red,
 output logic ew_green, ew_amber, ew_red
);

enum{S0, S1, S2, S3, S4}present_state, next_state;

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      present_state <= S0;
    else
      present_state <= next_state;
  end

always_comb
  begin
    next_state = present_state;
    //default outputs
    ns_green = '0;
    ns_amber = '0;
    ns_red = '0;
    ew_green = '0;
    ew_amber = '0;
    ew_red = '0;
    //start state
    if(emergency) begin
      next_state = S4;
      ns_red = 1;
      ew_red = 1;
    end
    else begin
      unique case(present_state)
        S0: begin
              ns_green = 1;
              ew_red = 1;
              if(sixty)
                next_state = S1;
              else
                next_state = S0;
            end
        S1: begin
              ns_amber = 1;
              ew_red = 1;
              if(three)
                next_state = S2;
              else
                next_state = S1;
            end
        S2: begin
              ns_red = 1;
              ew_green = 1;
              if(sixty)
                next_state = S3;
              else
                next_state = S2;
            end
        S3: begin
              ns_red = 1;
              ew_amber = 1;
              if(three)
                next_state = S0;
              else
                next_state = S3;
            end
        S4: begin
              next_state = S0;
            end
      endcase
    end
  end
endmodule
