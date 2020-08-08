`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2020 14:19:37
// Design Name: 
// Module Name: sy2bit
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
//////////////////////////////////////////////////////////////////////////////////



module sy2bit(
  input           CLK_I, RST_I,clk4,clk2,
  input[3:0]      DAT_I,
  input [1:0] DAT_IQ,
  input           CYC_I, WE_I, STB_I, 
  output          ACK_O,
//  input           start,
  input           QAM,
  input           QPSK,
 // input           pil_remove,
  output wire [9:0] funcE,
  output wire    BITS_O,
  output wire    DITS_O,
  output wire [3:0] DAT_O,
  output [9:0]correctbits,
  output reg            CYC_O, STB_O,
  output                WE_O,
  input                    ACK_I,  
  output reg checkflag  
   );
    
     
//reg [3:0]    op_dat;
reg            ival;    
reg [3:0]    idat;
reg [1:0]    idat1;
//wire             out_halt, en_qam,en_qpsk;
wire en_qam_qpsk;
wire p_qpsk;
wire [1:0] p_qam,p_qam1;
reg[2:0] lop_cnt  ;
reg[2:0] lop_cnt1  ;
reg check_flag;
reg check_flag1;
reg [10:0] q;
reg [10:0]p;
reg op_dat_prev=1'b0;
reg op_dat_prev1=1'b0;
reg [1:0] op_dat_qpsk;
reg op_dat_next=1'b0;
reg op_dat_next1=1'b0;
reg [1:0] op_dat_qpsk_op;
//wire p, clk2;
reg even, even2, even_q;
reg odd,odd2,odd_q;
wire clkqpsk;
//reg check_flag;
wire[3:0] dat_in_tx; 
reg dat_sym_ena;
wire out_halt = STB_O & (~ACK_I);
wire ena = (CYC_I) & STB_I & WE_I;
wire            datout_ack;
reg pil_removal_ena;
assign     datout_ack = STB_O & ACK_I;
//assign ACK_O = ena &(~out_halt) & dat_sym_ena & (~pil_removal_ena); 
assign ACK_O = (ena &(~out_halt)) ; 
wire ena_out= (ACK_O && (~pil_removal_ena));
wire ena_out1= (ACK_O & (~pil_removal_ena));
reg datin_v; 
reg datin_v1;
always @(posedge CLK_I)
  begin
       if(RST_I == 1)
           q <= 0;
      else if (ACK_O) begin               // Changed 26/08/19
          //else 
           q <= q + 1;
           
      end
  end
  
  always @(posedge CLK_I)
        begin
             if(RST_I == 1)
                 p <= 0;
            else if (ACK_O) begin               // Changed 26/08/19
                //else 
                 p <= p + 1;
                 
            end
        end

always @(posedge CLK_I) begin
if(RST_I)
even<=0;
else if((q[0]==1'b0) && q[1]==1'b0)
even<=1;
else 
even<=0;
end  
always @(posedge clk2) begin
if(RST_I)
even_q<=1'b0;
else if((p[0]==1'b0))
even_q<=1;
else 
even_q<=0;
end          
                                    
always @(posedge CLK_I) begin    
if(RST_I)
odd<=1'b0;          
else if ((q[0]==1'b1) && q[1]==1'b0)
odd<=1;
else
odd<=0;
end    

always @(posedge CLK_I ) begin
if(RST_I)
odd_q<=1'b0;
if((p[0]==1'b1))
odd_q<=1;
else 
odd_q<=0;
end            
        
always @(posedge CLK_I) begin
if(RST_I)
even2<=1'b0;                                                     
else if((q[0]==1'b0) && q[1]==1'b1)
even2<=1;
else 
even2<=0;
end  
        
always @(posedge CLK_I) begin
if(RST_I)
odd2<=1'b0;                                                     
else if((q[0]==1'b1) && q[1]==1'b1)
odd2<=1;
else 
odd2<=0;
end
        
reg [9:0]cnt_datin;        
always @(posedge CLK_I) begin
   if(RST_I) begin
   idat<= 0;
   idat1 <=0;
   datin_v <=1'b0;
   end
 // else if ((~out_halt) && (QAM))begin	
  else if (ena_out && (QAM))begin	
   if(ena) begin
   idat <= DAT_I[3:0];   // Changed by Neelam
   datin_v <=1'b1;
   end
   else datin_v <=1'b0;
   end
  else if (ena_out && (QPSK))begin
     if(ena) begin
      idat1 <=  DAT_I[1:0] ;   // Changed by Neelam
      datin_v <=1'b1;
   end
   else datin_v <=1'b0;
   end///
   end
//end  

reg [9:0]    dat_cnt;
reg [9:0]    dat_cnt1=0;
reg icyc;

always@(posedge clk4)
begin
	if(RST_I)										dat_cnt	<= 9'd0;	
	else if(CYC_I & (~icyc))	                    dat_cnt	<= 9'd0;
	else if(ACK_O & (datin_v) & (dat_cnt!=51))					                dat_cnt	<= dat_cnt + 1'b1;
	else if(ACK_O  & (dat_cnt==51))					                dat_cnt	<= 0;
end

always@(posedge clk4)
begin
	if(RST_I)										dat_cnt1	<= 9'd0;	
	else if(CYC_I & (~icyc))	                    dat_cnt1	<= 9'd0;
	else if(ACK_O & (datin_v) & (dat_cnt1!=104))    dat_cnt1	<= dat_cnt1 + 1'b1;
	else if(ACK_O  & (dat_cnt1==104))			    dat_cnt1	<= 0;
end
reg [3:0]dataoutb ;

always @(posedge CLK_I)
begin
    if(RST_I)        icyc <= 1'b0;        
    else                icyc <= CYC_I;    
end

always @(posedge CLK_I)
begin
	if(RST_I)								CYC_O	<= 1'b0;		
	else if ((CYC_I) & datin_v)	CYC_O	<= 1'b1;
	else if ((~CYC_I) & (~STB_O)) 	CYC_O	<= 1'b0;
end
always @(posedge CLK_I)
begin
    if(RST_I)                                        dat_sym_ena <= 1'b1;
    else if (CYC_I & (~icyc))                     dat_sym_ena <= 1'b1;    
    else if (CYC_O & (dat_cnt1 == 7'd104))    dat_sym_ena <= 1'b0;
    else if (~CYC_O)                                dat_sym_ena <= 1'b1;
end 
 

always@(posedge clk4) begin
     
pil_removal_ena  = 1'b0; 
case (dat_cnt)
6'd5, 6'd19, 6'd30, 6'd44:     pil_removal_ena  = 1'b1;
default: begin
pil_removal_ena  = 1'b0;
end
endcase
end



wire op_dat;
always @(posedge CLK_I) begin
  if(RST_I)             ival <= 1'b0;
  else if( ena)        ival <= 1'b1;
  else                    ival <= 1'b0;
      end         
                          
always @(posedge CLK_I) begin ///(@cl05
if(RST_I) begin
check_flag<=1'b1;
op_dat_prev<=1'b0;
end
else if  (ena_out) begin
  
if ((QAM) && (even) ) begin 
op_dat_prev <= idat[0];
check_flag<=1'b0;
end                 
else if ((QAM) && (odd)) begin  
op_dat_prev <=  idat[1]; 
check_flag<=1'b0; 
end
else if ((QAM) && (even2)) begin  
op_dat_prev <=  idat[2]; 
check_flag<=1'b0; 
end              
else if ((QAM) && (odd2)) begin  
op_dat_prev <=  idat[3]; 
check_flag<=1'b1; 
end 
 end 
end

assign op_dat= (QAM)? op_dat_prev:op_dat_prev1;
always @(posedge CLK_I) begin ///(@cl05
if(RST_I) begin
check_flag<=1'b1;
op_dat_prev1<=1'b0;
end
else if (ena_out) begin
if ((QPSK) && (even_q)) begin 
op_dat_prev1 <= idat1[0];
end                 
else if ((QPSK) && (odd_q)) begin  
op_dat_prev1 <=  idat1[1]; 
check_flag1<=1'b1; 
end
end  
end   

reg datostrt2;
reg datostrt;
reg datostrt1;   
always @(posedge CLK_I) begin
if(RST_I) begin
op_dat_next<=1'b0;
op_dat_next1<=1'b0;
//STB_O <=1'b0;
end
else if (ena_out && QAM) begin
  op_dat_next <= op_dat_prev;
 // STB_O <=1'b1;
  end
else if (ena_out && QPSK) begin
 op_dat_next1 <= op_dat_prev1;
// STB_O <=1'b1;
 end
 
end
reg [383:0]data_out;
reg[9:0] flag_val=0;
reg flagR=0;
reg  B_DAT;
reg  BITS_OO;
reg datostrt3;
reg datinsym [0:390];
reg datinsym1 [0:192];
initial 
$readmemh("E:/neelam/Text_File/RTL_OFDM_TX_bit_symbols1.txt", datinsym);
initial 
$readmemh("E:/neelam/Text_File/RTL_OFDM_TX_bit_symbols11.txt", datinsym1);

//(* KEEP = "TRUE" *) reg [3:0] 
//(* KEEP = "TRUE" *) reg datinsym [0:395] =384'b101011101000011000111110000000101010110011001100110011101000011101000011101000010111000011111000110011101000011101000010111101000011101000010110100001110100001011010111010000110001111100000001010101100110011001100111010000111010000111010000101110000111110011101000011101000010111000011111001110100001110100001011100001111100111010000111010000101110000111110011101000011101000010111001;
reg [9:0] ii;
reg[9:0] iii=0;
reg flagE=0;
reg [9:0] flagC;

always @(posedge CLK_I)
begin
if(RST_I)    begin
  BITS_OO <= 1'b0;
  flag_val <=9'd0;
  STB_O <= 1'b0;
   //ii <= 9'd0; 
  end
else if (ena_out && QAM ) begin                                      
                      ///changed 
     BITS_OO <= op_dat_next;
     STB_O <= datin_v;
     data_out[flag_val] <=BITS_OO;
     flag_val <=flag_val+1;
    end
  else if (ena_out && (QPSK)) begin                        ///changed 
      BITS_OO <= op_dat_next1;
      data_out[flag_val] <=BITS_OO;
      flag_val <=flag_val+1;
      STB_O <= datin_v;
   end
end



always @(posedge CLK_I) begin    
if(RST_I)     begin
 ii <= 9'd0;  
 iii <= 9'd0;  
 B_DAT<=0;  
 end  
 else if (ena_out && QAM && (ii != 384)) begin
 B_DAT     <= datinsym[ii]; 
 ii         <= ii+1;    
 end  
                  
else if (ena_out && QPSK && (iii != 192))begin
 B_DAT     <= datinsym1[iii]; 
 iii         <= iii+1;    
 end                       
end  

always @(posedge CLK_I)
begin
  if(RST_I) begin
  flagE <= 1'b0;                                    
  flagR<=1'b0;
  end
else if(ena_out) begin
   if ((BITS_O==DITS_O))begin
   flagE <= 1'b1;
   flagR <= 1'b0;
   end
 else if ((BITS_O!=DITS_O))begin
    flagE <= 1'b0;
    flagR <= 1'b1;
   end 
  end
else begin
   flagE <= 1'b0;                                    
  flagR<=1'b0;
 end
 end
assign  DITS_O=B_DAT;
assign  BITS_O=BITS_OO;

assign WE_O = STB_O;

reg wr_frm1;
reg [1:0] dat_in1;
reg wr_frm_pp1;

               
reg [9:0]functEE=0;

reg [9:0] Error=0;

always@(posedge CLK_I) begin
  if(RST_I) begin                                
  functEE <= 0;
  Error <= 0;
  end
 else if(flagR == 1'b1)
        Error = Error + 1;
  else if( flagE == 1'b1)
        functEE = functEE + 1;    
    end
//end
assign funcE= Error;

assign correctbits=functEE;

assign DAT_O= idat;

endmodule