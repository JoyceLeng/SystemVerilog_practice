//shift register
//parallel in parellel out
module pipo  #(parameter N = 4)
(input logic clk, rst_n,
 input logic load,
 input logic [N-1:0]parallel_in,
 output logic [N-1:0]parallel_out
);

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      parallel_out <= 0;
    else
      //parallel_out <= {parallel_out[N-2:0], parallel_in};
      //this is not correct!
      //pipo is usually not a shift register, it is just a register!
      //pipo - no connections between filp-flops, no shifting
      parallel_out <= parallel_in;
  end

endmodule
