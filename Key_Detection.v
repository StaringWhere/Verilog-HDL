//------连续检测12次及以上Key_In[x]=1，则Key_Out=1，即连续按键大于12ms，即可被检测到------

module Key_Detection(Sys_CLK,Key_In,Key_Out);

input Sys_CLK;
input [1:0]Key_In;
output [1:0]Key_Out;

reg [15:0]Div_Cnt;
reg Div_CLK;

reg [11:0]Key_Temp[1:0];

initial
begin
	Div_CLK = 1'd0;
	Div_Cnt = 16'd0;
	Key_Temp[0] = 12'b0; //仿真时遇到全部都是x的状况，无法得到正确的结果，应初始化数值
	Key_Temp[1] = 12'b0;
end

//系统时钟每25000个上升沿，Div_CLK取反
always@(posedge Sys_CLK)
begin
	if(Div_Cnt == 16'd25000)
		begin
			Div_Cnt = 16'd0;
			Div_CLK = ~Div_CLK;
		end
	else
		Div_Cnt = Div_Cnt + 1'd1;
end

//连续12次检测Key_In[x]都等于1时，Key_Out[x]才等于1
always@(posedge Div_CLK)
begin
	Key_Temp[0] <= (Key_Temp[0] << 1) + Key_In[0];
	Key_Temp[1] <= (Key_Temp[1] << 1) + Key_In[1];
end

assign Key_Out[0] = &Key_Temp[0];
assign Key_Out[1] = &Key_Temp[1];

endmodule