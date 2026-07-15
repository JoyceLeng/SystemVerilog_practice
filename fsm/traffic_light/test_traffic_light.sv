//testbench - traffic light system
module test_traffic_light;

//inputs
logic clk, rst_n, sixty, three, emergency;
//outputs
logic ns_green, ns_amber, ns_red, ew_green, ew_amber, ew_red;

//ports matching
traffic_light dut(.*);

//assertions
property reset_state;
  @(posedge clk)
  !rst_n |=> (ns_green && ew_red);
endproperty

assert property (reset_state)
else
  $error("reset state failed");

property S0_to_S1;
  @(posedge clk)
  (ns_green && ew_red && sixty)
         |=> (ns_amber && ew_red);
endproperty

assert property (S0_to_S1)
else
  $error("S0_to_S1 failed");

property S1_to_S2;
  @(posedge clk)
  (ns_amber && ew_red && three)
         |=> (ns_red && ew_green);
endproperty

assert property (S1_to_S2)
else
  $error("S1_to_S2 failed");

property S2_to_S3;
  @(posedge clk)
  (ns_red && ew_green && sixty)
         |=> (ns_red && ew_amber);
endproperty

assert property (S2_to_S3)
else
  $error("S2_to_S3 failed");

property S3_to_S0;
  @(posedge clk)
  (ns_red && ew_amber && three)
         |=> (ns_green && ew_red);
endproperty

assert property (S3_to_S0)
else
  $error("S3_to_S0 failed");

property S4_emergency;
  @(posedge clk)
  emergency |=> (ns_red && ew_red);
endproperty

assert property (S4_emergency)
else
  $error("S4_emergency failed");

//monitor
initial begin
  $monitor("Time=%0t emergency=%b sixty=%b three=%b",
           $time,
           emergency,
           sixty,
           three);
end

//initial clock
initial
  begin
    clk = '0;
    repeat(30) #10 clk = ~clk;
  end

//initial reset
initial
  begin
    rst_n = '0;
    #20;
    rst_n = '1;
  end

//initial main code
initial
  begin
    sixty = '0;
    three = '0;
    emergency = '0;

    @(posedge clk);

    sixty = '1; @(posedge clk);  //next state: S1

    sixty = '0;
    three = '1; @(posedge clk);  //next state: S2

    three = '0;
    sixty = '1; @(posedge clk);  //next state: S3

    sixty = '0;
    three = '1; @(posedge clk);  //next state: S0

    three = '0;
    sixty = '1; @(posedge clk);

    emergency = '1; @(posedge clk);  //next state: S4
    
    $finish;
    
  end

endmodule
