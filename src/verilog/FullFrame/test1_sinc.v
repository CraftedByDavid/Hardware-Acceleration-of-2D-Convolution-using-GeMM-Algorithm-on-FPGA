module test1_sinc(
    input clk,          
    input start,
    input kernel_read,  
    input reset, 
    input [15:0]addr_in, 
    output reg done=1'b0,
    output reg kernel_read_complete = 1'b0, 
    output [22:0] out
);
  //output [22:0] out
/*parmeters include kernal size(row or column considering square matrix), matrix size(row or column considering square matrix), number of sliding required along x direction and number of sliding required along y direction */
    parameter [7:0] Kernal_size = 8'd3; // Kernel size (3x3)
    parameter [7:0] Mat_Kernal_Xsize = 8'd224; // Matrix width (number of columns)
    parameter [7:0] Slide_horizontal_size = (Mat_Kernal_Xsize - Kernal_size) + 1; // Number of horizontal slidings
    parameter [7:0] Slide_vertical_size = (Mat_Kernal_Xsize - Kernal_size) + 1; // Number of vertical slidings
   
   
   
   
 //FSM_stages
    parameter [3:0] IDLE = 4'b0000;
    parameter [3:0] SET_VERTICAL = 4'b0001;
    parameter [3:0] SET_HORIZONTAL = 4'b0010;
    parameter [3:0] PATCH_PROCESSING = 4'b0011;
    parameter [3:0] DELAY1 = 4'b0100;
    parameter [3:0] DELAY2 = 4'b0101;
    parameter [3:0] DATA_STORAGE = 4'b0110;
    parameter [3:0] DONE = 4'b0111;  
    parameter [3:0] GeMM = 4'b1000;
   
    reg signed [8:0] kernel [8:0]; // Kernel storage
    wire signed [8:0] kernel_douta;
    reg [3:0] kernel_read_count = 0; // Count for kernel read
    reg [1:0]kernel_read_delay = 2'b0; // to introduce the required read latency
   
    reg [3:0] PS, NS; // FSM states
   
   
   
   
   
    reg ce=1'd0;
 
   
   
   
    reg [31:0] timer = 32'b0;  // Timer value (number of clock cycles)
    reg start_timer =1'b0;
       
    wire signed [8:0] douta;
    reg ena = 1;
    reg signed [8:0] dout;
   
   
   
    reg done_sliding =1'b0;
   
   
    reg [3:0]element_count =0;
   
   
    reg write_flag=0;
   
   
    reg write=1'b0;
   
   
    reg [15:0] addr_out=16'b0;
   
       
    reg [15:0] addr_fmap = 16'b0;
   
   
    reg [15:0] matrix_patch = 16'b0;
   
   
    reg [15:0] patch_counter = 16'b0;
   
   
    reg [15:0]count_patch=16'b0;
   
   
    reg [7:0] hsliding = 0;
   
   
    reg [7:0] vsliding = 0;
 
   
    reg [16:0] flag = 0;
   
   
   
    reg signed [8:0] intermediate_mat [8:0] ;
   
    wire signed [17:0] par_sum [8:0];
   
    reg signed [22:0]result =23'd0;
   
   
    initial begin
    intermediate_mat[0]=8'b0;
    intermediate_mat[1]=8'b0;
    intermediate_mat[2]=8'b0;
    intermediate_mat[3]=8'b0;
    intermediate_mat[4]=8'b0;
    intermediate_mat[5]=8'b0;
    intermediate_mat[6]=8'b0;
    intermediate_mat[7]=8'b0;
    intermediate_mat[8]=8'b0;
    end
   
   
    initial  begin
        kernel[0]=0;
        kernel[1]=0;
        kernel[2]=0;
        kernel[3]=0;
        kernel[4]=0;
        kernel[5]=0;
        kernel[6]=0;
        kernel[7]=0;
        kernel[8]=0;  
    end
   
    blk_mem_gen_0 blk_mem_inst (
        .clka(clk),      
        .ena(ena),      
        .wea(1'b0),      
        .addra(addr_fmap),  
        .dina(8'b0),    
        .douta(douta)    
    );
   
   
    blk_mem_gen_1 blk_mem_inst1 (
        .clka(clk),      
        .ena(ena),      
        .wea(write),      
        .addra(addr_out),  
        .dina(result),    
        .douta(out)    
    );
   
   // BRAM for kernel memory
   
    blk_mem_gen_2 blk_mem_kernel (
        .clka(clk),
        .ena(kernel_read),
        .wea(1'b0),
        .addra(kernel_read_count),
        .dina(8'b0),
        .douta(kernel_douta)
    );
   
   
   
    //dsp block instantiatios
      dsp_block1 dsp_inst0 (
        .CLK(clk),
        .A(intermediate_mat[0]),
        .B(kernel[0]),
        .CE(ce),
        .P(par_sum[0])
    );
   
          dsp_block1 dsp_inst1 (
        .CLK(clk),
        .A(intermediate_mat[1]),
        .B(kernel[1]),
        .CE(ce),
        .P(par_sum[1])
    );
   
          dsp_block1 dsp_inst2 (
        .CLK(clk),
        .A(intermediate_mat[2]),
        .B(kernel[2]),
        .CE(ce),
        .P(par_sum[2])
    );
   
            dsp_block1 dsp_inst3 (
        .CLK(clk),
        .A(intermediate_mat[3]),
        .B(kernel[3]),
        .CE(ce),
        .P(par_sum[3])
    );
   
     dsp_block1 dsp_inst4 (
        .CLK(clk),
        .A(intermediate_mat[4]),
        .B(kernel[4]),
        .CE(ce),
        .P(par_sum[4])
    );
   
          dsp_block1 dsp_inst5 (
        .CLK(clk),
        .A(intermediate_mat[5]),
        .B(kernel[5]),
        .CE(ce),
        .P(par_sum[5])
    );
   
          dsp_block1 dsp_inst6 (
        .CLK(clk),
        .A(intermediate_mat[6]),
        .B(kernel[6]),
        .CE(ce),
        .P(par_sum[6])
    );
   
            dsp_block1 dsp_inst7 (
        .CLK(clk),
        .A(intermediate_mat[7]),
        .B(kernel[7]),
        .CE(ce),
        .P(par_sum[7])
    );
   
      dsp_block1 dsp_inst8 (
        .CLK(clk),
        .A(intermediate_mat[8]),
        .B(kernel[8]),
        .CE(ce),
        .P(par_sum[8])
    );
   
 
    //fsm for kernel reading from bram
   // Kernel read FSM considering read latency
always @(posedge clk or posedge reset) begin
    if (reset) begin
        kernel_read_count <= 0;
        kernel_read_complete <= 0;
        kernel_read_delay <= 0; // New register to handle latency
    end else if (kernel_read && !kernel_read_complete) begin
        if (kernel_read_count < 9) begin
            if (kernel_read_delay == 2) begin
                kernel[kernel_read_count] <= kernel_douta; // Capture data after latency
                kernel_read_count <= kernel_read_count + 1;
                kernel_read_delay <= 0; // Reset delay for next read
            end else begin
                kernel_read_delay <= kernel_read_delay + 1; // Increment delay counter
            end
        end else begin
            kernel_read_complete <= 1; // Mark kernel read as complete
        end
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        PS <= IDLE;
    end
     
    else begin
        PS <= NS;
    end
end

 always @(*) begin
  NS = PS;
    case (PS)
 
              IDLE: begin
               
                if (start && kernel_read_complete) begin
                    NS = SET_VERTICAL;
                    end
                else begin
                    NS = IDLE;
                end
              end
             
              SET_VERTICAL: begin
                if (vsliding <= (Slide_vertical_size - 1)) begin
                    NS = SET_HORIZONTAL;
                end
                else begin
                    NS = DATA_STORAGE;
                end  
             end
             
             SET_HORIZONTAL:  begin
                 if (hsliding <= (Slide_horizontal_size - 1)) begin
                    NS = PATCH_PROCESSING ;
                    end
                else begin
                    NS = SET_VERTICAL;
                end
             end
             
             PATCH_PROCESSING : begin
                  if ( matrix_patch >( Mat_Kernal_Xsize*2)+(Kernal_size-1)+ flag ) begin
                    NS = SET_HORIZONTAL;
                end
                else begin
                     NS = DELAY1;
                end
              end
             
              DELAY1: begin
               
                NS = DELAY2;
              end
             
              DELAY2: begin
                NS = DATA_STORAGE;
              end
              DATA_STORAGE:begin
               
                if(element_count >= 9)begin
               
                   if(done_sliding)begin
                      NS = DONE;
                   end
                   else begin
                   NS = GeMM ;
                   end  
                end
                else begin
                   
                     NS = PATCH_PROCESSING;
                end
             end
             
             GeMM:begin
               
                NS = DATA_STORAGE;
             end
             
              DONE:begin
               
               
               end
               
                default: begin
                  NS = IDLE;
             end
        endcase
    end
   
   
   
   
   
   
   
   
   
   
   
always @(posedge clk) begin
         if (reset) begin
            count_patch <= 8'b0;
            hsliding <= 8'b0;
            vsliding  <= 8'b0;
            flag<= 1'b0;
            done <= 1'b0;
            addr_fmap <= 0;
            addr_out <= 0;
            ce <= 0;
            done_sliding <=0;
            matrix_patch <=0;
            patch_counter <=0;
            result <=0;
            write <=0;          
            write_flag <= 1'b0;
           
         end
         else begin
         case(PS)
             IDLE: begin
             //do nothing
             end
             
             SET_VERTICAL: begin
                done = 1'b0;
                if (vsliding <= (Slide_vertical_size - 1)) begin
                    hsliding <= 0;
                    patch_counter <= 8'b0;
                    flag <= 0;
                    matrix_patch <= 8'b0;
                    vsliding <= vsliding + 1'b1;
                end
                else begin  
                    done_sliding
                    = 1'b1;
                end  
              end
             
                 SET_HORIZONTAL:  begin
                 if (hsliding <= (Slide_horizontal_size - 1)) begin
                 
                    matrix_patch <= 8'b00000000 + hsliding + ((vsliding - 1) * Mat_Kernal_Xsize);
                    patch_counter <= 8'b00000000;
                    flag <= hsliding + ((vsliding - 1) *  Mat_Kernal_Xsize);
                    hsliding <= hsliding + 1'b1;
                    end
                else begin
                   //do nothing
                end
             end
             
             PATCH_PROCESSING : begin
                  if ( matrix_patch >( Mat_Kernal_Xsize*2)+(Kernal_size-1)+ flag ) begin
                   
                    count_patch <= count_patch+1;
                   
                end
                else begin
                    addr_fmap  <=  matrix_patch;
                   
                    patch_counter <= patch_counter + 1;
                    if (patch_counter >= 2) begin
                        matrix_patch <= matrix_patch + (Mat_Kernal_Xsize-2);
                       
                       patch_counter <= 0;
                    end
                    else begin
                      matrix_patch <= matrix_patch + 1;  
                       
                    end
                     
                end
              end
              DELAY1: begin
              write =1;
             end
             
              DELAY2: begin
               
              end
             
               DATA_STORAGE:begin
               
                if(element_count >= 9)begin
                 element_count = 0;
                 
                 result = par_sum[0]+par_sum[1]+par_sum[2]+par_sum[3]+par_sum[4]+par_sum[5]+par_sum[6]+par_sum[7]+par_sum[8];
                  
                   if (!write_flag) begin
                         addr_out = addr_out;
                     end
                   
                    else begin
                         addr_out = addr_out + 1;
                     end
                     write_flag = 1;
                  if(done_sliding)begin
                   
                  end
                  else begin
                 
                  end  
                end
               
                else begin
                   
                    dout = douta;
                    element_count = element_count + 1;
                    case(element_count)
                    4'd1: intermediate_mat[0] = dout;
                    4'd2: intermediate_mat[1] = dout;
                    4'd3: intermediate_mat[2] = dout;
                    4'd4: intermediate_mat[3] = dout;
                    4'd5: intermediate_mat[4] = dout;
                    4'd6: intermediate_mat[5] = dout;
                    4'd7: intermediate_mat[6] = dout;
                    4'd8: intermediate_mat[7] = dout;
                    4'd9:begin
                     intermediate_mat[8] = dout;
                     ce = 1;
                     end
                    default: ;
                    endcase
                end
             end
             
             GeMM:begin
               ce = 0;
             end
             DONE:begin
                 done = 1'b1;
                 
                 write = 0;
                 if(done) begin
                    addr_out = addr_in;
                 end
              
                 
             end
               
             default: begin
             
             end      
         endcase
      end
           
  end  
 
 
 /*  always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the timer and control signal
            timer <= 32'b0;
            start_timer <= 1'b0;
        end else begin
            if (start && !done) begin
                // Start the timer when the start switch is ON and the process is not yet done
                start_timer <= 1'b1;
            end
            if (done) begin
                // Stop the timer when the process is complete
                start_timer <= 1'b0;
            end
            if (start_timer) begin
                // Increment the timer while the timer is running
                timer <= timer + 1;
            end
        end
    end*/
   
        
          

       
         
endmodule