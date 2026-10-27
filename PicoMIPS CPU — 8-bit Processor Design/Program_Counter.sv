/////////////////////////////////////////////////
//Program counter for picoMIPS
//6 bits opcodes, 64 instructions
//sequential logic
/////////////////////////////////////////////////
module Program_Counter #(parameter Psize = 6)
(input logic clk, rst_n,
 input logic PCnext, PCbranch, PCjump,
 input logic [Psize-1:0]offset,  //branch address
 output logic [Psize-1:0]PCaddress
);

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n) begin
      PCaddress <= '0;
    end
    else if(PCnext) begin
      PCaddress <= PCaddress + 1;
    end
    else if(PCbranch) begin
      PCaddress <= PCaddress + offset;
    end
    else if(PCjump) begin
      PCaddress <= offset;
    end
  end

endmodule
