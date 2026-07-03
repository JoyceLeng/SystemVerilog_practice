//testbench for priority encoder
module testpriencoder4to2 #(parameter N = 2);

//inputs
logic [(2**N)-1:0]in;
//outputs
logic [N-1:0]out;

//instantiation
priencoder4to2 #(.N(N)) dut(.*);

//assertions
always_comb begin
  unique case(in)
    4'b0001: assert(out == 2'b00)
             else
               $error("priority encoder failed: in=%b out=%b expected=00", in, out);
    4'b0010: assert(out == 2'b01)
             else
               $error("priority encoder failed: in=%b out=%b expected=01", in, out);
    4'b0100: assert(out == 2'b10)
             else
               $error("priority encoder failed: in=%b out=%b expected=10", in, out);
    4'b1000: assert(out == 2'b11)
             else
               $error("priority encoder failed: in=%b out=%b expected=11", in, out);
    4'b0011: assert(out == 2'b01)
             else
               $error("priority encoder failed: in=%b out=%b expected=01", in, out);
    4'b0110: assert(out == 2'b10)
             else
               $error("priority encoder failed: in=%b out=%b expected=10", in, out);
    4'b1010: assert(out == 2'b11)
             else
               $error("priority encoder failed: in=%b out=%b expected=11", in, out);
    4'b1111: assert(out == 2'b11)
             else
               $error("priority encoder failed: in=%b out=%b expected=11", in, out);
    default: 
      $warning("invalid encoder input: %b", in);
  endcase
end

//monitor result
initial begin
  $monitor("in=%b out=%b", in, out);
end

//stimulus
initial
  begin
    //priority encoder
    in = 4'b0001; #10;
    in = 4'b0010; #10;
    in = 4'b0100; #10;
    in = 4'b1000; #10;

    in = 4'b0011; #10;
    in = 4'b0110; #10;
    in = 4'b1010; #10;
    in = 4'b1111; #10;

    $finish;

  end

endmodule
