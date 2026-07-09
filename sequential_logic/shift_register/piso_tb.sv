//testbench for piso
module piso_tb #(parameter N = 4);

//inputs
logic clk, rst_n;
logic [N-1:0]parallel_in;
logic load;
//output
logic serial_out;

//instantiation
piso #(.N(N)) dut(.*);

//assertion
//as PISO has two operations:
//load the parallel data, and shift left after each clock cycle
//use separate property
property piso_load;
  @(posedge clk)
  disable iff(!rst_n)
  //only load is true, piso_reg makes sence
  load |=> (dut.piso_reg == $past(parallel_in));
endproperty

property piso_shift;
  @(posedge clk)
  disable iff(!rst_n)
  //if load is false, piso_reg start shifting left
  !load |=> (dut.piso_reg == {$past(dut.piso_reg[N-2:0]), 1'b0});
endproperty

property piso_out;
  @(posedge clk)
  disable iff(!rst_n)
  //serial_out is a continuous assignment.
  serial_out == dut.piso_reg[N-1];
endproperty

assert property(piso_load)
else
  $error("load data failed");

assert property(piso_shift)
else
  $error("shifting failed");

assert property(piso_out)
else
  $error("output failed");


//use monitor
initial begin
  $monitor("Time=%0t load=%b parallel_in=%b serial_out=%b",
           $time,
           load,
           parallel_in,
           serial_out);
end

//stimulus
initial begin
  clk = 0;
  repeat(50) #10 clk = ~clk;
end

initial begin
  rst_n = 0; #5;
  rst_n = 1; #5;
end

initial
  begin
    load = 0;
    parallel_in = 4'b0; #20;

    parallel_in = 4'b1111;   //expected output = 1
    load = 1; @(posedge clk);
    load = 0; repeat(4) @(posedge clk); //four clocks to shift everything out

    parallel_in = 4'b1010;   //expected output = 1
    load = 1; #20;
    load = 0; #80; //four clocks to shift everything out

    parallel_in = 4'b0101;   //expected output = 0
    load = 1; #20;
    load = 0; #80; //four clocks to shift everything out

    $finish;

  end

endmodule
