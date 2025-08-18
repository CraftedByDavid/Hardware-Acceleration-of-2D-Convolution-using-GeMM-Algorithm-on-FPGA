`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2025 09:55:39
// Design Name: 
// Module Name: uart_bram_reader
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


module uart_bram_reader(
input clk,
input reset,
input busy,
input start,
input signed [22:0] out_data,
output reg send,
output reg bram_read_complete = 1'b0,
output reg [15:0] image_read_count =16'd0,
output reg [7:0]transmit_data 
);
    
    parameter [2:0] IDLE = 3'b000;
    parameter [2:0] ADDR_SEL = 3'b001;
    parameter [2:0] DELAY1 = 3'b010;
    parameter [2:0] DELAY2 = 3'b011;
    parameter [2:0] TRANSMISSION = 3'b100;
    parameter [2:0] WAIT = 3'b101;
    parameter [2:0] DONE = 3'b110;
    
   reg [2:0] NS,PS; 
   
   reg [15:0] addr_count = 16'b0;
   reg write_flag = 1'b0;
    
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
               
                if (start) begin
                
                    NS = ADDR_SEL;
                    
                    end
                else begin
                
                    NS = IDLE;
                    
                end
              end
             
              ADDR_SEL: begin
              
              if(addr_count >= 16'd49283)begin
              NS = DONE;
              end
              
              else begin
              NS = DELAY1;
              end
              
              end
            
             
             DELAY1:  begin
                
                NS = DELAY2;
                
             end
             
              DELAY2:  begin
                
                NS = TRANSMISSION;
                
             end
             
               TRANSMISSION:  begin
               
                if(busy ==0)begin
                  NS = ADDR_SEL;
                end
                else begin
                    NS = WAIT;
                end
                
               end
               
               WAIT: begin
                
                  NS = TRANSMISSION;  
               end
             
             DONE : begin
             
             end
             default: begin
               
                  NS = IDLE;
             end
        endcase
    end
    
    
      
always @(posedge clk) begin

         if (reset) begin
         addr_count <= 16'b0; 
         bram_read_complete <= 1'b0;
         image_read_count <= 16'b0;
         send <= 1'b0;
         transmit_data <= 16'b0;
         write_flag <= 1'b0;
         
          
         end
         else begin
         
          case (PS)
 
              IDLE: begin
               //do nothing
              end
             
              ADDR_SEL: begin
              
              send <= 1'b0;
              if(addr_count >=16'd49283)begin
              addr_count <= 0;
              //kernel_read_count <=0;
              end
              
              else begin
                if (!write_flag) begin
                         image_read_count <= image_read_count;
                     end
                    else begin
                         image_read_count <= image_read_count + 1;
                         addr_count <= addr_count+1;
                     end
                     write_flag <= 1; 
              end
              
              end
            
             DELAY1:  begin
                //do nothing
             end
             
              DELAY2:  begin
                //do nothing
                
             end
             
             
             TRANSMISSION:  begin
                
               if(busy == 0)begin
               
                if(out_data < 23'sd0)begin
                    transmit_data <= 8'b0;
                end
                
                else if(out_data > 23'sd255) begin
                    transmit_data <= 8'd255;
                end
                
                else begin
                   transmit_data <= out_data[7:0];
                end
                
                send <= 1'b1;
                end
                  
               end
               
               
              WAIT: begin
                      
               end
                 
             DONE : begin
                
                bram_read_complete <=1'b1;
             
             end
             
             
             default: begin
               
             end
             
        endcase
       end
         
    end
   
    
    
    
    
  
endmodule
