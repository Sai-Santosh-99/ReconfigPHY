`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:56:39 04/15/2013 
// Design Name: 
// Module Name:    OFDM_RX_802_16 
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
module OFDM_RX_802_11(
	input 			CLK_I, RST_I,clk2,clk_op,
	input [15:0] 	I_CH_I,
	input [15:0] 	Q_CH_I,
	input 			CYC_I, WE_I, STB_I,
	input [3:0]     DAT_check,
 	input           QAM,
    input           QPSK,
    output  DITS_O,
    
    output [31:0] PilotRec_N,
    
   // output out_valid,
	//input [3:0]    InputAddr, 
	output			ACK_O,
	output  [7:0]   numRep,
	input  [3:0]	SNR,
	output [9:0]    dat_cnt1,
	output  [3:0]	DAT_O,
    output  BITS_O,
	output [1:0] DAT_OQ,
	output			CYC_O, STB_O,
	output RT_PW,
	output wire [9:0]  correctbits,
	output			WE_O,
	output wire [9:0]funcE,
	output [31:0]Pil_value,
	input				ACK_I	
   );
	 
wire [31:0] Synch_DAT_O;
wire 			Synch_WE_O; 
wire			Synch_STB_O;
wire			Synch_CYC_O;
wire			Synch_ACK_I;	 
//wire [31:0] FRE_O;
//wire			FRE_O_val;
wire [15:0] imaginaryData,realData;

Synch  Synch_ins(
	.CLK_I(CLK_I), .RST_I(RST_I),
	.DAT_I({Q_CH_I,I_CH_I}),
	.STB_I(STB_I),
	.CYC_I(CYC_I),
	.ACK_O(ACK_O),	
	.dat_cnt1(dat_cnt1),
	.DAT_O(Synch_DAT_O),
	.WE_O (Synch_WE_O ), 
	.STB_O(Synch_STB_O),
	.CYC_O(Synch_CYC_O),
	.ACK_I(Synch_ACK_I)

//	.SNR(SNR),				//Signal to Noise Ratio
//	.FRE_O(FRE_O),
//	.FRE_O_val(FRE_O_val)
    );

//wire [31:0] FreComp_DAT_O;
//wire 			FreComp_WE_O; 
//wire			FreComp_STB_O;
//wire			FreComp_CYC_O;
//wire			FreComp_ACK_I;	 
//FreComp FreComp_ins(
//	.CLK_I(CLK_I), .RST_I(RST_I),
//	.DAT_I(Synch_DAT_O),
//	.WE_I (Synch_WE_O), 
//	.STB_I(Synch_STB_O),
//	.CYC_I(Synch_CYC_O),
//	.ACK_O(Synch_ACK_I),	
	
//	.DAT_O(FreComp_DAT_O),
//	.WE_O (FreComp_WE_O ), 
//	.STB_O(FreComp_STB_O),
//	.CYC_O(FreComp_CYC_O),
//	.ACK_I(FreComp_ACK_I),

//	.FRE_I(FRE_O),
//	.FRE_I_nd(FRE_O_val)
//    );


wire [31:0] RemoveCP_DAT_O;
wire 			RemoveCP_WE_O; 
wire			RemoveCP_STB_O;
wire			RemoveCP_CYC_O;
wire			RemoveCP_ACK_I;	 
RemoveCP RemoveCP_ins(
	.CLK_I(CLK_I), .RST_I(RST_I),
	.DAT_I(Synch_DAT_O),
    .WE_I (Synch_WE_O), 
    .STB_I(Synch_STB_O),
    .CYC_I(Synch_CYC_O),
    .ACK_O(Synch_ACK_I),    
	.DAT_O(RemoveCP_DAT_O),
	.WE_O (RemoveCP_WE_O ), 
	.STB_O(RemoveCP_STB_O),
	.CYC_O(RemoveCP_CYC_O),
	.ACK_I(RemoveCP_ACK_I)
    );
	 
	 
wire [31:0] FFT_Demod_DAT_O;
wire 			FFT_Demod_WE_O; 
wire			FFT_Demod_STB_O;
wire			FFT_Demod_CYC_O;
wire			FFT_Demod_ACK_I;	 
FFT 	FFT_Demod_ins(
	.CLK_I(CLK_I), .RST_I(RST_I),
	.DAT_I(RemoveCP_DAT_O),
	.WE_I (RemoveCP_WE_O), 
	.STB_I(RemoveCP_STB_O),
	.CYC_I(RemoveCP_CYC_O),
	.ACK_O(RemoveCP_ACK_I),	
	
	.DAT_O(FFT_Demod_DAT_O),
	.WE_O (FFT_Demod_WE_O ), 
	.STB_O(FFT_Demod_STB_O),
	.CYC_O(FFT_Demod_CYC_O),
	.ACK_I(FFT_Demod_ACK_I)
    );


wire [31:0] iCFO_EstComp_DAT_O;
wire 			iCFO_EstComp_WE_O; 
wire			iCFO_EstComp_STB_O;
wire			iCFO_EstComp_CYC_O;
wire			iCFO_EstComp_ACK_I;	 
//iCFO_EstComp 		iCFO_EstComp_ins(
Interface_BB		iCFO_EstComp_ins(
	.CLK_I(CLK_I), .RST_I(RST_I),
	.DAT_I(FFT_Demod_DAT_O),
	.WE_I (FFT_Demod_WE_O), 
	.STB_I(FFT_Demod_STB_O),
	.CYC_I(FFT_Demod_CYC_O),
	.ACK_O(FFT_Demod_ACK_I),	
	
	.DAT_O(iCFO_EstComp_DAT_O),
	.WE_O (iCFO_EstComp_WE_O ), 
	.STB_O(iCFO_EstComp_STB_O),
	.CYC_O(iCFO_EstComp_CYC_O),
	.ACK_I(iCFO_EstComp_ACK_I)
    );
	 
wire [31:0] Ch_EstEqu_DAT_O;
wire 			Ch_EstEqu_WE_O; 
wire			Ch_EstEqu_STB_O;
wire			Ch_EstEqu_CYC_O;
wire			Ch_EstEqu_ACK_I;		 
Ch_EstEqu 		Ch_EstEqu_ins(
	.CLK_I(CLK_I), .RST_I(RST_I),
	.DAT_I(iCFO_EstComp_DAT_O),
	.WE_I (iCFO_EstComp_WE_O), 
	.STB_I(iCFO_EstComp_STB_O),
	.CYC_I(iCFO_EstComp_CYC_O),
	.ACK_O(iCFO_EstComp_ACK_I),	
	
	.DAT_O(Ch_EstEqu_DAT_O),
	.WE_O (Ch_EstEqu_WE_O ), 
	.STB_O(Ch_EstEqu_STB_O),
	.CYC_O(Ch_EstEqu_CYC_O),
	.ACK_I(Ch_EstEqu_ACK_I)
    );

wire [31:0] PhaseTrack_DAT_O;
wire 			PhaseTrack_WE_O; 
wire			PhaseTrack_STB_O;
wire			PhaseTrack_CYC_O;
wire			PhaseTrack_ACK_I;		 
PhaseTrack 		PhaseTrack_ins(
	.CLK_I(CLK_I), .RST_I(RST_I),
	.DAT_I(Ch_EstEqu_DAT_O),
	.WE_I (Ch_EstEqu_WE_O), 
	.STB_I(Ch_EstEqu_STB_O),
	.CYC_I(Ch_EstEqu_CYC_O),
	.ACK_O(Ch_EstEqu_ACK_I),	
	
	.DAT_O(PhaseTrack_DAT_O),
	.WE_O (PhaseTrack_WE_O ), 
	.STB_O(PhaseTrack_STB_O),
	.CYC_O(PhaseTrack_CYC_O),
	.ACK_I(PhaseTrack_ACK_I),
	.ALLOC_VEC({{6{2'b11}}, 2'b01, {13{2'b11}}, 2'b01, {5{2'b11}}, {5{2'b11}}, 2'b10, {13{2'b11}}, 2'b01, {6{2'b11}}})
		
    );
wire out_valid;
wire [1:0] DAT_O_p;
wire [3:0] DataSymDem_DAT_O;
wire 			DataSymDem_WE_O; 
wire			DataSymDem_STB_O;
wire			DataSymDem_CYC_O;
wire			DataSymDem_ACK_I;		 
DataSymDem16 		DataSymDem_ins(

//DataSymDem 		DataSymDem_ins(
	.CLK_I(CLK_I), .RST_I(RST_I),
	.DAT_I(PhaseTrack_DAT_O),
	.WE_I (PhaseTrack_WE_O), 
	.STB_I(PhaseTrack_STB_O),
	.CYC_I(PhaseTrack_CYC_O),
	.ACK_O(PhaseTrack_ACK_I),
	
//	.DAT_I(iCFO_EstComp_DAT_O),
//	.WE_I (iCFO_EstComp_WE_O), 
//	.STB_I(iCFO_EstComp_STB_O),
//	.CYC_I(iCFO_EstComp_CYC_O),
//	.ACK_O(iCFO_EstComp_ACK_I),	
	.Pil_rec(PilotRec_N),
    .Pil_value(Pil_value),
	.QAM(QAM),
    .QPSK(QPSK),
    .DAT_OQ(DAT_O_p),
	.RT_PW(RT_PW),
	.DAT_O(DataSymDem_DAT_O),
	.WE_O (DataSymDem_WE_O ), 
	.STB_O(DataSymDem_STB_O),
	.CYC_O(DataSymDem_CYC_O),
	.ACK_I(DataSymDem_ACK_I)
    );


//wire [3:0] Pil_Remove_DAT_O;
//wire 			Pil_Remove_WE_O; 
//wire pil_remove;
//wire			Pil_Remove_STB_O;
//wire			Pil_Remove_CYC_O;
//wire			Pil_Remove_ACK_I;	
//wire          	Pil_Remove_ACK_O; 
//wire [1:0] DAT_O_p;

//Pilot_Remove  Pilot_Remove_ins(

//    .CLK_I(CLK_I), .RST_I(RST_I),
//	.DAT_I(DataSymDem_DAT_O),
//    .DAT_IQ(DAT_OQ),
//    .DAT_OQ(DAT_O_p),
//    .clk(clk_op),
//    .QAM(QAM),
//    .QPSK(QPSK),
//    .pil_remove(pil_remove),
//	.WE_I (DataSymDem_WE_O), 
//	.STB_I(DataSymDem_STB_O),
//	.CYC_I(DataSymDem_CYC_O),
//	.ACK_O(DataSymDem_ACK_I),
//	.DAT_O(Pil_Remove_DAT_O),
//    .WE_O (Pil_Remove_WE_O ), 
//    .STB_O(Pil_Remove_STB_O),
//    .CYC_O(Pil_Remove_CYC_O),
//    .ACK_I(Pil_Remove_ACK_I)
//        );




wire [3:0] syb_DAT_O;
wire sy2bit_DAT_O;
wire 			sy2bit_WE_O; 
wire			sy2bit_STB_O;
wire			sy2bit_CYC_O;
wire			sy2bit_ACK_I;	
wire          	sy2bit_ACK_O; 
//reg [7:0]funcE;
//wire [1:0] DAT_IQ;
sy2bit  sy2bit_ins(
    .CLK_I(clk_op), .RST_I(RST_I),
	.DAT_I(DataSymDem_DAT_O),
	.WE_I (DataSymDem_WE_O), 
	.STB_I(DataSymDem_STB_O),
	.CYC_I(DataSymDem_CYC_O),
	.ACK_O(DataSymDem_ACK_I),
	.BITS_O(sy2bit_DAT_O),
	.funcE(funcE),
	.DAT_IQ(DAT_O_p),
	.clk2(clk2),
	.clk4(CLK_I),
	.QAM(QAM),
	.QPSK(QPSK),
	.DITS_O(DITS_O),
	.correctbits(correctbits),
	.DAT_O(syb_DAT_O),
    .WE_O (sy2bit_WE_O ), 
    .STB_O(sy2bit_STB_O),
    .CYC_O(sy2bit_CYC_O),
    .ACK_I(sy2bit_ACK_I)
        );
		
//        assign DataSymDem_ACK_I  = ACK_I;
//        assign DAT_O            = DataSymDem_DAT_O;//{Synch_DAT_O[29:27],Synch_DAT_O[31],Synch_WE_O,Synch_STB_O,Synch_CYC_O};//
//        assign WE_O             = DataSymDem_WE_O;
//        assign STB_O            = DataSymDem_STB_O;
//        assign CYC_O            = DataSymDem_CYC_O;
 assign BITS_O=sy2bit_DAT_O;       
assign sy2bit_ACK_I  = ACK_I;
assign DAT_O			= syb_DAT_O;//{Synch_DAT_O[29:27],Synch_DAT_O[31],Synch_WE_O,Synch_STB_O,Synch_CYC_O};//
assign WE_O				= sy2bit_WE_O;
assign STB_O			= sy2bit_STB_O;
assign CYC_O			= sy2bit_CYC_O;
//assign out_valid=out_valid;

endmodule
