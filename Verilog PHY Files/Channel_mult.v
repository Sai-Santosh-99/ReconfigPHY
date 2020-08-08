`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.12.2019 13:51:53
// Design Name: 
// Module Name: Channel_mult
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
`define Ch0 16'h7FFF    // 0.9 multiplication
`define Ch1 16'h6666    // 0.8 multiplication
`define Ch2 16'h599A   // 0.7 multiplication
`define Ch3 16'h4CCD   // 0.6 multiplication
//`define Ch4 16'h2666  // 0.3 multiplication
`define Ch4 16'h199A  // 0.2 multiplication
											  
module Channel_mult(

    input 			CLK_I, RST_I,
	input [31:0] 	DAT_I,
	input [15:0] ch,
	input [31:0] channel_mult,
	input 			CYC_I, 
	input			STB_I,
	input			WE_I,
	output			ACK_O,
	
	output  reg [31:0]	DAT_O,
	output reg			STB_O, CYC_O,
	output WE_O,
	input				ACK_I
   );
   
   
   //reg [31:0]  idat;
   reg [15:0] 	rx_Re, rx_Im;
   reg             iena;
   wire             istart, out_halt, datin_val;
   reg     CYC_I_pp;
   wire  Ch_CmxMul_ival;
   wire ch_CmxMul_oval;
  reg dat_sym_ena;
   assign         datin_val = (WE_I) & STB_I & CYC_I;
   assign         out_halt  =  STB_O  & (~ACK_I);
   assign         ACK_O     =  datin_val &(~out_halt) & dat_sym_ena;
   assign        istart     =  CYC_I  & (~CYC_I_pp);
   reg mult_valid;
   
   always @(posedge CLK_I) begin
       if(RST_I)    CYC_I_pp <= 1'b0;
       else          CYC_I_pp <= CYC_I;
   end

   always @(posedge CLK_I) begin
       if(RST_I) begin           
	    rx_Re <= 16'd0;
		rx_Im <= 16'd0; 
		mult_valid<=1'b0;		  
		end
       else if ( ACK_O )begin           
	        rx_Re <= DAT_I[15:0];
			rx_Im <= DAT_I[31:16];
			mult_valid<=1'b1;
      end
      else mult_valid<=1'b0;
	  end
	  
 always @(posedge CLK_I) begin
	if(RST_I)  				iena <= 1'b0;
	else if (ACK_O)		iena <= 1'b1;
	else 						iena <= 1'b0;
end 

reg [8:0] dat_cnt;
always@(posedge CLK_I) begin
	if (RST_I)	 		dat_cnt <=6'd0;
	else if (iena) 	dat_cnt <= dat_cnt + 1'b1;
	else if (istart)	dat_cnt <=6'd0;
end				  
reg [31:0] Ch_CmxMul_A;
reg [31:0] Ch_CmxMul_B;
reg [31:0] channel_mult_in;
//reg [31:0] channel_mult_factor;

always @(posedge CLK_I) begin
   if(RST_I)    channel_mult_in <= 32'd0;
   else if (iena)
    channel_mult_in <= channel_mult;
    end
    
 always @(posedge CLK_I) begin
   if(RST_I)                 Ch_CmxMul_A <= 32'd0;
   else if (iena)
   Ch_CmxMul_A <= {rx_Im, rx_Re};
   end          
           
           
always @(posedge CLK_I) begin
              if (iena) 
              Ch_CmxMul_B <= {16'b0,ch}; 
              end
wire [15:0] Mult_Re,Mult_Im;
wire [79:0] Mult_out;
wire  Mult_val;		   

Ch_CmxMul_mult Ch_CmxMul_ins(
	.aclk(CLK_I), // input aclk	
	.aresetn(~RST_I), // input aresetn
	.aclken(1'b1), // input aclken
	.s_axis_a_tvalid(iena), // input s_axis_a_tvalid
	.s_axis_a_tdata(Ch_CmxMul_A), // input [31 : 0] s_axis_a_tdata
	.s_axis_b_tvalid(iena), // input s_axis_b_tvalid
	.s_axis_b_tdata(Ch_CmxMul_B), // input [31 : 0] s_axis_b_tdata
	.m_axis_dout_tvalid(Mult_val), // ouput m_axis_dout_tvalid
	.m_axis_dout_tdata(Mult_out)); // 

assign Mult_Re = Mult_out[30:15];				// rounding output in format 1.15
assign Mult_Im = Mult_out[70:55];
reg [5:0] mult_delay; // because of multiplier latency.
always @(posedge CLK_I) begin
	if(RST_I) 							mult_delay <= 6'd0;
	else if (CYC_O)					mult_delay <= {mult_valid , mult_delay[5:1]};
end
wire 		mult_oval = mult_delay[0];


 always @(posedge CLK_I)
    begin
        if(RST_I)                                        dat_sym_ena <= 1'b1;
        else if (CYC_I & (~CYC_I_pp))                     dat_sym_ena <= 1'b1;    
        else if (CYC_O & (dat_cnt == 9'd480))    dat_sym_ena <= 1'b0;
        else if (~CYC_O)                                dat_sym_ena <= 1'b1;
    end 
    
    
    always @(posedge CLK_I)
    begin
        if(RST_I)                                CYC_O    <= 1'b0;        
        else if ((CYC_I) & (mult_valid))     CYC_O    <= 1'b1;
        else if ((~CYC_I) & (~STB_O))     CYC_O    <= 1'b0;
    end
// end
 assign WE_O = STB_O;
 
 
always @(posedge CLK_I) begin
	if(RST_I) 	begin
		DAT_O <= 32'd0;
		STB_O <= 1'b0;
		//CYC_O <= 1'b0;
		end
if(mult_oval & Mult_val) 	begin	
		STB_O <= 1'b1;
		//CYC_O <= 1'b1;
		if ((~out_halt))	DAT_O <=  {Mult_Im, Mult_Re};			// Q3.13 (Q10.6)
		end		
	else STB_O <= 1'b0;
end

//always @(posedge CLK_I) begin
//	if(RST_I) 	begin
//		DAT_O <= 32'd0;
//		STB_O <= 1'b0;
//		CYC_O <= 1'b0;
//		end
//	else if((Mult_val)) 	begin	
//                STB_O <= 1'b1;
//                DAT_O <= {Mult_Im, Mult_Re};   
//                CYC_O <= 1'b1;      
//                end  
//                end      

endmodule
