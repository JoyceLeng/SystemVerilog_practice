/////////////////////////////////////////////////
//decoder unit for picoMIPS
//format: 6b opcode, 5b %d, 5b %s, 8b address width
/////////////////////////////////////////////////
`include "opcodes.sv"
`include "ALU_codes.sv"
module DECODER_unit #(parameter Osize = 6)
(input logic [Osize-1:0]opcode,  //6 bits opcode - to know what operation?
 input logic [3:0]flag,  //4 ALU flags
 //generate control signals
 output logic PCnext, PCbranch, PCjump,  //PC controls
 output logic [2:0]ALUfunc,   //ALU control: it only has 3 bits
 output logic re_con,      //register file control
 output logic imm_con,    //immediate signal control
 output logic mem_to_reg,  //select signal - decide input
 output logic w_en  //data memory control signal
);

logic takebranch; //control conditional branch - to know should it branch?

always_comb
  begin
    //outputs initial
    PCnext = '1;  //default
    PCbranch = '0;
    PCjump = '0;
    ALUfunc = opcode[2:0];
    re_con = '0;
    imm_con = '0;
    mem_to_reg = '0;
    w_en = '0;

    takebranch = '0;

    //register logic
    //write 
    unique case(opcode)
      `X: begin
	    re_con = '1;
	    mem_to_reg = '1;
	  end
      `H: begin
	    re_con = '1;
	    mem_to_reg = '1;
	  end
      `Y: begin
	    w_en = '1;
	  end

      //register - register
      `ADD: begin
	      re_con = '1;
	    end
      `SUB: begin
	      re_con = '1;
	    end
      `MUL: begin
	      re_con = '1;
	    end

       //register - immediate
       `ADDI: begin
		 re_con = '1;
		 imm_con = '1;
	       end
       `SUBI: begin
		 re_con = '1;
		 imm_con = '1;
	       end
       `MULI: begin
		 re_con = '1;
		 imm_con = '1;
	       end

      //conditional branch
      //ALU flags: flag[0]-Z, flag[1]-N, flag[2]-C, flag[3]-V
      `BEQ: takebranch = flag[0];  //x=h
      `BNE: takebranch = ~flag[0];  //x!=h
      `BLT: takebranch = flag[1]^flag[3];  //x<h, N^V
      `BGE: takebranch = ~(flag[1]^flag[3]);  //x>=h, ~(N^V)
      default: $error("unimplemented opcode %h", opcode);

    endcase
    
    if(takebranch) begin
      PCnext = '0;  //PCnext: normal sequential PC
      PCjump = '1;  //PCjump: branch target PC
    end

  end

endmodule
