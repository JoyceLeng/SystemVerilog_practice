//2:1 mux
module mux2
(input logic in0, 
 input logic in1,
 input logic sel,
 output logic out
);

always_comb
  begin
    if(sel)
      out = in1;
    else
      out = in0;
  end
endmodule
