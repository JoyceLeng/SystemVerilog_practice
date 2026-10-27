////////////////////////////////////////////////
//Testbench for picoMIPS
////////////////////////////////////////////////
module picoMIPS_tb #(parameter width = 8);

//inputs
logic clk;
logic rst_n;
//outputs
logic signed [width-1:0]y;

//expected outputs
logic signed [width-1:0]expected_y;

//instantiation
picoMIPS dut(.clk(clk),
	     .rst_n(rst_n),
	     .y(y));

//clock initial
initial begin
  clk = '0;
  repeat(50) #10 clk=~clk;
end

//reset initial and direct stimulus
initial begin
  rst_n = '0;
  @(negedge clk);

  //release reset
  rst_n = '1;

  //initial  8-bit input samples
  dut.dataMemory.Data_M[0] = 8'sd2;
  dut.dataMemory.Data_M[1] = 8'sd4;
  dut.dataMemory.Data_M[2] = 8'sd6;
  dut.dataMemory.Data_M[3] = 8'sd8;

  //initial  8-bit filter coefficients
  dut.dataMemory.Data_M[4] = 8'sd1;
  dut.dataMemory.Data_M[5] = 8'sd2;
  dut.dataMemory.Data_M[6] = 8'sd1;
  dut.dataMemory.Data_M[7] = 8'sd1;

end

//reference model & scoreboard
//PCaddress stops at last instructions
initial begin
  expected_y = '0;

  wait (dut.PCaddress == 6'd15); 
  $display("PCaddress reached 15 at time %0t", $time);

  wait (dut.w_en == 1'b1);
  $display("w_en becomes 1 at time %0t", $time);

  assign expected_y = 8'sd2*8'sd1 + 8'sd4*8'sd2
		    + 8'sd6*8'sd1 + 8'sd8*8'sd1;

  @(posedge clk);  //result shows at next clock cycle
  @(posedge clk);

  if (y === expected_y)
    $display("Pass, y=%0d, expected_y=%0d", y, expected_y);
  else
    $error("Fail, expected %0d, got %0d", expected_y, y);

  $stop;
end

endmodule
