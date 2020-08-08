module Top (  
    input 	wire cl05,//
   // input wire cl05_n,
    //input wire CLK_I, 
    input wire RST_Ii,
    input highSNR,
    input lowSNR,
	//input wire [3:0] DAT_I,
	input wire start1,//CYC_I, WE_I, STB_I, //ACK_I,
//	output	wire		ACK_O,
	output wire [3:0]	DAT_O,
	//output wire [6:0] datout_cnt1,
	output	wire	STB_O,CYC_O,BITS_O,//CYC_O, STB_O,
	//output wire out_indication,
	//output wire countWire//,rst,
	output	wire	WE_O,
	output wire [1:0]  DITS_O,
	output wire [9:0] funcE,
	output wire [9:0] correctbits,
	output wire RT_PW,
    input [15:0] channel_mult_value,
    input  [31:0] channel_mult,
    output wire [31:0] PilotRec_N,
    output wire [31:0] Pil_value

	//output wire Check_Error
	//output wire [3:0] DAT_O1		
	//output wire compare	
    );


wire RST_I;
extend_rst R1 (
.clk(cl05),
.clk_data(RST_Ii),
.clk_data_reg(RST_I)

);
wire clk2;
//wire cl05;
//clk_sys sys
//   (
//   .cl05(cl05),     // output cl05
//   .reset(RST_I),
//   .clk_in1(clk)); 
wire clk4;
clk_2 div2
   (
   .clk2(clk2),     // output cl05
   //.reset(RST_I),
   .clk_in1(cl05)); 
   
  clkdiv c1
   (
      .clk4(clk4),     // output clk4
     // .clk2(clk2),
      //.reset(RST_I),
      .clk_in1(cl05)    // input clk_in1_p
    );    // input clk_in1_n  
reg highSNR1;
reg lowSNR1;
reg st_c;
 reg [5:0] counter;
  reg [4:0] counter1;
  reg cnt;

always @ (posedge clk4)
begin
if (RST_I)
st_c<=0;
else 
st_c <=1;
end

reg start2;
reg [10:0] q;


//wire RST_I;
reg clk_enable;
wire start_out;  
extend_start strt(
    .clk(clk4),
    .start_data(st_c),
    .start_data_reg(start_out)
    );
 




wire clk_op;
assign clk_op=(highSNR1)?cl05:clk2;			  


always @(posedge clk4) begin
	if(RST_I) 		               highSNR1 <= 0;               
	else if (highSNR==1) highSNR1 <= 1;	
	else highSNR1<=0;
end
reg start;
always @(posedge clk4) begin
	if(RST_I) 		               start <= 0;               
	else if (start_out==1) start <= 1;	
	else start<=0;
end

//wire clk4;
always @(posedge clk4) begin
	if(RST_I) 		               lowSNR1 <= 0;               
	else if (lowSNR==1) lowSNR1 <= 1;	
	else lowSNR1<=0;
end

//reg start;
//always @(posedge cl05) begin
//	if(RST_I) 		               start <= 0;               
//	else if (start_out==1) start <= 1;	
//	else start<=0;
//end
always @(posedge cl05)
             begin
                  if(RST_I == 1)
                      q <= 0;
                  else  begin
                      q <= q + 1;
                      
                 end
             end
         //    assign  clk4=q[1];

  reg[1:0]  dat_in1;
  reg[1:0]  dat_inQ;
  reg[3:0] dat_in ;
  
  wire [3:0] DAT_data_gen;
  wire [1:0] Dat_Data_q; 
  reg cyc_i, we_i, stb_i;// ACK_I;
  reg cyc_i1, we_i1, stb_i1;
  wire ack_oo,ack_o,cyc_o;
  wire [31:0]    OFDM_DAT_O;
  wire ACK_OG;
  wire check_flag; 
  
reg         wr_frm,wr_frm_pp,wr_datin; 
reg         wr_frm1,wr_frm_pp1,wr_datin1; 

