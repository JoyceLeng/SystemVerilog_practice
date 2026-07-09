//testbench for sipo
module sipo_tb #(parameter N = 4);

//inputs
logic clk, rst_n;
logic serial_in;
//output
logic [N-1:0]parallel_out;

//instantiation
sipo #(.N(N)) dut(.*);

//assertion
property sipo_pro;
  @(posedge clk)
  disable iff(!rst_n)
  parallel_out == {$past(parallel_out[N-2:0]), $past(serial_in)};
endproperty

assert property (sipo_pro)
else
  $error("shift register_sipo failed");

//monitor
initial begin
  $monitor("Time=%0t serial_in=%b parallel_out=%b",
           $time,
           serial_in,
           parallel_out);
end

//stimulus
initial begin
  clk = 0;
  repeat(50) #10 clk = ~clk;
end

initial begin
  rst_n = 1; #5;
  rst_n = 0; #5;  //test if rst_n works
  rst_n = 1; #5;
end

initial
  begin
    serial_in = 0; #20;
    serial_in = 1; #20;
    serial_in = 0; #20;
    serial_in = 1; #20;

    serial_in = 1; #20;
    serial_in = 0; #20;
    serial_in = 1; #20;
    serial_in = 0; #20;

    $finish;

  end

endmodule
