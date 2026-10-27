/////////////////////////////////////////////////
//picoMIPS cpu
/////////////////////////////////////////////////
`include "opcodes.sv"
module picoMIPS #(parameter width = 8)
(input logic clk,
 input logic rst_n,
 output logic signed [width-1:0]y
);

//Program Counter
parameter Psize = 6;
logic PCnext, PCbranch, PCjump;
logic [Psize-1:0]offset;  //branch address
logic [Psize-1:0]PCaddress;

//Program Memory
parameter Isize = 24;
logic [Isize-1:0]I;   //each of instructions is 24b

//Decoder
parameter Osize = 6;
logic [Osize-1:0]opcode;  //6 bits opcode - to know what operation?
logic [3:0]flag;  //4 ALU flags
 //generate control signals
logic [2:0]ALUfunc;   //ALU control: it only has 3 bits
logic re_con;      //register file control
logic imm_con;    //immediate signal control

//ALU
logic signed [width-1:0]x, h;
logic signed [width-1:0] alu_y;

//register
parameter Rsize = 5;
logic [Rsize-1:0]reg_s1, reg_s2, reg_d;  //register index - unsigned
logic signed [width-1:0]Wdata;
logic en;  //write enable
logic signed [width-1:0]Rdata1, Rdata2;

//data memory
parameter Msize = 8;
logic w_en;
logic [Msize-1:0]mem_address;  //address index
logic signed [width-1:0]mem_Wdata, mem_Rdata;
logic mem_to_reg;
logic signed [width-1:0] fir_result;

assign opcode = I[Isize-1:Isize-6];
assign mem_Wdata = Rdata1;
assign y = fir_result;
assign mem_address = I[7:0];

//Select input signal
always_comb begin
  if(mem_to_reg)
    Wdata = mem_Rdata;   //X H
  else
    Wdata = alu_y;  //ADD MUL
end

//Decode the register fields according to instruction type
always_comb begin
  reg_s1 = I[Isize-12:Isize-16];  //I[12:8]
  reg_s2 = I[Isize-17:Isize-21];  //I[7:3]
  reg_d = I[Isize-7:Isize-11];  //I[17:13]

  unique case(opcode)
    `X,`H: begin
      reg_s1 = '0;
      reg_s2 = '0;
      reg_d = I[Isize-7:Isize-11];  //I[17:13]
    end
    `Y: begin
      reg_s1 = I[Isize-7:Isize-11];  //I[17:13]
      reg_s2 = '0;
      reg_d = '0;
    end
    default: begin
      reg_s1 = I[Isize-12:Isize-16];
      reg_s2 = I[Isize-17:Isize-21];
      reg_d = I[Isize-7:Isize-11];
    end
  endcase
end

////////////instantiation/////////////////

Program_Counter #(.Psize(Psize))
		progCounter(.clk(clk), .rst_n(rst_n),
		.PCnext(PCnext), .PCbranch(PCbranch), .PCjump(PCjump),
		.offset(I[Isize-1:Isize-6]), .PCaddress(PCaddress));

Program_Memory #(.Isize(Isize), .Psize(Psize))
	       progMem(.PCaddress(PCaddress), .I(I));

DECODER_unit #(.Osize(Osize))
	     decoder (.opcode(opcode), .flag(flag),
	              .PCnext(PCnext), .PCbranch(PCbranch), .PCjump(PCjump),
	              .ALUfunc(ALUfunc), .re_con(re_con), .imm_con(imm_con),
		      .mem_to_reg(mem_to_reg), .w_en(w_en));

ALU_unit #(.width(width))
	 alu (.x(Rdata1), .h(Rdata2),
	      .ALUfunc(ALUfunc), .flag(flag), .y(alu_y));

Register #(.Rsize(Rsize), .width(width))
         register (.reg_s1(reg_s1),  //x
		   .reg_s2(reg_s2),  //h
		   .reg_d(reg_d),
		   .Wdata(Wdata), .en(re_con), .clk(clk), .rst_n(rst_n),
		   .Rdata1(Rdata1), .Rdata2(Rdata2));

Data_Mem #(.Msize(Msize), .width(width))
         dataMemory (.clk(clk), .rst_n(rst_n),
                     .w_en(w_en), 
                     .mem_address(mem_address), .mem_Wdata(mem_Wdata), 
		     .mem_Rdata(mem_Rdata), .result(fir_result));

endmodule
