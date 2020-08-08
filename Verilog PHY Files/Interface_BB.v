module Interface_BB(
   input 			CLK_I, RST_I,
	input [31:0] 	DAT_I,					// DAT_I_Im[31:16] DAT_I_Re[15:0] in format 5.11
	input 			WE_I, STB_I, CYC_I,
	output			ACK_O,
	
	output  [31:0]	DAT_O,				// DAT_O_Im[31:16] DAT_O_Re[15:0] in format 5.11
	output	 		CYC_O, STB_O,
	output 			WE_O,
	input				ACK_I	
    );

//wire 			istart, out_halt, datin_val;
//reg 	CYC_I_pp;
//reg [31:0]  idat;
//reg 			iena;

//assign 		datin_val = (CYC_I) & STB_I & (WE_I);
//assign 		out_halt  =  STB_O  & (~ACK_I);
//assign 		ACK_O     =  datin_val & (~out_halt);
//assign		istart	 =  CYC_I  & (~CYC_I_pp);

//always @(posedge CLK_I) begin
//	if(RST_I)	CYC_I_pp <= 1'b1;
//	else  		CYC_I_pp <= CYC_I;
//end
//always @(posedge CLK_I) begin
//	if(RST_I) 				idat <= 32'd0;
//	else if (ACK_O) 		idat <= DAT_I;
//end
//always @(posedge CLK_I) begin
//	if(RST_I)  				iena <= 1'b0;
//	else if (ACK_O)		iena <= 1'b1;
//	else 						iena <= 1'b0;
//end



assign DAT_O = DAT_I;
assign WE_O  = WE_I;
assign STB_O = STB_I;
assign CYC_O = CYC_I;
assign ACK_O = ACK_I;
endmodule
