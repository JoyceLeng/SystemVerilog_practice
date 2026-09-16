//synchronous FIFO
//same as previous version

module S_fifo #(parameter depth = 4, width = 8)
(//inputs
 input logic clk, rst_n,
 input logic wr_en, rd_en,
 input logic [width-1:0]din,
 //outputs
 output logic [width-1:0]dout,
 output logic empty, full  //flags
);
 
//create a memory with 4*8 metrix
logic [width-1:0]mem[0:depth-1];
//write pointer
logic [$clog2(depth)-1:0]wr_p;
//read pointer
logic [$clog2(depth)-1:0]rd_p;
//create a counter to update the flags
logic [$clog2(depth+1)-1:0]counter;

assign empty = (counter == 0);
assign full = (counter == depth);

always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n) begin
      dout <= '0;
      counter <= '0;
      //clear pointers
      wr_p <= '0;
      rd_p <= '0;
    end
    else begin
      if(wr_en && !full) begin
        mem[wr_p] <= din;
        wr_p <= wr_p + 1;
      end
      if(rd_en && !empty) begin
        dout <= mem[rd_p];
        rd_p <= rd_p + 1;
      end
      //update the flags
      if((wr_en && !full) && !(rd_en && !empty))
        counter <= counter + 1;
      else if(!(wr_en && !full) && (rd_en && !empty))
        counter <= counter - 1;
      else
        counter <= counter;
    end
  end

endmodule
