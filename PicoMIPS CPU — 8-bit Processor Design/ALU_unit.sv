/////////////////////////////////////////////////
//ALU functional unit for picoMIPS
//number of func: 5
//ALU flags: flag[0]-Z, flag[1]-N, flag[2]-C, flag[3]-V
/////////////////////////////////////////////////
`include "ALU_codes.sv"
module ALU_unit #(parameter width = 8)
(input logic signed [width-1:0]x, h,
 input logic [2:0]ALUfunc,  //ALU function codes (ALU codes)
 output logic [3:0]flag, //independent ALU flags: Z, N, C, V
 output logic signed [width-1:0]y
);

logic [width-1:0]hr;
logic [(2*width)-1:0]mr;  //multiple result

always_comb
  begin
    hr = h;
    mr = '0;

    if(ALUfunc == `RSUB) begin
      hr = ~h + 1'b1;
    end

    if(ALUfunc == `RMUL) begin
      mr = $signed (x) * $signed (h);
    end
  end

//output logic and update ALU flags
always_comb
  begin
    y = '0;
    flag = '0;
    unique case(ALUfunc)
      `RX: begin
	     y = x;  //load x
	   end
      `RH: begin
	     y = h;  //load h
	   end
      `RADD, `RSUB: begin
	              y = x + hr;
		      //update flags
		      if(ALUfunc == `RADD) begin
                        //carry
			flag[2] = x[width-1]&h[width-1]|
				  x[width-1]&~y[width-1]|
				  h[width-1]&~y[width-1];
			//overflow
			flag[3] = x[width-1]&h[width-1]&~y[width-1]|
				  ~x[width-1]&~h[width-1]&y[width-1];
		      end
		      else begin
			//carry
			flag[2] = ~x[width-1]&h[width-1]|
				  ~x[width-1]&y[width-1]|
				  h[width-1]&y[width-1];
			//overflow
			flag[3] = ~x[width-1]&h[width-1]&y[width-1]|
				  x[width-1]&~h[width-1]&~y[width-1];
		      end
	            end
      `RMUL: begin
	       y = mr[width-1:0];
	       //carry
	       flag[2] = '0;
	       //overflow
	       flag[3] = '0;
	     end
       default: y = x;
    endcase
    
    //update ALU flags
    flag[0] = y == '0;  //zero flag
    flag[1] = y[width-1];  //negative flag: determined by the MSB

  end

endmodule
