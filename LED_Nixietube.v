module LED_Nixietube(Sys_CLK,EN,COM,SEG,Key_Out);

input Sys_CLK;
input EN;
input [1:0]Key_Out;
output [1:0]COM;
output [7:0]SEG;


reg [7:0]Num_Display;
reg COM_Cnt;
reg Key_Signal; //检测两个按键是否输入

reg Div_CLK;
reg [12:0]Div_Cnt;

reg [15:0]Num; //对应f-0
wire [7:0]SEG; //门级电路需要网型变量

//parameter Display_0 = 8'b11111100;
//parameter Display_1 = 8'b01100000;
//parameter Display_2 = 8'b11011010;
//parameter Display_3 = 8'b11110010;
//parameter Display_4 = 8'b01100110;
//parameter Display_5 = 8'b10110110;
//parameter Display_6 = 8'b10111110;
//parameter Display_7 = 8'b11100000;
//parameter Display_8 = 8'b11111110;
//parameter Display_9 = 8'b11110110;
//
//parameter Display_a = 8'b11101110;
//parameter Display_b = 8'b00111110;
//parameter Display_c = 8'b10011100;
//parameter Display_d = 8'b01111010;
//parameter Display_e = 8'b10011110;
//parameter Display_f = 8'b10001110;

parameter Display_DP = 8'b00000001;

assign COM = (EN)?((COM_Cnt)?2'b10:2'b01):2'b00;

//用或门控制单个数码管的状态
or OR7(SEG[7],Num[0],Num[2],Num[3],Num[5],Num[6],Num[7],Num[8],Num[9],Num[10],Num[12],Num[14],Num[15]);
or OR6(SEG[6],Num[0],Num[1],Num[2],Num[3],Num[4],Num[7],Num[8],Num[9],Num[10],Num[13]);
or OR5(SEG[5],Num[0],Num[1],Num[3],Num[4],Num[5],Num[6],Num[7],Num[8],Num[9],Num[10],Num[11],Num[13]);
or OR4(SEG[4],Num[0],Num[2],Num[3],Num[5],Num[6],Num[8],Num[9],Num[9],Num[11],Num[12],Num[13],Num[14]);
or OR3(SEG[3],Num[0],Num[2],Num[6],Num[8],Num[10],Num[11],Num[12],Num[13],Num[14],Num[15]);
or OR2(SEG[2],Num[0],Num[4],Num[5],Num[6],Num[8],Num[9],Num[10],Num[11],Num[12],Num[14],Num[15]);
or OR1(SEG[1],Num[2],Num[3],Num[4],Num[5],Num[6],Num[8],Num[9],Num[10],Num[11],Num[13],Num[14],Num[15]);

initial
begin
	COM_Cnt <= 1'b0;
	Div_CLK <= 1'b0;
	Div_Cnt <= 13'b0;
	Num_Display <= 8'b0; //为仿真初始化
	Num[15:0] <= 16'b0000_0000_0000_0001; //初始显示0
end

always@(posedge Sys_CLK)
	Key_Signal = |Key_Out;

always@(posedge Key_Signal)
begin
	if(Key_Out == 2'b10)
		Num_Display <= Num_Display + 1'b1;
	else if (Key_Out == 2'b01)
		Num_Display <= Num_Display - 1'b1;
	else
		Num_Display <= Num_Display;
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
		if(COM_Cnt) //高位
			begin
				Num[15:0] = 16'b0; 
				Num[Num_Display[7:4]] = 1'b1; 
			end
		else
			begin
				Num[15:0] = 16'b0; 
				Num[Num_Display[3:0]] = 1'b1; 
			end
		COM_Cnt = COM_Cnt + 1'b1;
	end
	else 
		COM_Cnt = 1'b0;
end

endmodule