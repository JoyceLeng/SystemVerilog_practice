//testbench for PIPO
module pipo_tb  #(parameter N = 4);

//inputs
logic clk, rst_n;
logic [N-1:0]parallel_in;
//output
logic [N-1:0]parallel_out;

//instantiation
pipo #(.N(N)) dut(.*);

//assertion
property pipo_pro;
  @(posedge clk)
  disable iff(!rst_n)
  parallel_out == $past(parallel_in);
endproperty

assert property(pipo_pro)
else
  $error("pipo register failed");

//monitor
initial begin
  $monitor("Time=%0t parallel_in=%b parallel_out=%b",
           $time,
           parallel_in,
           parallel_out);
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
    parallel_in = 4'b0; #20;

    parallel_in = 4'b1111; @(posedge clk);

    parallel_in = 4'b1010; @(posedge clk);

    $finish;

  end

endmodule
