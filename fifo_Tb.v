module tb;
  //Declare all inputs with reg type and output with wire 
  reg clk = 0;
  reg wr = 0;
  reg rd = 0;
  reg rst = 0;
  reg [7:0] din = 0;
  wire [7:0] dout;
  wire empty, full;
  
  FIFO dut (clk,rst,wr,rd,din,dout,empty,full); //Module instatiation!!
  
  always #5 clk = ~clk;   //Clk generation!!
  
  
  
  covergroup c @(posedge clk);
   
  option.per_instance = 1;
  //Allows us to analyze details of values we are getting for the FIFO  
  
    coverpoint empty {
      bins empty_l = {0};     //Empty flag =0 means there is data inside FIFO
     bins empty_h = {1};
    }   
   
      coverpoint full {
        bins full_l = {0};   //Full
        bins full_h = {1};
   }
  
     coverpoint rst {
       bins rst_l = {0};   //reset
       bins rst_h = {1};
   }
  
      coverpoint wr {
        bins wr_l = {0};     //write 
     bins wr_h = {1};
   }
  
  
     coverpoint rd {
     bins rd_l = {0};
       bins rd_h = {1};    //read 
   }
  
    coverpoint din
    {    //din is declared as 8 bit so we see if diff range values gets hit atleast once
     bins lower = {[0:84]};
     bins mid = {[85:169]};
     bins high = {[170:255]};
   }
   
     coverpoint dout
   {
     bins lower = {[0:84]};
     bins mid = {[85:169]};
     bins high = {[170:255]};
   }
  
  cross_Wr_din: cross wr,din 
   {
     ignore_bins unused_wr = binsof(wr) intersect {0};
   }
    //When wr =0 no need to consider hence we must neglect this condition!
    //din verified during writing operation hence cross these two!!
  
   cross_rd_dout: cross rd,dout
   {
     ignore_bins unused_rd = binsof(rd) intersect {0};
   }
    // here rd{0} must be neglected because in read operation rd must only be 1 so no need to consider coverage report when rd = 0
  //dout verified during reading operation hence cross these two!!
 endgroup
  
  c ci;   //instance of a covergroup is created here
  integer i = 0;
  
  task write();
    for(i = 0; i < 20; i++) begin
    @(posedge clk);   
    wr = 1'b1;   //in write operation wr = high and rd = low
    rd = 1'b0;
      din = $urandom();  //gets random values 0 to 256 for 20 times
      $info("value of din: %0d",din);
   end  
  endtask
  
    task read();
      for(i = 0; i < 20; i++) begin
    @(posedge clk);   
    wr = 1'b0;   //in read operation rd = 1 and  wr = 0!
    rd = 1'b1;
    din = 0;
        $info("value of dout: %0d",dout);
   end  
  endtask

  
  initial begin
  rst = 1'b1;
  #50;
  rst = 0;
    
  wr = 0;
  rd = 0;
  #20;
    write(); 
   #30;
    read(); 
   #30; 
  end
  
  
  
  initial begin
    ci = new();   
    $dumpfile("dump.vcd");
    $dumpvars;
    #600;
    $finish();
  end

endmodule
