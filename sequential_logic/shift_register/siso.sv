//shift register
//serial in serial out
module siso  #(parameter N = 4)
(input logic clk, rst_n,
 input logic serial_in,
 output logic serial_out
);

logic [N-1:0]siso_reg; //temporarily stores data

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      siso_reg <= 0;
    else
      //parallel stores in siso_reg
      siso_reg <= {siso_reg[N-2:0], serial_in};
  end

  assign serial_out = siso_reg[N-1]; //serial out the data

endmodule
