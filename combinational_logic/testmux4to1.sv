//testbench for 4:1 mux
module testmux4to1;

//inputs
logic [3:0]in0;
logic [3:0]in1;
logic [3:0]in2;
logic [3:0]in3;
logic [1:0]sel;
//outputs
logic [3:0]out;

//match ports
//instantiation
mux4to1 dut(.*);


//assertion
always_comb begin
    unique case(sel)
      2'b00: assert(out == in0);
      2'b01: assert(out == in1);
      2'b10: assert(out == in2);
      2'b11: assert(out == in3);
    endcase
end

//convenient for quickly observing signal changes
//without using multiple display statements
//use $monitor
initial begin
    $monitor("Time=%0t sel=%b out=%b", $time, sel, out);
end

//initial
initial
  begin
    in0 = 4'b0001;
    in1 = 4'b0010;
    in2 = 4'b0100;
    in3 = 4'b1000;

    sel = 2'b00; #10;
    sel = 2'b01; #10;
    sel = 2'b10; #10;
    sel = 2'b11; #10;

    $finish;

  end

endmodule
