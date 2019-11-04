`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:15:29 11/04/2019
// Design Name:   BinToBCD
// Module Name:   C:/Users/xiang/Desktop/FPGAXC3_Test1/FPGAXC3_Test/Verilog HDL/BinToBCD_test.v
// Project Name:  FPGAXC3_Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BinToBCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BinToBCD_test;

	// Inputs
	reg [15:0] Data_Bin;
	reg Sys_CLK;

	// Outputs
	wire [19:0] Data_BCD;

	// Instantiate the Unit Under Test (UUT)
	BinToBCD uut (
		.Data_Bin(Data_Bin), 
		.Data_BCD(Data_BCD), 
		.Sys_CLK(Sys_CLK)
	);

	always #10 Sys_CLK=~Sys_CLK; //ÏµÍ³ÆµÂÊ50MHz

	initial begin
		// Initialize Inputs
		Data_Bin = 0;
		Sys_CLK = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#1000 Data_Bin=16'b0000_0000_0000_0000;
		#1000 Data_Bin=16'b0000_0000_1000_0000;
		#5000 $stop;
	end
      
endmodule

