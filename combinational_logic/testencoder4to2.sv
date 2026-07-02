//testbench for encoder
module testencoder4to2;

//inputs
logic [3:0]in;
//outputs
logic [1:0]out;

//instantiation
encoder4to2 dut(.*);

//assertions
always_comb begin
  unique case(in)
    4'b0001: assert(out == 2'b00)
             else
               $error("encoder failed: in=%b out=%b expected=00", in, out);
    4'b0010: assert(out == 2'b01)
             else
               $error("encoder failed: in=%b out=%b expected=01", in, out);
    4'b0100: assert(out == 2'b10)
             else
               $error("encoder failed: in=%b out=%b expected=10", in, out);
    4'b1000: assert(out == 2'b11)
             else
               $error("encoder failed: in=%b out=%b expected=11", in, out);
    default: 
      $warning("invalid encoder input: %b", in); //
  endcase
end

//monitor result
initial begin
  $monitor("Time=%0t in=%b out=%b", $time, in, out);
end

//stimulus
initial
  begin
    in = 4'b0001; #10;
    in = 4'b0010; #10;
    in = 4'b0100; #10;
    in = 4'b1000; #10;

    $finish;
  end

endmodule
