`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:14:51 11/04/2019
// Design Name:   LED_Nixietube
// Module Name:   D:/Workspace/verilog/ise/FPGAXC3_Test_3/Verilog HDL/LED_Nixietube_test.v
// Project Name:  FPGAXC3_Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LED_Nixietube
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module LED_Nixietube_test;

	// Inputs
	reg Sys_CLK;
	reg Sys_RST;
	reg EN;
	reg [1:0] Key_Out;

	// Outputs
	wire [1:0] COM;
	wire [7:0] SEG;

	// Instantiate the Unit Under Test (UUT)
	LED_Nixietube uut (
		.Sys_CLK(Sys_CLK), 
		.Sys_RST(Sys_RST), 
		.EN(EN), 
		.COM(COM), 
		.SEG(SEG), 
		.Key_Out(Key_Out)
	);
	
	always #10 Sys_CLK = ~Sys_CLK; //10MHz
	always #500000 Key_Out = Key_Out + 1'b1;
	
	initial begin
		// Initialize Inputs
		Sys_CLK = 0;
		Sys_RST = 1;
		EN = 1;
		Key_Out = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#100000000 $stop;
	end
      
endmodule

