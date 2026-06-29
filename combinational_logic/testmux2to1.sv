//testbench for 2:1 mux
//stimulus - direct test
module testmux2to1;

//inputs
logic in0;
logic in1;
logic sel;
//outpus
logic out;

//ports matching
mux2to1 a0(.*);

//inital main code
initial
  begin
    in0 = 0;
    in1 = 0;
    sel = 0;

    #10ns
    in0 = 0;
    in1 = 0;
    sel = 1;

    #10ns
    in0 = 0;
    in1 = 1;
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

    #10ns
    in0 = 1;
    in1 = 1;
    sel = 0;

    #10ns
    in0 = 1;
    in1 = 1;
    sel = 1;
    
  end

endmodule
