//register - stores binary data temporarily
//built using filp-flops

//sequential

//D Flip-Flop with positive edge of clk
//n-bit register
module dffN  #(parameter N = 4)
(input logic clk, rst_n,
 input logic [N-1:0]d,
 output logic [N-1:0]q
);

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      q <= 0;
    else
      q <= d;
  end
endmodule
