module AD_SPI_Trans(CLK,SCLK,CS,SDO,SDI,Data_In,Data_Out,ReadData_Flag);
input CLK;
input SDI;
input ReadData_Flag;
input [15:0]Data_Out;
output SCLK;
output CS;
output SDO;
output reg [15:0]Data_In;

reg SCLK;
reg CS;
reg SDO;

reg [2:0]SCLK_Cnt;
reg [4:0]CS_Cnt;
reg [4:0]SDI_Bit;
reg [4:0]SDO_Bit;

initial
begin
	SCLK <= 1'b0;
	CS <= 1'b1;
	SDO <= 1'b0;
	SCLK_Cnt <= 3'd4;
	CS_Cnt <= 5'b0;
	Data_In <= 16'b0;
end

always@(posedge CLK)
begin
	if(SCLK_Cnt < 3'd2)
	begin
		SCLK_Cnt <= SCLK_Cnt + 1'b1;
		SCLK <= 1'b0;
	end
	else
	begin
		if(SCLK_Cnt < 3'd4)
		begin
			SCLK_Cnt <= SCLK_Cnt + 1'b1;
			SCLK <= 1'b1;
		end
		else
		begin
			SCLK_Cnt <= 4'b0;
			SCLK <= 1'b0;
		end
	end
end

always@(posedge SCLK)
begin
	if(CS_Cnt < 5'd23)
		CS_Cnt <= CS_Cnt + 1'b1;
	else	
		CS_Cnt <= 5'b0;
end

always@(posedge CLK)
begin
	if(CS_Cnt < 5'd5)
		CS = 1'b1;
	else
	begin
		if(SCLK_Cnt == 4'd0)
			CS = 1'b0;
	end
end

always@(negedge SCLK)
begin
	if(!CS)
	begin
		if(SDO_Bit < 5'd15)
		begin
			SDO = Data_Out[5'd14-SDO_Bit];
			SDO_Bit = SDO_Bit + 1'b1;
		end
		else
			SDO_Bit = SDO_Bit;
	end
	else
	begin
		SDO = Data_Out[15];
		SDO_Bit = 5'b0;
	end
end

always@(negedge SCLK)
begin
	if(!CS && ReadData_Flag)
	begin
		if(SDI_Bit < 5'd16)
		begin
			Data_In[5'd15-SDI_Bit] = SDI;
			SDI_Bit = SDI_Bit + 1'b1;
		end
		else
			SDI_Bit = SDI_Bit;
	end
	else
		SDI_Bit = 5'b0;
end

endmodule
