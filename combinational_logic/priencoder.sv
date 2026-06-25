//Priority Encoder: what if multiple inputs are 1?
//priority encoder: stop at most significant bit
module priencoder4to2  #(parameter N = 2)
(input logic [(2**N)-1:0]in,
 output logic [N-1:0]out
);

integer i;

always_comb
  begin
    out = 0;
    for(i=0; i<(2**N); i++)
      begin
        if(in[i])
          out = i;
      end
  end

endmodule
