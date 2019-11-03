module Red_LED(LED,Sys_CLK,Sys_RST,Key_In);

input Sys_CLK;
input Sys_RST;
input [1:0]Key_In;
output [3:0]LED;

wire [1:0]Key_Out;

Key Key(.Sys_CLK(Sys_CLK),.Key_In(Key_In),.Key_Out(Key_Out));

reg Key_Signal;
reg [3:0]LED;

initial
begin
	LED <= 4'b0;
	Key_Signal <= 1'b0;
end

always@(posedge Sys_CLK)
begin
	Key_Signal = |Key_Out;
end	

always@(posedge Key_Signal or negedge Sys_RST)
begin
	if(!Sys_RST)
		LED <= 8'b0;
	else
	begin
		if(Key_Out == 2'b10)
			LED <= LED + 1'b1;
		else if (Key_Out == 2'b01)
			LED <= LED - 1'b1;
		else
			LED <= LED;
	end
end

endmodule
