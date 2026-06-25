//shift register
//serial in parallel out
module sipo  #(parameter N = 4)
(input logic clk, rst_n,
 input logic serial_in,
 output logic [N-1:0]parallel_out
);

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      parallel_out <= 0;
    else
      //shift left
      parallel_out <= {parallel_out[N-2:0], serial_in};
  end

endmodule
