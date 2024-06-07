`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Kavindu Makaranda 
// 
// Create Date: 06/07/2024 08:44:40 AM
// Module Name: Traffic_light_control_tb
// Project Name: Traffic_light_control_system 
// 
// Revision: 1.0.0
// 
//////////////////////////////////////////////////////////////////////////////////


module Traffic_light_control_tb();
    
//signal declaration
    localparam T = 20;
    logic clk,reset;
    logic R_N,Y_N,G_N;
    logic R_E,Y_E,G_E;
    logic R_S,Y_S,G_S;
    logic R_W,Y_W,G_W;
    
//instantaiate uut
    Traffic_light_control Traffic_light_control_unit (.*);
    
//program body
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end

    initial 
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
        #(T/2);
    end
endmodule

