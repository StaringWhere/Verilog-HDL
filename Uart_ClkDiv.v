module Uart_ClkDiv(Sys_CLK,Uart_CLK);

input Sys_CLK;
output Uart_CLK;

reg Uart_CLK;
reg [7:0]Uart_CLK_Cnt;

initial
begin
	Uart_CLK <= 1'b0;
	Uart_CLK_Cnt <= 8'd0;
end

always@(posedge Sys_CLK)
begin
	if(Uart_CLK_Cnt <= 8'd161)
		Uart_CLK_Cnt = Uart_CLK_Cnt + 1'b1;
	else
	begin
		Uart_CLK = ~Uart_CLK;
		Uart_CLK_Cnt = 8'd0;
	end
end

endmodule