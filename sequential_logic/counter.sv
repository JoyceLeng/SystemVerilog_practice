//Counter: automatically counts clock pulses
//sequential

module counter  #(parameter N = 4)
(input logic clk, rst_n,
 input logic en,
 output logic [N-1:0]q
);

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      q <= 0;
    else if(en)
      q <= q + 1;
  end
endmodule
