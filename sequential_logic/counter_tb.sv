//testbench for counter
module counter_tb #(parameter N = 4);

//inputs
logic clk, rst_n;
logic en;
//output
logic [N-1:0]q;

//instantiation
counter #(.N(N)) dut(.*);

//assertions
property counter_check;
  @(posedge clk)
  q |=> $past(q)+1;
endproperty

assert property (counter_check)
else
  $error("Counter failed");

//monitor
initial begin
  $monitor("Time = %0t en=%b q=%b", $time, en, q);
end

//stimulus
initial begin
  clk = '0;
  repeat(50) #10 clk = ~clk;
end

initial begin
  rst_n = '0;
  #20;
  rst_n = '1;
end

initial
  begin
    en = '0;

    en = '1; @(posedge clk);

    $finish;

  end

endmodule
