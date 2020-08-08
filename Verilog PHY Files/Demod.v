`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:23 03/29/2012 
// Design Name: 
// Module Name:    DataSymDem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DataSymDem16(
	input 			CLK_I, RST_I,
	input [31:0] 	DAT_I,
	input 			WE_I, STB_I, CYC_I,
	input QAM, QPSK,
	output			ACK_O,
	
	output reg [3:0]	DAT_O,
	output reg [1:0] DAT_OQ,
	output reg			CYC_O, STB_O,
	output reg [31:0] Pil_rec,
    output  [31:0] Pil_value,
	output              RT_PW,
	output				WE_O,
	input				ACK_I	
    );
	 
wire out_halt = STB_O & (~ACK_I);
wire ena = (CYC_I) & STB_I & WE_I;
wire			datout_ack;
reg dat_sym_ena;
wire [15:0] Pil_Re=DAT_I[15:0];
assign 	datout_ack = STB_O & ACK_I;
assign ACK_O = ena &(~out_halt);//ena &(~out_halt) & dat_sym_ena ; 

reg		 CYC_I_pp;
always @(posedge CLK_I or negedge RST_I)
begin
	if (RST_I) 	CYC_I_pp <= 1'b0;
	else 			CYC_I_pp <= CYC_I;
end


wire [15:0] QPSK_Im = DAT_I[31:16];
wire [15:0] QPSK_Re = DAT_I[15:0];
reg [3:0] bits_dem;
reg 		 bits_dem_val;
always @(posedge CLK_I)
begin
	if(RST_I) begin 
		bits_dem 		<= 2'b0;
		bits_dem_val 	<= 1'b0;
		end
	else if (~out_halt)	begin			
		if(ena) begin
			bits_dem[3] 	<= (QPSK_Im[11])?1'b1:1'b0;
			bits_dem[2] 	<= ~QPSK_Im[15];
			
			bits_dem[1] 	<= (QPSK_Re[11])?1'b1:1'b0;
			bits_dem[0] 	<= ~QPSK_Re[15];
			
			bits_dem_val	<= 1'b1;
			end
		else	bits_dem_val 		<= 1'b0;	
		end
end


always @(posedge CLK_I)
begin
	if(RST_I)	begin
		STB_O <= 1'b0;
		DAT_O <= 8'b0;
		end
	else if(~out_halt) begin	
		DAT_O <= {4'd0, bits_dem};	
		STB_O <= bits_dem_val;
		end	
end

always @(posedge CLK_I)
begin
	if(RST_I)								CYC_O	<= 1'b0;		
	else if ((CYC_I) & bits_dem_val)	CYC_O	<= 1'b1;
	else if ((~CYC_I) & (~STB_O)) 	CYC_O	<= 1'b0;
end

assign WE_O = STB_O;

reg [6:0] dat_cnt;  
    always@(posedge CLK_I)
    begin
        if(RST_I)                                        dat_cnt    <= 6'd0;        
        else if((ACK_O) && (dat_cnt !=104))              dat_cnt    <= dat_cnt + 1'b1;
    end
    
        reg val_pil;
        reg[15:0] Pil_P0,Pil_P1,Pil_P2,Pil_P3;  
        always @(posedge CLK_I) begin
            if(RST_I)   begin
              Pil_P0=16'b0;
              Pil_P1=16'b0;
              Pil_P2=16'b0;
              Pil_P3=16'b0; 
                 end                         
           else if ((dat_cnt==6'd6) && (~out_halt))
               Pil_P0=Pil_Re;
           else if ((dat_cnt==6'd20)&& (~out_halt))
               Pil_P1=Pil_Re;
           else if ((dat_cnt==6'd31)&& (~out_halt))
               Pil_P2=Pil_Re;
           else if ((dat_cnt==6'd45)&&(~out_halt))
               Pil_P3=Pil_Re;                  
          end
          
         always @(posedge CLK_I) begin
            if(RST_I)   
              Pil_rec = 0;  
            else if(Pil_P0==32'd4091| Pil_P0==32'd4093 | Pil_P0==32'd4090 | Pil_P0==32'd4092 | Pil_P0==32'd4095)    /// /// 0.9 Multiplications
            Pil_rec = 1;
            else if(Pil_P0==32'd529| Pil_P0==32'd528 | Pil_P0==32'd530)    /// 0.6 Multiplications
            Pil_rec=2;
            else if(Pil_P0==32'd193| Pil_P0==32'd194 | Pil_P0==32'd195)    /// 0.5 Multiplications
            Pil_rec=3;
            end
         
         reg rt_pw;  
    always @(posedge CLK_I) begin
                if(RST_I)   
                rt_pw = 0;
               else if (Pil_rec==1 |  Pil_rec==2 |Pil_rec==3)
                rt_pw=1;
               else if (Pil_rec==0)
                 rt_pw=0;
               else 
                rt_pw=0; 
                end
             
     assign RT_PW= rt_pw; 
    // wire [15:0]Pil_wire =Pil_P0[15:0];   
     assign  Pil_value={16'd0,Pil_P0};
                        
    endmodule

