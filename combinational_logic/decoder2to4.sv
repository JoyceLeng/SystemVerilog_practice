//decoder: MIMO circuit that converts coded inputs into coded outputs
//n to 2^n: give 1'b1 and shift left one by one
module decoder2to4 #(parameter N = 2)
(input logic [N-1:0]in,
 output logic [(2**N)-1:0]out
);

  assign out = 1'b1 << in;

endmodule
