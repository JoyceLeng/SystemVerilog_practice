//4:1 mux
module mux4to1 #(parameter N = 4)
//data width is not related to 4:1 mux
//4-to-1 = "how many choices?"
//data width: "how many bits per choice?"
  (input logic [N-1:0]in0,
   input logic [N-1:0]in1,
   input logic [N-1:0]in2,
   input logic [N-1:0]in3,
   input logic [1:0]sel,
   output logic [N-1:0]out
);

always_comb
  begin
    unique case(sel)
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
      2'b11: out = in3;
      default: out = 4'b0;
    endcase
  end
endmodule
