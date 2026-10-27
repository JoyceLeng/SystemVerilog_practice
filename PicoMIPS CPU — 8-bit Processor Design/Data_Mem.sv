////////////////////////////////////////////////////////
//Data Memory for picoMIPS
//load data from the memory and store results to memory
//address size:8b   data width:8
////////////////////////////////////////////////////////
module Data_Mem #(parameter Msize=8, width=8)
(input logic clk, rst_n,
 input logic w_en,
 input logic [Msize-1:0]mem_address,  //address index
 input logic signed [width-1:0]mem_Wdata,
 output logic signed [width-1:0]mem_Rdata,
 output logic signed [width-1:0] result
);

//generate a memory array
logic signed [width-1:0]Data_M[0:(2**Msize)-1];
int j;  //for resetting Data_M

//write data
always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n) begin
      for(j=0; j<(2**Msize); j++)
	Data_M[j] <= '0;
    end
    else if(w_en)
      Data_M[mem_address] <= mem_Wdata;
  end

//read data
assign mem_Rdata = Data_M[mem_address];
assign result = Data_M[8];

endmodule
