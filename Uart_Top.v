module Uart_Top(Sys_CLK,Sys_RST,Signal_Tx,Signal_Rx);

input Sys_CLK;
input Sys_RST;
//input [1:0]Key_In;
input Signal_Rx;
output Signal_Tx;
//output Key_Signal;

wire Uart_CLK;
//wire [1:0]Key_Out;
//reg Key_Signal;

Uart_ClkDiv Uart_ClkDiv(.Sys_CLK(Sys_CLK),.Uart_CLK(Uart_CLK));

//Key Key(.Sys_CLK(Sys_CLK),.Key_In(Key_In),.Key_Out(Key_Out));             

reg [7:0]Data_Tx;
wire [7:0]Data_Rx;
reg [7:0]Data_Reg;
//reg [7:0]Data_Temp;
reg Wrsig;
wire Rdsig;
wire Rx_DataError_Flag;
wire Rx_FrameError_Flag;
reg Error_Flag;
reg [2:0]State;
reg [7:0]cnt;

reg [7:0]Char[7:0];
reg [7:0]Error_Char[5:0];
reg [3:0]Char_Cnt;

wire Idle; 

parameter Wait_Rdsig = 3'b000;
parameter Check_Data = 3'b001;
parameter Save_Data = 3'b010;
parameter Trans_Data = 3'b011;
parameter State_Delay = 3'b100;

initial
begin
	//Data_Temp <= 8'b0;
	Data_Tx <= 8'b0;
	Wrsig <= 1'b0;
	State <= 2'b0;
	cnt <= 8'b0;
	Char[0] <= 8'd82;	//R
	Char[1] <= 8'd101;	//e
	Char[2] <= 8'd116;	//t
	Char[3] <= 8'd117;	//u
	Char[4] <= 8'd114;	//r
	Char[5]	<= 8'd110;	//n
	Char[6] <= 8'd58;	//:
	Char[7] <= 8'd32;	//Space
	Error_Char[0] <= 8'd69;		//E
	Error_Char[1] <= 8'd114;	//r
	Error_Char[2] <= 8'd114;	//r
	Error_Char[3] <= 8'd111;	//o
	Error_Char[4] <= 8'd114;	//r
	Error_Char[5] <= 8'd33;		//!
	Char_Cnt <=4'b0;
end

always@(posedge Uart_CLK or negedge Sys_RST)
begin
	if(!Sys_RST)
	begin
		Wrsig = 1'b0;
		cnt = 1'b0;
		State = 2'b0;
		Char_Cnt = 4'b0;
		Data_Reg = 8'b0;
	end
	else
	begin
		case(State)
			Wait_Rdsig:begin
				if(!Rdsig)
					State = Wait_Rdsig;
				else
					State = Check_Data;
			end
			Check_Data:begin
				if(Rdsig)
					State = Check_Data;
				else
				begin
					Error_Flag = Rx_DataError_Flag || Rx_FrameError_Flag;
					State = Save_Data;
				end
			end
			Save_Data:begin
				if(!Error_Flag)
					Data_Reg = Data_Rx;
				State = Trans_Data;
			end
			Trans_Data:begin
				if(!Error_Flag)
				begin
					if(Char_Cnt == 4'd8)
					begin
						Char_Cnt = 4'd0;
						Data_Tx = Data_Reg;
						State = State_Delay;
					end
					else
					begin
						State = Trans_Data;
						if(cnt == 254)
						begin
							Data_Tx = Char[Char_Cnt];
							Wrsig = 1'b1;
							cnt = 8'd0;
							Char_Cnt = Char_Cnt + 1'b1;
						end
						else
						begin
							Wrsig = 1'b0;
							cnt = cnt + 8'd1;
						end
					end
				end
				else
				begin
					if(Char_Cnt == 4'd6)
					begin
						Char_Cnt = 4'd0;
						State = State_Delay;
					end
					else
					begin
						State = Trans_Data;
						if(cnt == 254)
						begin
							Data_Tx = Error_Char[Char_Cnt];
							Wrsig = 1'b1;
							cnt = 8'd0;
							Char_Cnt = Char_Cnt + 1'b1;
						end
						else
						begin
							Wrsig = 1'b0;
							cnt = cnt + 8'd1;
						end
					end
				end
			end
			State_Delay:begin
				if(cnt == 254)
				begin
					Data_Tx = 8'd13;
					Wrsig = 1'b1;
					cnt = 8'd0;
					State = Wait_Rdsig;
				end
				else
				begin
					Wrsig = 1'b0;
					cnt = cnt + 8'd1;
				end
			end
			default:begin
				Wrsig = 1'b0;
				cnt = 1'b0;
				State = 2'b0;
				Char_Cnt = 4'b0;
				Data_Reg = 8'b0;
			end
		endcase
	end
end	

/*
always@(posedge Sys_CLK)
begin
	Key_Signal = |Key_Out;
end	

always@(posedge Key_Signal or negedge Sys_RST)
begin
	if(!Sys_RST)
		Data_Temp <= 8'b0;
	else
	begin
		if(Key_Out == 2'b10)
			Data_Temp <= Data_Temp + 1'b1;
		else if (Key_Out == 2'b01)
			Data_Temp <= Data_Temp - 1'b1;
		else
			Data_Temp <= Data_Temp;
	end
end

always@(posedge Uart_CLK)
begin
	case(State)
		2'b00:begin
			if(Data_Temp != Data_Tx)
				State = 2'b01;
			else
				State = 2'b00;
		end
		2'b01:begin
			if(cnt < 8'd5)
				cnt = cnt + 1'b1;
			else 
			begin
				Data_Tx = Data_Temp;
				cnt = 8'd0;
				State = 2'b10;
			end
		end
		2'b10:begin
			Wrsig = 1'b1;
			State = 2'b11;
		end
		2'b11:begin
			Wrsig = 1'b0;
			State = 2'b00;
		end
		default:State = 2'b00;
	endcase
end	

always@(posedge Uart_CLK or negedge Sys_RST)
begin
	if(!Sys_RST)
	begin
		cnt <= 8'd0;
		Wrsig <= 1'b0;
		Data_Tx <= 8'b0;
	end
	else
	begin
		if(cnt == 254)
		begin
			Data_Tx <= Data_Tx + 8'b1;
			Wrsig <= 1'b1;
			cnt <= 8'd0;
		end
		else
		begin
			Wrsig <= 1'b0;
			cnt <= cnt + 8'd1;
		end
	end
end	*/

Uart_Tx Uart_Tx(.Uart_CLK(Uart_CLK),.Data_Tx(Data_Tx),.Wrsig(Wrsig),.Idle(Idle),.Signal_Tx(Signal_Tx));
Uart_Rx Uart_Rx(.CLK(Uart_CLK),.RST(Sys_RST),.Signal_Rx(Signal_Rx),.Data_Rx(Data_Rx),.Rdsig(Rdsig),
				.DataError_Flag(Rx_DataError_Flag),.FrameError_Flag(Rx_FrameError_Flag));

endmodule