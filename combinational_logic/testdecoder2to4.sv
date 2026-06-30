//testbench for decoder
module testdecoder2to4;

//inputs
logic [1:0]in;
//outputs
logic [3:0]out;

//instantiation
decoder2to4 dut(.*);

//assertions
always_comb begin
  assert(out == 1'b1 << in)
  else
    $error("decoder fail: in=%b out=%b expected=%b", in, out, (1'b1 << in));
end

//monitor result
initial begin
  $monitor("Time=%0t in=%b out=%b",$time, in, out);
end

//stimulus
initial
  begin
    in = 2'b00; #10;
    in = 2'b01; #10;
    in = 2'b10; #10;
    in = 2'b11; #10;

    $finish;
  end

endmodule
