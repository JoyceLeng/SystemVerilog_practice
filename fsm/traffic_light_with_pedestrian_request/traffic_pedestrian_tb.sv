//testbench for traffic system with pedestrian request
module traffic_pedestrian_tb;

//inputs
logic clk, rst_n;
logic pedestrian_button;
//outputs
logic pedestrian_light;
logic [1:0]ns_light;
logic [1:0]ew_light;

//instantiation
traffic_pedestrian dut(.*);

//assertion
//property: checking outputs or checking states, both are valid.
//checking states for FSM, is often clearer
property reset_state;
  @(posedge clk)
  !rst_n |-> (ns_light == 2'b00 && ew_light == 2'b10 && !pedestrian_light);
endproperty

property NS_GREEN_to_NS_AMBER;
  @(posedge clk)
  ((dut.present_state == dut.NS_GREEN) && dut.GREEN_timeout && !dut.pedestrian_request)
            |=> (dut.present_state == dut.NS_AMBER);
endproperty

property NS_AMBER_to_EW_GREEN;
  @(posedge clk)
  ((dut.present_state == dut.NS_AMBER) && dut.AMBER_timeout && !dut.pedestrian_request) 
            |=> (dut.present_state == dut.EW_GREEN);
endproperty

property EW_GREEN_to_EW_AMBER;
  @(posedge clk)
  ((dut.present_state == dut.EW_GREEN) && dut.GREEN_timeout && !dut.pedestrian_request) 
            |=> (dut.present_state == dut.EW_AMBER);
endproperty

property EW_AMBER_to_NS_GREEN;
  @(posedge clk)
  ((dut.present_state == dut.EW_AMBER) && dut.AMBER_timeout && !dut.pedestrian_request)
            |=> (dut.present_state == dut.NS_GREEN);
endproperty

property ALL_RED_BEFORE_PED;
  @(posedge clk)
  ((dut.present_state == dut.NS_GREEN) || (dut.present_state == dut.EW_GREEN))
                         && dut.GREEN_timeout && dut.pedestrian_request
            |=> (dut.present_state == dut.ALL_RED_BEFORE_PED);
endproperty

property PED_WALK;
  @(posedge clk)
  (dut.present_state == dut.ALL_RED_BEFORE_PED && dut.ALL_RED_timeout) 
            |=> (dut.present_state == dut.PED_WALK);
endproperty

property ALL_RED_AFTER_PED;
  @(posedge clk)
  (dut.present_state == dut.PED_WALK && dut.WALK_timeout) |=> (dut.present_state == dut.ALL_RED_AFTER_PED);
endproperty

assert property (reset_state)
else
  $error("reset_state failed");

assert property (NS_GREEN_to_NS_AMBER)
else
  $error("NS_GREEN_to_NS_AMBER failed");

assert property (NS_AMBER_to_EW_GREEN)
else
  $error("NS_AMBER_to_EW_GREEN failed");

assert property (EW_GREEN_to_EW_AMBER)
else
  $error("EW_GREEN_to_EW_AMBER failed");

assert property (EW_AMBER_to_NS_GREEN)
else
  $error("EW_AMBER_to_NS_GREEN failed");

assert property (ALL_RED_BEFORE_PED)
else
  $error("ALL_RED_BEFORE_PED failed");

assert property (PED_WALK)
else
  $error("PED_WALK failed");

assert property (ALL_RED_AFTER_PED)
else
  $error("ALL_RED_AFTER_PED failed");

//monitor
initial begin
  $monitor("Time=%0t present_state=%s pedestrian_button=%b pedestrian_request=%b counter_GREEN=%0d GREEN_timeout=%b next_state=%s",
          $time,
          dut.present_state.name(),
          pedestrian_button,
          dut.pedestrian_request,
          dut.counter_GREEN,
          dut.GREEN_timeout,
          dut.next_state.name());
end

//stimulus
initial begin
  clk = '0;
  repeat(600) #10 clk = ~clk;
end

initial begin
  rst_n = 0;
  pedestrian_button = 0;
  #5;
  rst_n = 1;
end

task automatic press_button;
  begin
    pedestrian_button = 1;
    @(posedge clk);
    pedestrian_button = 0;
  end
endtask

initial
  begin

    wait (dut.present_state == dut.NS_GREEN);
    press_button();

    wait (dut.present_state == dut.NS_AMBER);
    press_button();

    wait (dut.present_state == dut.EW_GREEN);
    press_button();

    wait (dut.present_state == dut.EW_AMBER);
    press_button();

    repeat(10) @(posedge clk);  // observe final behavior

    $finish;

  end

endmodule
