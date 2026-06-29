//testbench for 2:1 mux
//assertion
module mux2to1_tb;

//testbench signals
logic in0;
logic in1;
logic sel;
logic out;

//match ports
mux2to1 dut(.*);

//immediate assertion
always_comb
  begin
    assert(out==(sel?in1:in0));
    else
      $error(''output is not correct'');
  end

//test stimulus
//without stimulus, assertion is nothing to check
initial
  begin
    in0 = 0;
    in1 = 0;
    sel = 0;

    #10ns
    in0 = 0;
    in1 = 1;
    sel = 1;

    #10ns
    in0 = 1;
    in1 = 0;
    sel = 0;
 
    #10ns
    in0 = 1;
    in1 = 0;
    sel = 1;

    $finish;

  end
endmodule
