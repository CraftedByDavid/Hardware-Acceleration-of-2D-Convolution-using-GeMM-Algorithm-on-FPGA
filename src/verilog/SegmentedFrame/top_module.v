`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2025 09:31:38
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,          
    input start,
    input kernel_read1,
    input kernel_read2,
    input kernel_read3,
    input kernel_read4,
    input kernel_read5,
    input kernel_read6,  
    input reset,  
    output reg kernel_read_complete = 1'b0, 
    output reg led = 1'b0,
    output tx
    );
    
    
   
   wire [7:0]transmit_data;
   wire busy;
   wire send;
   wire signed [22:0] out_unit1;
   wire signed [22:0] out_unit2;
   wire signed [22:0] out_unit3;
   wire signed [22:0] out_unit4;
   wire signed [22:0] out_unit5;
   wire signed [22:0] out_unit6;
   wire signed [22:0] out_unit7;
   wire signed [22:0] out_unit8;
   wire [12:0] strip1_image_read_count;
   wire [12:0] strip2_image_read_count;
   wire [12:0] strip3_image_read_count;
   wire [12:0] strip4_image_read_count;
   wire [12:0] strip5_image_read_count;
   wire [12:0] strip6_image_read_count;
   wire [12:0] strip7_image_read_count;
   wire [12:0] strip8_image_read_count;
  
   
   reg done = 1'b0;
   
   wire done_unit1;
   wire done_unit2;
   wire done_unit3;
   wire done_unit4;
   wire done_unit5;
   wire done_unit6;
   wire done_unit7;
   wire done_unit8;
   
   wire bram_read_complete;
   wire bram_read_complete1;
    wire bram_read_complete2;
   wire bram_read_complete3;
    wire bram_read_complete4;
   wire bram_read_complete5;
    wire bram_read_complete6;
   wire bram_read_complete7;
    wire bram_read_complete8;

   
  
   
  
    
    
      
    
    reg signed [8:0] kernel [8:0]; // Kernel temporay storage
    wire signed [8:0] kernel_douta1; //kernel BRAM out
    wire signed [8:0] kernel_douta2;
    wire signed [8:0] kernel_douta3;
    wire signed [8:0] kernel_douta4;
    wire signed [8:0] kernel_douta5;
    wire signed [8:0] kernel_douta6;
    reg [3:0] kernel_read_count = 0; // Count for kernel read
    reg [1:0]kernel_read_delay = 2'b0; // to introduce the required read latency
    
    //laplacian kernel
    blk_mem_gen_2 blk_mem_kernel1 (
        .clka(clk),
        .ena(kernel_read1),
        .wea(1'b0),
        .addra(kernel_read_count),
        .dina(8'b0),
        .douta(kernel_douta1)
    );
    
     //bram for basic sharpening
     basic_sharpening blk_mem_kernel2 (
        .clka(clk),
        .ena(kernel_read2),
        .wea(1'b0),
        .addra(kernel_read_count),
        .dina(8'b0),
        .douta(kernel_douta2)
    );
   
    //bram for edge enhancing
    edge_enhancing blk_mem_kernel3 (
        .clka(clk),
        .ena(kernel_read3),
        .wea(1'b0),
        .addra(kernel_read_count),
        .dina(8'b0),
        .douta(kernel_douta3)
    );
   
    //bram for edge preserving smooth
    edge_preserving_smooth blk_mem_kernel4 (
        .clka(clk),
        .ena(kernel_read4),
        .wea(1'b0),
        .addra(kernel_read_count),
        .dina(8'b0),
        .douta(kernel_douta4)
    );
   
   //bram for laplace sharpening
   laplace_sharpening blk_mem_kernel5 (
        .clka(clk),
        .ena(kernel_read5),
        .wea(1'b0),
        .addra(kernel_read_count),
        .dina(8'b0),
        .douta(kernel_douta5)
    );
   
    //bram for unsharp masking
    unsharp_masking blk_mem_kernel6 (
        .clka(clk),
        .ena(kernel_read6),
        .wea(1'b0),
        .addra(kernel_read_count),
        .dina(8'b0),
        .douta(kernel_douta6)
    );

    
    
   
    
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
    
    
    
    
// Kernel read FSM considering read latency
always @(posedge clk or posedge reset) begin
    if (reset) begin
        kernel_read_count <= 0;
        kernel_read_complete <= 0;
        kernel_read_delay <= 0; // New register to handle latency
    end else if (kernel_read1 && !kernel_read_complete && !kernel_read2 && !kernel_read3 && !kernel_read4 && !kernel_read5 && !kernel_read6) begin
        if (kernel_read_count < 9) begin
            if (kernel_read_delay == 2) begin
                kernel[kernel_read_count] <= kernel_douta1; // Capture data after latency
                kernel_read_count <= kernel_read_count + 1;
                kernel_read_delay <= 0; // Reset delay for next read
            end else begin
                kernel_read_delay <= kernel_read_delay + 1; // Increment delay counter
            end
        end else begin
            kernel_read_complete <= 1; // Mark kernel read as complete
        end
    end else if (kernel_read2 && !kernel_read_complete && !kernel_read1 && !kernel_read3 && !kernel_read4 && !kernel_read5 && !kernel_read6) begin
        if (kernel_read_count < 9) begin
            if (kernel_read_delay == 2) begin
                kernel[kernel_read_count] <= kernel_douta2; // Capture data after latency
                kernel_read_count <= kernel_read_count + 1;
                kernel_read_delay <= 0; // Reset delay for next read
            end else begin
                kernel_read_delay <= kernel_read_delay + 1; // Increment delay counter
            end
        end else begin
            kernel_read_complete <= 1; // Mark kernel read as complete
        end
    end else if (kernel_read3 && !kernel_read_complete && !kernel_read2 && !kernel_read1 && !kernel_read4 && !kernel_read5 && !kernel_read6) begin
        if (kernel_read_count < 9) begin
            if (kernel_read_delay == 2) begin
                kernel[kernel_read_count] <= kernel_douta3; // Capture data after latency
                kernel_read_count <= kernel_read_count + 1;
                kernel_read_delay <= 0; // Reset delay for next read
            end else begin
                kernel_read_delay <= kernel_read_delay + 1; // Increment delay counter
            end
        end else begin
            kernel_read_complete <= 1; // Mark kernel read as complete
        end
    end else if (kernel_read4 && !kernel_read_complete && !kernel_read2 && !kernel_read3 && !kernel_read1 && !kernel_read5 && !kernel_read6) begin
        if (kernel_read_count < 9) begin
            if (kernel_read_delay == 2) begin
                kernel[kernel_read_count] <= kernel_douta4; // Capture data after latency
                kernel_read_count <= kernel_read_count + 1;
                kernel_read_delay <= 0; // Reset delay for next read
            end else begin
                kernel_read_delay <= kernel_read_delay + 1; // Increment delay counter
            end
        end else begin
            kernel_read_complete <= 1; // Mark kernel read as complete
        end
    end else if (kernel_read5 && !kernel_read_complete && !kernel_read2 && !kernel_read3 && !kernel_read4 && !kernel_read1 && !kernel_read6) begin
        if (kernel_read_count < 9) begin
            if (kernel_read_delay == 2) begin
                kernel[kernel_read_count] <= kernel_douta5; // Capture data after latency
                kernel_read_count <= kernel_read_count + 1;
                kernel_read_delay <= 0; // Reset delay for next read
            end else begin
                kernel_read_delay <= kernel_read_delay + 1; // Increment delay counter
            end
        end else begin
            kernel_read_complete <= 1; // Mark kernel read as complete
        end
    end else if (kernel_read6 && !kernel_read_complete && !kernel_read2 && !kernel_read3 && !kernel_read4 && !kernel_read5 && !kernel_read1) begin
        if (kernel_read_count < 9) begin
            if (kernel_read_delay == 2) begin
                kernel[kernel_read_count] <= kernel_douta6; // Capture data after latency
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


  ip_im2colconv_unit1 u_ip_im2colconv_unit1 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip1_addr(strip1_image_read_count),
        .done(done_unit1),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit1)
    );
    
    
     ip_im2colconv_unit2 u_ip_im2colconv_unit2 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip2_addr(strip2_image_read_count),
        .done(done_unit2),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit2)
    );
    
    
     ip_im2colconv_unit3 u_ip_im2colconv_unit3 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip3_addr(strip3_image_read_count),
        .done(done_unit3),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit3)
    );
    
    
     ip_im2colconv_unit4 u_ip_im2colconv_unit4 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip4_addr(strip4_image_read_count),
        .done(done_unit4),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit4)
    );
    
    
    
     ip_im2colconv_unit5 u_ip_im2colconv_unit5 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip5_addr(strip5_image_read_count),
        .done(done_unit5),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit5)
    );
    
    
     ip_im2colconv_unit6 u_ip_im2colconv_unit6 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip6_addr(strip6_image_read_count),
        .done(done_unit6),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit6)
    );
    
    
    
     ip_im2colconv_unit7 u_ip_im2colconv_unit7 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip7_addr(strip7_image_read_count),
        .done(done_unit7),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit7)
    );
    
    
     ip_im2colconv_unit8 u_ip_im2colconv_unit8 (
        .clk(clk),
        .start(start),
        .reset(reset),
        .kernel_0(kernel[0]),
        .kernel_1(kernel[1]),
        .kernel_2(kernel[2]),
        .kernel_3(kernel[3]),
        .kernel_4(kernel[4]),
        .kernel_5(kernel[5]),
        .kernel_6(kernel[6]),
        .kernel_7(kernel[7]),
        .kernel_8(kernel[8]),
        .strip8_addr(strip8_image_read_count),
        .done(done_unit8),
        .kernel_read_complete(kernel_read_complete),
        .out(out_unit8)
    );
    
    // Instantiate the uart_bram_reader module
uart_bram_reader uut (
    .clk(clk),
    .reset(reset),
    .busy(busy),
    .start(done),
    .out_unit1(out_unit1),
    .out_unit2(out_unit2),
    .out_unit3(out_unit3),
    .out_unit4(out_unit4),
    .out_unit5(out_unit5),
    .out_unit6(out_unit6),
    .out_unit7(out_unit7),
    .out_unit8(out_unit8),
    .send(send),
    .bram_read_complete(bram_read_complete),
    .bram_read_complete1(bram_read_complete1),
    .bram_read_complete2(bram_read_complete2),
    .bram_read_complete3(bram_read_complete3),
    .bram_read_complete4(bram_read_complete4),
    .bram_read_complete5(bram_read_complete5),
    .bram_read_complete6(bram_read_complete6),
    .bram_read_complete7(bram_read_complete7),
    .bram_read_complete8(bram_read_complete8),
    .strip1_image_read_count(strip1_image_read_count),
    .strip2_image_read_count(strip2_image_read_count),
    .strip3_image_read_count(strip3_image_read_count),
    .strip4_image_read_count(strip4_image_read_count),
    .strip5_image_read_count(strip5_image_read_count),
    .strip6_image_read_count(strip6_image_read_count),
    .strip7_image_read_count(strip7_image_read_count),
    .strip8_image_read_count(strip8_image_read_count),
    .transmit_data(transmit_data)
);

 uart_transmission uut1 (
    .clk(clk),
    .rst(reset),
    .data_in(transmit_data),
    .send(send),
    .tx(tx),
    .busy(busy)
);

   
   
   always@(posedge clk) begin
     if(reset) begin
        led <= 1'b0 ;
        done <= 1'b0;
      end
   if(done_unit1&&done_unit2&&done_unit3&&done_unit4&&done_unit5&&done_unit6&&done_unit7&&done_unit8) begin
   done <= 1'b1;
   end
   if(bram_read_complete && bram_read_complete1 && bram_read_complete2 && bram_read_complete3 && bram_read_complete4 && bram_read_complete5 && bram_read_complete6 && bram_read_complete7 && bram_read_complete8) begin
   led <= 1'b1;
   end
   end
  
endmodule