reg datin [383:0];
//reg [1:0] dat_in1;  reg 		 Pil 	 [0:127]; 
//(* KEEP = "TRUE" *) reg [0:383] datin=386'b101011101000011000111110000000101010110011001100110011101000011101000011101000010111000011111000110011101000011101000010111101000011101000010110100001110100001011010111010000110001111100000001010101100110011001100111010000111010000111010000101110000111110011101000011101000010111000011111001110100001110100001011100001111100111010000111010000101110000111110011101000011101000010111001;
initial 
$readmemh("E:/neelam/Text_File/RTL_OFDM_TX_bit_symbols.txt", datin);
//D:/Imp_PR/Integration/OFDM_DPR/QAM_DPR
 reg [9:0] ii,iii,syb_cnt; 
 reg[2:0] lop_cnt  ;
 reg[2:0] lop_cnt1  ;
  integer  Len,Len1, NLOP,NLOP1, para_fin,temp,temp1;
  
    //reg check_flag;
    reg [3:0] dat_symb [95:0];


//reg [3:0] counter;
//reg st_c;
//always @(posedge cl05)
//             begin
//                  if(RST_I == 1) begin
//                      counter <= 0;
//                      st_c=1;
//                      end
//                  else if((start1) && (counter!=6)&& (st_c) )
//                     counter <= counter + 1;
//                  else if ((start1) && (counter==6))begin
//                  counter <=0;
//                  st_c=0; 
//                  end
//                  else 
//                  counter <=0;
//                 end


//reg start;
//always @(posedge cl05) begin
//if(RST_I) 		               start <= 0;     
//   else if ((counter != 10) & (start1) & st_c) begin
//   start <= 1;
//    end 
//   else 
//   start <= 0;
  
//end
   
