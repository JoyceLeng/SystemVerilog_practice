//testbench for register
//D Flip-Flop
module dffN_tb #(parameter N = 4);

//inputs
logic clk, rst_n;
logic [N-1:0]d;
//output
logic [N-1:0]q;

//instantiation
dffN #(.N(N)) dut(.*);

//assertion
property dffN_check;
  @(posedge clk)
  q |=> $past(d);
endproperty

assert property (dffN_check)
else
  $error("n-bit register failed");

//monitor
initial begin
  $monitor("Time=%0t d=%b q=%b", $time, d, q);
end

//stimulus
initial begin
  clk = '0;
  forever #10 clk = ~clk;
end

initial begin
  rst_n = '0;
  #20
  rst_n = '1;
end

initial
  begin
    d = 4'b0; #20;
    d = 4'b0001; @(posedge clk);
    d = 4'b0010; @(posedge clk);
    d = 4'b0011; @(posedge clk);
    d = 4'b0100; @(posedge clk);
    d = 4'b0101; @(posedge clk);
    d = 4'b0110; @(posedge clk);
    d = 4'b0111; @(posedge clk);
    d = 4'b1000; @(posedge clk);
    d = 4'b1001; @(posedge clk);
    d = 4'b1010; @(posedge clk);
    d = 4'b1011; @(posedge clk);
    d = 4'b1100; @(posedge clk);
    d = 4'b1101; @(posedge clk);
    d = 4'b1110; @(posedge clk);
    d = 4'b1111; @(posedge clk);

    $finish;

  end

endmodule
