module extend_start(
    input wire clk,
    input wire start_data,
    output wire start_data_reg
   
);
       
   (* KEEP = "TRUE" *) reg start_data_prev = 0;

    always@(posedge clk) begin
        start_data_prev <= start_data;
    end    
   
    (* KEEP = "TRUE" *) reg [5:0] start_data_count_reg=0;
    (* KEEP = "TRUE" *) reg [5:0] start_data_count_next=0;
    
    always@(posedge clk)
    begin
        start_data_count_reg = start_data_count_next;
    end
   
    always@(clk)
    begin
        start_data_count_next = start_data_count_reg;
        if(start_data_prev==0 && start_data ==1'b1 && start_data_count_reg<6)
            start_data_count_next = 6;
        else if(start_data_count_reg >=6)
             start_data_count_next = start_data_count_reg+1;  
    end

    assign start_data_reg = (start_data_count_reg>=6);
   
endmodule