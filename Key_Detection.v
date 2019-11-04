//------�������12�μ�����Key_In[x]=1����Key_Out=1����������������12ms�����ɱ���⵽------

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
	Key_Temp[0] = 12'b0; //����ʱ����ȫ������x��״�����޷��õ���ȷ�Ľ����Ӧ��ʼ����ֵ
	Key_Temp[1] = 12'b0;
end

//ϵͳʱ��ÿ25000�������أ�Div_CLKȡ��
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

//����12�μ��Key_In[x]������1ʱ��Key_Out[x]�ŵ���1
always@(posedge Div_CLK)
begin
	Key_Temp[0] <= (Key_Temp[0] << 1) + Key_In[0];
	Key_Temp[1] <= (Key_Temp[1] << 1) + Key_In[1];
end

assign Key_Out[0] = &Key_Temp[0];
assign Key_Out[1] = &Key_Temp[1];

endmodule