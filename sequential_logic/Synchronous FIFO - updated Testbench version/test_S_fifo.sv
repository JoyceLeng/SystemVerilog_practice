////////////////////testbench for S_fifo///////////////////////////

module test_S_fifo #(parameter width = 8);

//inputs
logic clk, rst_n;
logic wr_en, rd_en;
logic [width-1:0]din;
//outputs
logic [width-1:0]dout;
logic empty, full;

//instantiantion
S_fifo #(.width(width)) dut(.*);

////////////////////////////////monitor////////////////////////////
initial begin
  $monitor("Time=%0t rst_n=%b wr_en=%b rd_en=%b din=%h dout=%h empty=%b full=%b",
           $time,
           rst_n,
           wr_en,
           rd_en,
           din,
           dout,
           empty,
           full);
end

//initial clk
initial begin
  clk = '0;
  repeat(80) #10ns clk = ~clk;
end

//initial reset
initial begin
  rst_n = '0;
  #5ns rst_n = '1;
end

/////////////////////////direct stimulus////////////////////////////
initial begin

  wr_en = '0;
  rd_en = '0;
  din = 8'b0;

  ////////////////////////test cases/////////////////////////

  ////////////////////////write only/////////////////////////
  @(posedge clk);
  wr_en <= '1;
  din <= 8'h02;
  @(posedge clk);
  din <= 8'h04;
  @(posedge clk);
  din <= 8'h06;
  @(posedge clk);
  din <= 8'h08; 
  //expect to see: counter=depth=4, full=1, din=[02,04,06,03]
  ///////////////////////stop writing////////////////////////
  @(posedge clk);
  wr_en <= '0;
  ////////////////////////read only//////////////////////////
  rd_en <= '1;
  @(posedge clk); //start reading
  @(posedge clk);
  @(posedge clk);
  @(posedge clk); 
  //expect to see: counter=0, empty=1, dout=[02,04,06,03]
  //////////////////////stop reading/////////////////////////
  @(posedge clk);
  rd_en <= '0;

  //////////////////////empty corner case///////////////////
  //now counter=0, empty=1
  //re-active read enable
  //////////////////////start reading///////////////////////
  @(posedge clk);
  rd_en = '1;
  //expect to see: read pointer should not change
  //expect to see: counter should not change

  //////////////////////stop reading////////////////////////
  @(posedge clk);
  rd_en = '0;

  /////////////////////full cornor case/////////////////////
  //now input stimulus
  @(posedge clk);
  wr_en <= '1;
  din <= 8'h01;
  @(posedge clk);
  din <= 8'h03;
  @(posedge clk);
  din <= 8'h05;
  @(posedge clk);
  din <= 8'h07;
  //now FIFO is full: counter=4, full=1, din=[01, 03, 05, 07]
  @(posedge clk);
  din <= 8'h09;
  //expect to see: FIFO will not write 09
  //expect to see: write pointer shoule not change
  //expect to see: counter should remain 4
  ///////////////////////stop writing/////////////////////////
  @(posedge clk); 
  wr_en <= '0;
  rd_en <= '1;
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  @(posedge clk); //dout=[01 03 05 07]
  @(posedge clk); //09 should be read
  
end

//////////////////create a reference model//////////////////////////
logic [width-1:0]expected_queue[$];
always @(posedge clk) begin
  if(wr_en && !full) begin
    expected_queue.push_back(din);
    $display("Reference model: %h", din);
  end

  if(rd_en && !empty) begin
    #1;   //DUT: dout<=mem[rd_p]
    if(expected_queue.size() == 0) begin
      $error("Error: reference model is empty");
    end
    else if(dout == expected_queue[0]) begin
      $display("MATCH: actual=%h, expected=%h",
               dout,
               expected_queue[0]);
      expected_queue.pop_front();
    end
    else begin
      $display("DISMATCH: actual=%h, expected=%h",
               dout,
               expected_queue[0]);
    end
  end
end
///////////////////////////////////////////////////////////////////

///////////////////create assertions///////////////////////////////
property rule_1;  //when FIFO is empty, rd_p should remain unchange
  @(posedge clk)
  empty |=> $stable(dut.rd_p);
endproperty

assert property (rule_1)
else
  $error("Read pointer changed while FIFO was empty");

property rule_2;  //when FIFO is full, wr_p unchange
  @(posedge clk)
  full |=> $stable(dut.wr_p);
endproperty

assert property (rule_2)
else
  $error("Write pointer changed while FIFO was full");

//assertion - two flags
property empty_rule;
  @(posedge clk)
  (dut.counter == 0) |-> empty;
endproperty

assert property (empty_rule)
else
  $error("empty flag is incorrect");

property full_rule;
  @(posedge clk)
  (dut.counter == (dut.depth)) |-> full;
endproperty

assert property (full_rule)
else
  $error("full flag is incorrect");
///////////////////////////////////////////////////////////////////

endmodule
