`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2019 16:28:10
// Design Name: 
// Module Name: Data
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

module Data(
        
    input           CLK_I, RST_I,clk4,clk2,
    input           DAT_I,
    input           CYC_I, WE_I, STB_I, 
    output          ACK_O,
    input           start,
    input           QAM,
    input           QPSK,
    output reg [3:0]    DAT_O,
    output reg            CYC_O, STB_O,
    output                WE_O,
    input                    ACK_I,  
    output reg checkflag  
            );
      
        
//reg [3:0]    op_dat;
reg            ival;    
reg     idat;
wire             out_halt, en_qam,en_qpsk;
wire en_qam_qpsk;
wire p_qpsk;
wire [1:0] p_qam,p_qam1;
reg [9:0] ii,iii,pc; 
reg[2:0] lop_cnt  ;
reg[2:0] lop_cnt1  ;
reg check_flag=0;
reg check_flag1;
reg [10:0] q;
reg [10:0]p;
reg [3:0] op_dat_prev=4'b0;
reg [3:0] op_dat_prev1=4'b0;
reg [1:0] op_dat_qpsk;
reg [3:0] op_dat_next=4'b0;
reg [3:0] op_dat_next1=4'b0;
reg [1:0] op_dat_qpsk_op;
//wire p, clk2;
reg even, even2, even_q;
reg odd,odd2,odd_q;
wire clkqpsk;
 //reg check_flag;
wire[3:0] dat_in_tx; 
//reg [3:0] dat_op;


assign     out_halt = STB_O & (~ACK_I);
assign     en_qam_qpsk         = CYC_I & STB_I & WE_I;
assign     ACK_O 	= en_qam_qpsk & (~out_halt);

 always @(posedge CLK_I)
      begin
           if(RST_I == 1)
               q <= 0;
          else if (ACK_O) begin               // Changed 26/08/19
              //else 
               q <= q + 1;
               
          end
     end
      
      always @(posedge clk2)
            begin
                 if(RST_I == 1)
                     p <= 0;
                else if (ACK_O) begin               // Changed 26/08/19
                    //else 
                     p <= p + 1;
                     
                end
            end
     // assign  clk2=q[0];
      
     
  always @(posedge CLK_I) begin
         if((q[0]==1'b0) & q[1]==1'b0 & ACK_O)
         even<=1;
         else 
         even<=0;
         end  
  always @(posedge CLK_I) begin
         if((p[0]==1'b0) & ACK_O)
          even_q<=1;
         else 
         even_q<=0;
         end          
                                     
   always @(posedge CLK_I) begin              
         if ((q[0]==1'b1) & q[1]==1'b0 & ACK_O)
         odd<=1;
         else
         odd<=0;
         end    
   always @(posedge CLK_I) begin
          if((p[0]==1'b1) & ACK_O)
          odd_q<=1;
          else 
          odd_q<=0;
          end            
         
  always @(posedge CLK_I) begin
                                                      
          if((q[0]==1'b0) & q[1]==1'b1 & ACK_O)
          even2<=1;
          else 
          even2<=0;
          end  
         
  always @(posedge CLK_I) begin
                                                      
          if((q[0]==1'b1) & q[1]==1'b1 & ACK_O)
          odd2<=1;
          else 
          odd2<=0;
          end
          
 always @(posedge CLK_I) begin
     if(RST_I)             idat<= 0;
     else if(ACK_O)     idat <= DAT_I;   // Changed by Neelam
          end
          
  always @(posedge CLK_I) begin
      if(RST_I)             ival <= 1'b0;
      else if( en_qam_qpsk)        ival <= 1'b1;
      else                    ival <= 1'b0;
          end         
                              
 always @(posedge CLK_I) begin ///(@cl05
 if(RST_I) begin            
 check_flag <= 1'b0;
 op_dat_prev<=4'b0;
 end
  if ((QAM) & (even)) begin 
  op_dat_prev[0] <= idat;
  check_flag<=1'b0;
  end                 
  else if ((QAM) & (odd)) begin  
  op_dat_prev[1] <=  idat; 
  check_flag<=1'b0; 
  end
  else if ((QAM) & (even2)) begin  
  op_dat_prev[2] <=  idat; 
  check_flag<=1'b0; 
   end              
  else if ((QAM) & (odd2)) begin  
  op_dat_prev[3] <=  idat; 
  check_flag<=1'b1; 
  end
  else 
  check_flag<=1'b0; 
     end 
   
 
 always @(posedge CLK_I) begin ///(@cl05
 if ((QPSK) & (even_q)) begin 
  op_dat_prev1[0] <= idat;
  check_flag1<=1'b0;
  end                 
  else if ((QPSK) & (odd_q)) begin  
  op_dat_prev1[1] <=  idat; 
  check_flag1<=1'b1; 
  end
    end        
  always @(posedge CLK_I) begin
  if  (check_flag )
  op_dat_next[3:0] <= op_dat_prev[3:0];
  end
   
 always @(posedge CLK_I) begin
    if  (check_flag1 )
 op_dat_next1[3:0] <= op_dat_prev1[3:0];
 end  

 always @(posedge CLK_I)
   begin
  if(RST_I)    begin
      STB_O <= 1'b0;
      DAT_O <= 4'b0;
     // CYC_O <= 1'b0;
      end
  else if(ival & (~out_halt) & QAM) begin  // changed 
     DAT_O <= op_dat_next; 
     STB_O <= 1'b1;
     end
  else if(ival & (~out_halt) & QPSK) begin                            ///changed 
          DAT_O <= op_dat_next1; 
          STB_O <= 1'b1;
          end
 else if(~ival) begin    
  STB_O <= 1'b0;
    end
    end
 
  reg icyc;
  always @(posedge CLK_I)
  begin
      if(RST_I)        icyc <= 1'b0;        
      else                icyc <= CYC_I;    
  end
  always @(posedge CLK_I)
  begin
      if(RST_I)        CYC_O    <= icyc;            
      else                 CYC_O    <= icyc;
  end
  
  assign WE_O = STB_O;
             // assign DAT_O = op_dat_next; 
     //
     
   endmodule
      