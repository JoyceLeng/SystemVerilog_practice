/////////////////////////////////////////////////
//register for picoMIPS
//5b %d, 5b %s, 8b address/immediate
/////////////////////////////////////////////////
module Register #(parameter Rsize = 5, width = 8)
(input logic [Rsize-1:0]reg_s1, reg_s2,  //register index - unsigned
 input logic [Rsize-1:0]reg_d,  //register index - unsigned
 input logic signed [width-1:0]Wdata,
 input logic en,  //write enable
 input logic clk, rst_n,  //writing register - sequential logic
 output logic signed [width-1:0]Rdata1, Rdata2
);

logic signed [width-1:0]Reg[0:(2**Rsize)-1];  //32 registers, each of them has 8bits data
int i;  //for reseting Reg

//writing register
always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n) begin
      for(int i=0; i<(2**Rsize); i++)
        Reg[i] <= '0;
      end
    else if(en)
      Reg[reg_d] <= Wdata;
  end

//reading register  //dut.register.Reg[0] == 3,4 ;mem_Rdata[0]
  assign Rdata1 = Reg[reg_s1];  //this is x in ALU
  assign Rdata2 = Reg[reg_s2];  //this is h in ALU

endmodule
