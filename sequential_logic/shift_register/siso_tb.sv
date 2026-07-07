//testbench for siso
module siso_tb #(parameter N = 4);

//inputs
logic clk, rst_n;
logic serial_in;
//outputs
logic serial_out;

//instantiation
siso #(.N(N)) dut(.*);

//assertions
property siso_pro; //set a name for the property
  @(posedge clk)
  //if reset is true, it is not necessary to do verification
  disable iff(!rst_n)  //ignore this assertion while reset is active
  serial_out == $past(serial_in, N);  //output the value that signal had N clock cycles ago
endproperty

assert property(siso_pro)
else
  $error("shift register_siso failed");

//monitor
initial begin
  $monitor("Time=%0t serial_in=%b serial_out=%b", $time, serial_in, serial_out);
end

//stimulus
initial begin
  clk = 0;
  repeat(50) #10 clk = ~clk;
end

initial begin
  rst_n = 1; #5;
  rst_n = 0; #5;  //test rst_n works
  rst_n = 1; #5;
end

initial
  begin
    serial_in = 1; #20;
    serial_in = 1; #20;
    serial_in = 1; #20;
    serial_in = 1; #20;

    serial_in = 0; #20;
    serial_in = 1; #20;
    serial_in = 0; #20;
    serial_in = 1; #20;

    $finish;

  end

endmodule
