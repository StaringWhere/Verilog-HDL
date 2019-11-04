`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:41:05 11/04/2019
// Design Name:   Key_Detection
// Module Name:   D:/Workspace/verilog/ise/FPGAXC3_Test_3/Verilog HDL/Key_Detection_test.v
// Project Name:  FPGAXC3_Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Key_Detection
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Key_Detection_test;

	// Inputs
	reg Sys_CLK;
	reg [1:0] Key_In;

	// Outputs
	wire [1:0] Key_Out;

	// Instantiate the Unit Under Test (UUT)
	Key_Detection uut (
		.Sys_CLK(Sys_CLK), 
		.Key_In(Key_In), 
		.Key_Out(Key_Out)
	);

	always #10 Sys_CLK<=~Sys_CLK; //系统频率为50MHz
	
	initial begin
		// Initialize Inputs
		Sys_CLK = 0;
		Key_In = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#250000 Key_In = 2'b01;
		
		#1200_0000 $stop;
	end
      
endmodule

