/////////////////////////////////////////////////
//opcodes for picoMIPS
// 2**6= 64 instructions 
/////////////////////////////////////////////////

//define operations
`define X 6'b000000
`define H 6'b000001
`define ADD 6'b000010
`define SUB 6'b000011
`define MUL 6'b000100
`define ADDI 6'b000101
`define SUBI 6'b000110
`define MULI 6'b000111 
`define Y 6'b001100


//define branches

`define BEQ 6'b001000 
`define BNE 6'b001001 
`define BLT 6'b001010
`define BGE 6'b001011
