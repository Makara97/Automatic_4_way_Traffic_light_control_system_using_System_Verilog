`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Kavindu Makaranda 
// 
// Create Date: 06/07/2024 08:44:40 AM
// Module Name: Traffic_light_control
// Project Name: Traffic_light_control_system 
// 
// Revision: 1.0.0
// 
//////////////////////////////////////////////////////////////////////////////////

module Traffic_light_control(
    input logic clk, reset,
    output logic R_N, Y_N, G_N,
    output logic R_E, Y_E, G_E,
    output logic R_S, Y_S, G_S,
    output logic R_W, Y_W, G_W 
);

//signal declaration
    logic B;
    logic [1:0] state_current_top, state_next_top;
    logic [2:0] signal_array;
    localparam N = 2'b00;
    localparam E = 2'b01;
    localparam S = 2'b11;
    localparam W = 2'b10;
    
    
    Sub_system Sub_system (.*);
                               
//state register
    always_ff @(posedge B, posedge reset)
    begin
        if (reset)
            state_current_top <= N;
        else 
            state_current_top <= state_next_top;
    end

//next state logic
    always_comb
    begin 
        case (state_current_top)
            N: state_next_top = E;
            E: state_next_top = S;
            S: state_next_top = W;
            W: state_next_top = N;
            default: state_next_top = state_current_top;
        endcase 
    end

//output logic 
    assign R_N = !(state_current_top == N) || (signal_array[2] == 1'b1);
    assign R_E = !(state_current_top == E) || (signal_array[2] == 1'b1);
    assign R_S = !(state_current_top == S) || (signal_array[2] == 1'b1);
    assign R_W = !(state_current_top == W) || (signal_array[2] == 1'b1);
    
    assign Y_N = (state_current_top == N) && (signal_array[1] == 1'b1);
    assign Y_E = (state_current_top == E) && (signal_array[1] == 1'b1);
    assign Y_S = (state_current_top == S) && (signal_array[1] == 1'b1);
    assign Y_W = (state_current_top == W) && (signal_array[1] == 1'b1);
    
    assign G_N = (state_current_top == N) && (signal_array[0] == 1'b1);
    assign G_E = (state_current_top == E) && (signal_array[0] == 1'b1);
    assign G_S = (state_current_top == S) && (signal_array[0] == 1'b1);
    assign G_W = (state_current_top == W) && (signal_array[0] == 1'b1);
    
endmodule

// Sub FSM sytem
module Sub_system(
    input logic clk,reset,
    output logic B,
    output logic [2:0] signal_array
);
    
  //signal declaration
    logic [1:0] state_current_bottom, state_next_bottom;
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b11;
    localparam S3 = 2'b10;
    logic A;
    
    Time_counter Time_counter (.*);
    
  //state register
    always_ff @(posedge A, posedge reset)
    begin
        if (reset)
            state_current_bottom <= S0;
        else 
            state_current_bottom <= state_next_bottom;
    end

  //next state logic
    always_comb
    begin 
        case (state_current_bottom)
            S0: state_next_bottom = S1;
            S1: state_next_bottom = S2;
            S2: state_next_bottom = S3;
            S3: state_next_bottom = S0;
            default: state_next_bottom = state_current_bottom;
        endcase 
    end

  //output logic 
    always_comb 
    begin
        case (state_current_bottom)
            S0: signal_array = 3'b100;
            S1: signal_array = 3'b110;
            S2: signal_array = 3'b001;
            S3: signal_array = 3'b010;
            default: signal_array = 3'b100;
        endcase 
    end
 
endmodule


//Time Counter - Normal_counter part
module Time_counter(
    input logic clk,
    input logic reset,
    output logic A, B
);

    logic [22:0] cal;
    logic signal_out;
      
    Ring_counter Ring_counter (.*);
    


    always_ff @(posedge signal_out, posedge reset)
    begin 
        if (reset) begin
            cal <= 0;
            A <= 0;
            B <= 0;
        end else if (cal == 200000-1) begin 
            A <= 1;
            B <= 0;
            cal <= cal + 1;
        end else if (cal == 400000-1) begin 
            A <= 1;
            B <= 0;
            cal <= cal + 1;
        end else if (cal == 2500000-1) begin 
            A <= 1;
            B <= 0;
            cal <= cal + 1;
        end else if (cal == 3000000-1) begin 
            cal <= 0;
            A <= 1;
            B <= 1;
        end else begin
            cal <= cal + 1;
            A <= 0;
            B <= 0;
        end
    end
endmodule


//Time Counter - Ring_counter part 
module Ring_counter (
    input logic clk,
    input logic reset,
    output logic signal_out
);
   //signal declaration
    logic [499:0] ring_out;
    
   //program boay
    always_ff @(posedge clk , posedge reset) begin
        if (reset) begin
            ring_out[0] <= 1'b1; // Initialize with only the first bit set
            signal_out <= 1'b0;
        end else if(ring_out[0] == 1'b1) begin
            signal_out <= 1'b1;
            ring_out <= {ring_out[498:0], ring_out[499]};
        end else if(ring_out[249] == 1'b1) begin
            signal_out <= 1'b0;
            ring_out <= {ring_out[498:0], ring_out[499]};
        end else begin
            ring_out <= {ring_out[498:0], ring_out[499]}; // Shift left and wrap around
        end
    end
endmodule