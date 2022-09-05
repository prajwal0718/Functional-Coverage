
module FIFO(input clk, rst, wr, rd, 
            input [7:0] din,output reg [7:0] dout,
            output reg empty, full);
  //empty and full flags to know about status of memory
  
  reg [3:0] wptr = 0,rptr = 0,cnt = 0;
  reg [7:0] mem [15:0];  //Memory is created here 16 elements and each of 8 bit wide 
  //depth of 16
  //wptr helps during writing operation and rptr in reading operation and cnt will be used in both reading and writing operation
  
  always@(posedge clk)
    begin
      
      if(rst== 1'b1)  //when rst is high initalize all 3 ptrs to 0
         begin
           cnt <= 0;
           wptr <= 0;
           rptr <= 0;
         end
      
      else if(wr && !full)  //User wish to write new data into the FIFO
          begin
            if(cnt < 15) begin   //15 ultimately means full flag been set make sure FIFO is not FUll
             mem[wptr] <= din;    //Update memory with the data available!!
            wptr <= wptr + 1;  //incrememt the wptr and cnt 
            cnt <= cnt + 1;  //after writin into memory count value increases!!
            end
          end
      
      else if (rd && !empty)  //User wish to read from memory 
        begin
          if(cnt > 0) begin  //make sure FIFO is not empty 
          dout <= mem[rptr];
          rptr <= rptr + 1;
          cnt <= cnt - 1;  //Because reading menas we remove one element from memory then the cnt value reduces 
          end
        end 
      
      if(wptr == 15)   //Filled all elements in a FIFO so back to 0
         wptr <= 0;   
      if(rptr == 15)   //we read all data in FIFO then we cant read new data as empty flag will be set
         rptr <= 0;
    end
  
  assign empty = (cnt == 0) ? 1'b1 : 1'b0;
  assign full = (cnt == 15) ? 1'b1 : 1'b0;
  
endmodule
