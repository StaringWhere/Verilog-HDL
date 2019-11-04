`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:12:17 11/04/2019
// Design Name:   AD_Top
// Module Name:   C:/Users/xiang/Desktop/FPGAXC3_Test1/FPGAXC3_Test/AP_Top_test.v
// Project Name:  FPGAXC3_Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AD_Top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module AP_Top_test;

	// Inputs
	reg CLK;
	reg SDI;
	reg [1:0] Switch;

	// Outputs
	wire SCLK;
	wire CS;
	wire SDO;
	wire [11:0] AD_BCDOut;
	wire [3:0] AD_Address;

	// Instantiate the Unit Under Test (UUT)
	AD_Top uut (
		.CLK(CLK), 
		.SCLK(SCLK), 
		.CS(CS), 
		.SDO(SDO), 
		.SDI(SDI), 
		.AD_BCDOut(AD_BCDOut), 
		.AD_Address(AD_Address), 
		.Switch(Switch)
	);
	
	always #10 CLK=~CLK;
	
	initial begin
		// Initialize Inputs
		CLK = 0;
		SDI = 0;
		Switch = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

