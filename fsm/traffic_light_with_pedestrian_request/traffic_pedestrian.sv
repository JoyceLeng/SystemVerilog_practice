//traffic system with pedestrian request
module traffic_pedestrian(
 input logic clk, rst_n,
 input logic pedestrian_button,
 output logic pedestrian_light,
 output logic [1:0]ns_light,
 output logic [1:0]ew_light
);

localparam GREEN = 2'b00;
localparam AMBER = 2'b01;
localparam RED = 2'b10;

localparam GREEN_TIME = 10;
localparam AMBER_TIME = 3;
localparam WALK_TIME = 10;
localparam ALL_RED_TIME = 3;

//set some timeout flags
logic GREEN_timeout;
logic AMBER_timeout;
logic WALK_timeout;
logic ALL_RED_timeout;

//set counters to update these flags
logic [$clog2(GREEN_TIME)-1:0]counter_GREEN;
logic [$clog2(AMBER_TIME)-1:0]counter_AMBER;  
logic [$clog2(WALK_TIME)-1:0]counter_WALK; 
logic [$clog2(ALL_RED_TIME)-1:0]counter_ALL_RED; 

logic pedestrian_request; //set a request register

//state declaration
typedef enum logic [2:0]{
          
      NS_GREEN,
      NS_AMBER,
      EW_GREEN,
      EW_AMBER,
      ALL_RED_BEFORE_PED,
      PED_WALK,
      ALL_RED_AFTER_PED

}state_t;

state_t previous_state;
state_t previous2_state;
state_t previous3_state;
state_t present_state;
state_t next_state;

//set the flags definition
//when traffic lights are green, green_timeout make a sence
assign GREEN_timeout = ((present_state == NS_GREEN)||(present_state == EW_GREEN))
                       &&(counter_GREEN == GREEN_TIME - 1);

assign AMBER_timeout = ((present_state == NS_AMBER)||(present_state == EW_AMBER))
                       &&(counter_AMBER == AMBER_TIME - 1);

assign WALK_timeout = (present_state == PED_WALK)&&(counter_WALK == WALK_TIME - 1);

assign ALL_RED_timeout = ((present_state == ALL_RED_BEFORE_PED)||(present_state == ALL_RED_AFTER_PED))
                         &&(counter_ALL_RED == ALL_RED_TIME - 1);

//state register
//asynchronous
always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n) begin
      previous_state <= NS_GREEN;
      previous2_state <= NS_GREEN;
      previous3_state <= NS_GREEN;
      present_state <= NS_GREEN;
    end
    else begin
      previous_state <= present_state;
      previous2_state <= previous_state;
      previous3_state <= previous2_state;
      present_state <= next_state;
    end
  end

//change counters to update the flags
always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n) begin
      counter_GREEN <= 0;
      counter_AMBER <= 0;
      counter_WALK <= 0;
      counter_ALL_RED <= 0;
    end
    else if(present_state != next_state) begin
      //when present_state is different from next_state, state changes
      //if state changes, counter will be cleaned
      counter_GREEN <= 0;
      counter_AMBER <= 0;
      counter_WALK <= 0;
      counter_ALL_RED <= 0;
    end
    else begin
      unique case(present_state)
        NS_GREEN, EW_GREEN:
          counter_GREEN <= counter_GREEN + 1;
        NS_AMBER, EW_AMBER:
          counter_AMBER <= counter_AMBER + 1;
        PED_WALK:
          counter_WALK <= counter_WALK + 1;
        ALL_RED_BEFORE_PED, ALL_RED_AFTER_PED:
          counter_ALL_RED <= counter_ALL_RED + 1;
      endcase
    end
  end

//pedestrian request
always_ff @(posedge clk, negedge rst_n)
  begin
    if(!rst_n)
      pedestrian_request <= 0;
    else begin
      if(pedestrian_button)
        pedestrian_request <= 1;
      else if(present_state == PED_WALK)
        pedestrian_request <= 0;
    end
  end

//outputs logic
always_comb
  begin
    //initial
    ns_light = '0;
    ew_light = '0;
    pedestrian_light = 0;
    //outputs logic
    unique case(present_state)
      NS_GREEN:
        begin
          ns_light = GREEN;
          ew_light = RED;
          pedestrian_light = 0;
        end
      NS_AMBER: 
        begin
          ns_light = AMBER;
          ew_light = RED;
          pedestrian_light = 0;
        end
      EW_GREEN:
        begin
          ns_light = RED;
          ew_light = GREEN;
          pedestrian_light = 0;
        end
      EW_AMBER:
        begin
          ns_light = RED;
          ew_light = AMBER;
          pedestrian_light = 0;
        end
      ALL_RED_BEFORE_PED:
        begin
          ns_light = RED;
          ew_light = RED;
          pedestrian_light = 0;
        end
      PED_WALK:
        begin
          ns_light = RED;
          ew_light = RED;
          pedestrian_light = 1;
        end
      ALL_RED_AFTER_PED:  //after pedestrian, ped_light should be off
        begin
          ns_light = RED;
          ew_light = RED;
          pedestrian_light = 0;
        end
    endcase
  end

//next state logic
always_comb
  begin
    //initial
    next_state = present_state;
    //next state logic
    unique case(present_state)
      NS_GREEN:
        begin
          if(GREEN_timeout)
            begin
              //when green light finish(timer is true), 'ped_light' works
              if(pedestrian_request)
                //when pedestrian_button is true, 'all_red' works
                next_state = ALL_RED_BEFORE_PED;
              else
                //continue traffic light flow if no pedestrian press button
                next_state = NS_AMBER;
            end 
          else
            //present state unchange until green light finish
            next_state = NS_GREEN;  
        end
      NS_AMBER: 
        begin
          //when traffic light becomes amber, no need to wait for light finish
          //if pedestrian press the button, will be 'all red'
          if(pedestrian_request)
            next_state = ALL_RED_BEFORE_PED;
          else begin
            if(AMBER_timeout)
              next_state = EW_GREEN;
            else
              next_state = NS_AMBER;
          end
        end
      EW_GREEN:
        begin
          if(GREEN_timeout)
            begin
              if(pedestrian_request)
                next_state = ALL_RED_BEFORE_PED;
              else
                next_state = EW_AMBER;
            end
          else
            next_state = EW_GREEN;
        end
      EW_AMBER:
        begin
          if(pedestrian_request)
            next_state = ALL_RED_BEFORE_PED;
          else begin
            if(AMBER_timeout)
              next_state = NS_GREEN;
            else
              next_state = EW_AMBER;
          end
        end
      ALL_RED_BEFORE_PED:
        begin
          if(ALL_RED_timeout)
            next_state = PED_WALK;
          else
            next_state = ALL_RED_BEFORE_PED;
        end
      PED_WALK:
        begin
          if(WALK_timeout)
            next_state = ALL_RED_AFTER_PED;
          else
            next_state = PED_WALK;
        end
      ALL_RED_AFTER_PED:
        begin
          if(ALL_RED_timeout)
            unique case(previous3_state)
              NS_GREEN: next_state = NS_AMBER;
              NS_AMBER: next_state = EW_GREEN;
              EW_GREEN: next_state = EW_AMBER;
              EW_AMBER: next_state = NS_GREEN;
              default: next_state = NS_GREEN;
            endcase
          else
            next_state = ALL_RED_AFTER_PED;
        end
      default: next_state = NS_GREEN;
    endcase
  end

endmodule
