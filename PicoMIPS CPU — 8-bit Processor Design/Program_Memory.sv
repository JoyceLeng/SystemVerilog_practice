/////////////////////////////////////////////////
//Program memory for picoMIPS
//6b opcodes, 5b %d, 5b %s, 8b address width
/////////////////////////////////////////////////
module Program_Memory #(parameter Psize = 6, Isize = 24)
(input logic [Psize-1:0]PCaddress,  //from previous processing: Program Counter
 output logic [Isize-1:0]I   //each of instructions is 24b
);

//64 instructions, each of instructions is 24b
logic [Isize-1:0]Mem[0:(2**Psize)-1];

//load data from prog.hex
initial begin
  $readmemh("C:/Users/lucas/OneDrive/Desktop/questasim_projects/questasim_bringup/picoMIPS design/prog.hex", Mem);
end

//read data
assign I = Mem[PCaddress];

endmodule
