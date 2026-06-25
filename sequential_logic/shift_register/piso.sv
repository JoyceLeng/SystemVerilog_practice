//shift register
//parallel in serial out
module piso  #(parameter N = 4)
(input logic clk, rst_n,
 input logic load,
 input logic [N-1:0]parallel_in,
 output logic serial_out
);

logic [N-1:0]piso_reg;

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      piso_reg <= 0;
    else if(load)
      //load all data
      piso_reg <= parallel_in;
    else
      //shift left
      piso_reg <= {piso_reg[N-2:0], 1'b0}
  end

//serial out the data
assign serial_out = piso_reg[N-1:0];

endmodule