wire stb_o_gen,we_o_gen,cyc_o_gen;

  Data gen(
  .CLK_I(clk_op), .RST_I(RST_I),.clk2(clk2),
  .DAT_I (dat_in1),
  .ACK_O(ACK_OG),
  .QAM(highSNR1),
  .start(start),
      //.QAM(1'b0),
  .QPSK(lowSNR1),
  .WE_I (we_i1), 
  .STB_I(stb_i1),
  .CYC_I(cyc_i1),
  .DAT_O(DAT_data_gen), 
  //.DAT_OQ(Dat_Data_q),
  .WE_O (we_o_gen),.STB_O(stb_o_gen),.CYC_O(cyc_o_gen),
  .ACK_I(ack_o),	//Input
  // .ACK_I(1'b1),	//Input
  .checkflag(check_flag)
        );
            
    always @(posedge clk_op) begin
    if(RST_I) begin
    wr_frm1 <= 1'b0;
	lop_cnt  = 2'b0;
	end
    else if(start)                   wr_frm1 <= 1'b1;
    else if ((iii == 9'd384)&(ACK_OG) && highSNR1)  wr_frm1 <= 1'b0;
    else if ((iii == 9'd192)&(ACK_OG) && lowSNR1)  wr_frm1 <= 1'b0;
    else                             wr_frm1 <= wr_frm1;
    end
                      
    always @(posedge clk_op) begin    
       if(RST_I)     begin
           iii <= 9'b0;    
           dat_in1      <= datin[iii];    
           wr_frm_pp1   <= 1'b0;
           cyc_i1       <= 1'b0;
           we_i1       <= 1'b0;
           stb_i1       <= 1'b0;
           end
       else if(wr_frm1) begin
           cyc_i1      <= 1'b1;     
           wr_frm_pp1 <= wr_frm1;
           
       if (~wr_frm_pp1) begin
           wr_frm_pp1 <= wr_frm1;
            iii         <= iii+1;    
            stb_i1        <= 1'b1;
            cyc_i1        <= 1'b1;    
            we_i1        <= 1'b1;    
            end
      else if ((iii == 9'd384)&(ACK_OG) && highSNR1 ) begin 
               we_i1        <= 1'b0;
               stb_i1        <= 1'b0;
               cyc_i1        <= 1'b0;    
              // wr_frm1    <= 1'b0;
               end
      else if ((iii == 9'd192)&(ACK_OG) && lowSNR1 ) begin 
               we_i1        <= 1'b0;
               stb_i1        <= 1'b0;
               cyc_i1        <= 1'b0;    
               end         
      else if (ACK_OG) begin
              
              dat_in1     <= datin[iii]; 
              iii         <= iii+1;    
              stb_i1       <= 1'b1;
              cyc_i1       <= 1'b1;
              we_i1        <= 1'b1;    
               end    
           end            
       else begin
           wr_frm_pp1 <= wr_frm1;
           we_i1        <= 1'b0;
           stb_i1        <= 1'b0;
           cyc_i1       <= 1'b0;
           end    
        end    
    always @(negedge CYC_O) begin
       lop_cnt = lop_cnt +1;
      end             
 
 wire stb_o_tx,we_o_tx,cyc_o_tx;
  wire ACK_O;
wire[3:0] dat_in_tx;  
wire ack_mult; 
OFDM_TX_802_11 UUT(
	.CLK_I(cl05),.CLK_Ii(clk4), .RST_I(RST_I),
	.DAT_I(DAT_data_gen),
	//.DAT_IQ(dat_inQ),
	.WE_I (we_o_gen), .STB_I(stb_o_gen),.CYC_I(cyc_o_gen),
	.ACK_O(ack_o),	
	.DAT_O(OFDM_DAT_O),
	//.start(start),
	.QAM(highSNR1),
	.Checkflag(check_flag),
	.QPSK(lowSNR1),
	.WE_O (we_o_tx), .STB_O(stb_o_tx),.CYC_O(cyc_o_tx),
	// .ACK_I(1'b1)
	.ACK_I(ack_mult)	//Input
    );
 /// Changed By Neelam
//   always @(posedge clk4) begin
//        if(RST_I)     begin                   
//        wr_frm <= 1'b0;
//        end     
//        else if(start)                   wr_frm <= 1'b1;
//        else if ((ii == 9'd96)&(ack_o))  wr_frm <= 1'b0;
//        else                             wr_frm <= wr_frm;
//    end
  
//    always @(posedge clk4) begin    
//    if(RST_I)     begin
//     ii <= 9'b0;  
//    dat_inQ<= Dat_Data_q;  
//    dat_in 	<= DAT_data_gen; 
//    wr_frm_pp   <= 1'b0;
//      end
//    else if(wr_frm) begin
//      wr_frm_pp <= wr_frm;
//      if (~wr_frm_pp) begin
//      wr_frm_pp <= wr_frm;
//      ii         <= ii+1;    
//      end
//      else if (ack_o) begin
//      dat_in 	<= DAT_data_gen;
//      dat_inQ <=Dat_Data_q;
//      ii         <= ii+1;    
//      end    
//      end            
//      else begin
//      wr_frm_pp <= wr_frm;
//      end    
    
//    end    
 /// Channel Multiplication
 
 ///// Channel Multiplication  		
				   
 reg [31:0] dat_in_mult;
 reg[10:0]mult_ii;
 reg cyc_mult,we_mult,stb_mult;
 wire we_o_mult, stb_o_mult,cyc_o_mult;
 wire [31:0] MULT_DAT_O;
 reg wr_frmmult;
 reg wr_frm_ppmult;
// wire [31:0] channel_mult=32'd00;
    Channel_mult Mult(
         .CLK_I(clk4), .RST_I(RST_I),
         .DAT_I(OFDM_DAT_O),
         .channel_mult(channel_mult),
         .ch(channel_mult_value),
         .WE_I (we_o_tx), .STB_I(stb_o_tx),.CYC_I(cyc_o_tx),
         .ACK_O(ack_mult),    
         .DAT_O(MULT_DAT_O),
         .WE_O (we_o_mult), .STB_O(stb_o_mult),.CYC_O(cyc_o_mult),
         .ACK_I(ACK_O)    //Input
         );                               
 reg         wr_frm_mult,wr_frm_pp_mult; 
 reg [11:0] ii_mult;
// always @(posedge clk4) begin
//  if(RST_I)     begin                   
//  wr_frm_mult <= 1'b0;
//  ii_mult=9'd0;    
//  dat_in_mult     <= OFDM_DAT_O;
//  end     
//  else if(start)                  wr_frm_mult <= 1'b1;
//  else if ((ii_mult == 9'd480)&(ack_mult)) wr_frm_mult <= 1'b0;
//  else                             wr_frm_mult <= wr_frm_mult;
//  end
  
//  always @(posedge clk4) begin    
//  if(RST_I)     begin
//   ii_mult <= 9'b0;    
//  dat_in_mult     <= OFDM_DAT_O; 
//  wr_frm_pp_mult   <= 1'b0;
//    end
//  else if(wr_frm_mult) begin
//   wr_frm_pp_mult <= wr_frm_mult;
//    if (~wr_frm_pp_mult) begin
//   wr_frm_pp_mult <= wr_frm_mult;
//    ii_mult         <= ii_mult+1;    
//    end
//    else if (ack_mult) begin
//    dat_in_mult    <= OFDM_DAT_O;
//    ii_mult         <= ii_mult+1;    
//    end    
//    end            
//    else begin
//    wr_frm_pp_mult <= wr_frm_mult;
//    end    
//  end
 
 
 
 wire   [7:0]     numRep;
 wire 	[3:0]     dat_out1;
 wire   [1:0]     dat_out;
 
 reg cyc_iRx,stb_iRx,we_iRx;
 
 wire cyc_iRx1,stb_iRx1,we_iRx1;
 wire [9:0]dat_cnt1;
 wire out_valid_demod;
 assign cyc_iRx1 = cyc_iRx;
 assign stb_iRx1 = stb_iRx;
 assign we_iRx1 = we_iRx;
 reg [3:0] out_compare;
 wire [31:0] pil_rec;
 

    OFDM_RX_802_11 UUT1(
                .CLK_I(clk4), .RST_I(RST_I),.clk_op(clk_op),.clk2(clk2),
                .Q_CH_I(MULT_DAT_O[31:16]),
                .I_CH_I(MULT_DAT_O[15:0]),
                .CYC_I(cyc_o_mult), 
                .STB_I(stb_o_mult),
                .ACK_O(ACK_O),
                .numRep(),
                .DAT_check(DAT_data_gen),
               	.PilotRec_N(PilotRec_N),
                .Pil_value(Pil_value),
                .RT_PW(RT_PW),
                .QAM(highSNR1),
                .QPSK(lowSNR1),
                .funcE(funcE),
                .correctbits(correctbits),
              //  .fnE(dat_in1),
                .dat_cnt1(dat_cnt1),
                .DAT_OQ(dat_out),
                .DITS_O(DITS_O),
                .BITS_O(BITS_O),
                
               // .out_valid(out_valid_demod),
                .WE_I(we_o_mult),
                .DAT_O(dat_out1),
                .WE_O(WE_O), 
                .STB_O(STB_O),
            //    .out_indication(out_indication),
                .CYC_O(CYC_O),
                .ACK_I({1'b1}),    
                .SNR({4'b1111})
                );   
                        
 
//reg         wr_frmRx,wr_frm_ppRx; 
//reg [8:0] ii_Rx;  
//    always @(posedge clk4) begin
//        if(RST_I)                        wr_frmRx <= 1'b0;
//        else if(start)                   wr_frmRx <= 1'b1;
//        else if ((dat_cnt1==10'd240)&(ACK_O))  wr_frmRx <= 1'b0;
//        else                             wr_frmRx <= wr_frmRx;
//    end
     	
//always @(posedge clk4) begin    
//if(RST_I)     begin
//    ii_Rx <= 0;    
//    wr_frm_ppRx     <= 1'b0;
//    end
//else begin

//    if(wr_frmRx) begin
//        wr_frm_ppRx <= wr_frmRx;
    
//     if (~wr_frm_ppRx) begin
//        wr_frm_ppRx <= wr_frmRx;
//        ii_Rx   <=ii_Rx+1;
//        end
     
//      else if (ACK_O)begin
//        ii_Rx   <=ii_Rx+1;
//        end                
//      end    
//    else begin
//     wr_frm_ppRx <= wr_frmRx;
       
//    end
    
// end
//end   
////assign result=OFDM_DAT_O;

reg [3:0] Final_Output;
reg [15:0] pilot_rec;
assign DAT_O=Final_Output;//{OFDM_DAT_O[31:30],OFDM_DAT_O[15:14]};////dat_out1[3:0];
 //assign DAT_O= dat_out1;
reg [6:0] datout_cnt;

reg [1:0] count;
always @(posedge clk4) begin
	if(RST_I) 		               datout_cnt <= 0;               
	//else if (datout_cnt == 7'd104) datout_cnt <= 0; ///neel ///
	else if ((STB_O) && (CYC_O) && (datout_cnt != 9'd104))   datout_cnt <= datout_cnt + 1;	
	
end

always @(posedge clk4) begin /// neel //////cyc_iRx1 instead of *
	if(RST_I) 		               Final_Output <= 0;
	
    //else if (datout_cnt == 7'd104) Final_Output <= Final_Output; ///neelam///
	else if((STB_O)&&(CYC_O))      Final_Output <= dat_out1[3:0];	
end
endmodule
  