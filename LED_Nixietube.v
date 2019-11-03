module LED_Nixietube(Sys_CLK,Data_Bin,EN,COM,SEG);

input Sys_CLK;
input EN;
input [11:0]Data_Bin;
output [1:0]COM;
output [7:0]SEG;

wire [7:0]Num_Display;
//wire [19:0]Num_BCD;
//wire [15:0]Num_Bin;

reg [7:0]SEG;
reg COM_Cnt;

reg Div_CLK;
reg [12:0]Div_Cnt;

//assign Num_Bin = {4'b0,Data_Bin};
assign Num_Display = Data_Bin[11:4];

//BinToBCD BinToBCD(.Data_Bin(Num_Bin),.Data_BCD(Num_BCD),.Sys_CLK(Sys_CLK));

parameter Display_0 = 8'b11111100;
parameter Display_1 = 8'b01100000;
parameter Display_2 = 8'b11011010;
parameter Display_3 = 8'b11110010;
parameter Display_4 = 8'b01100110;
parameter Display_5 = 8'b10110110;
parameter Display_6 = 8'b10111110;
parameter Display_7 = 8'b11100000;
parameter Display_8 = 8'b11111110;
parameter Display_9 = 8'b11110110;
parameter Display_DP = 8'b00000001;

assign COM = (EN)?((COM_Cnt)?2'b10:2'b01):2'b00;

initial
begin
	SEG <= 8'b0;
	COM_Cnt <= 1'b0;
	Div_CLK <= 1'b0;
	Div_Cnt <= 13'b0;
end

always@(posedge Sys_CLK)
begin
	if(Div_Cnt < 13'd5000)
		Div_Cnt = Div_Cnt + 1'b1;
	else
	begin
		Div_CLK = ~Div_CLK;
		Div_Cnt = 13'b0;
	end
end

always@(posedge Div_CLK)
begin
	if(EN)
	begin
		if(COM_Cnt)
		begin
			case(Num_Display[7:4])
				4'h0:SEG <= Display_0+1'b1;
				4'h1:SEG <= Display_1+1'b1;
				4'h2:SEG <= Display_2+1'b1;
				4'h3:SEG <= Display_3+1'b1;
				4'h4:SEG <= Display_4+1'b1;
				4'h5:SEG <= Display_5+1'b1;
				4'h6:SEG <= Display_6+1'b1;
				4'h7:SEG <= Display_7+1'b1;
				4'h8:SEG <= Display_8+1'b1;
				4'h9:SEG <= Display_9+1'b1;
				default:SEG <= 4'h0;
			endcase
		end
		else
		begin
			case(Num_Display[3:0])
				4'h0:SEG <= Display_0;
				4'h1:SEG <= Display_1;
				4'h2:SEG <= Display_2;
				4'h3:SEG <= Display_3;
				4'h4:SEG <= Display_4;
				4'h5:SEG <= Display_5;
				4'h6:SEG <= Display_6;
				4'h7:SEG <= Display_7;
				4'h8:SEG <= Display_8;
				4'h9:SEG <= Display_9;
				default:SEG <= 4'h0;
			endcase
		end
		COM_Cnt = COM_Cnt + 1'b1;
	end
	else 
		COM_Cnt = 1'b0;
end

endmodule