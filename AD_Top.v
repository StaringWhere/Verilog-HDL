module AD_Top(CLK,SCLK,CS,SDO,SDI,AD_BCDOut,AD_Address,Switch);
input CLK;
input SDI;
input [1:0]Switch;
output SCLK;
output CS;
output SDO;
//output reg [3:0]Data_Display;
output [11:0]AD_BCDOut;
output [3:0]AD_Address;

wire [15:0]Data_In;

reg [15:0]Data_Out;
reg [20:0]cnt;

reg [1:0]Status;
reg [2:0]Status_Init_Sta;

reg ReadData_Flag;

reg [15:0]Set_Mode;
reg [15:0]Set_Mode_Reg;

parameter Init_ManualMode = 16'b0001_1000_0100_0000;
parameter Init_Auto1Mode_Frame1 = 16'b1000_0000_0000_0000;
parameter Init_Auto1Mode_Frame2 = 16'b0000_0000_0000_1111;
parameter Init_Auto2Mode = 16'b1001_0001_0100_0000;
parameter Init_Set_Alarm_Frame1 = 16'b1101_0000_0000_0000;
parameter Init_Set_Alarm_Frame2 = 16'b1111_0011_1111_1111;
parameter Init_Set_GPIO = 16'b0100_0000_1000_1011;
//parameter Set_Mode = 16'b0001_1001_1100_0000;
parameter Remain_Mode = 16'b0000_0000_0000_0000;
parameter Reset = 16'b0100_0010_0000_0000;

parameter Status_Init = 2'b00;
parameter Status_Set_Mode = 2'b01;
parameter Status_Remain_Mode = 2'b10;
parameter Status_Reset = 2'b11;

parameter Status_Init_ManualMode = 3'b000;
parameter Status_Init_Auto1Mode_Frame1 = 3'b001;
parameter Status_Init_Auto1Mode_Frame2 = 3'b010;
parameter Status_Init_Auto2Mode = 3'b011;
parameter Status_Init_SetAlarm_Frame1 = 3'b100;
parameter Status_Init_SetAlarm_Frame2 = 3'b101;
parameter Status_Init_SetGPIO = 3'b110;

assign AD_Address = Data_In[15:12];

AD_SPI_Trans AD_SPI_Trans(.CLK(CLK),.SCLK(SCLK),.CS(CS),.SDO(SDO),.SDI(SDI),.Data_In(Data_In),.Data_Out(Data_Out),.ReadData_Flag(ReadData_Flag));
AD_Table AD_Table(.Data_In(Data_In[11:0]),.BCD_Out(AD_BCDOut),.Table_CLK(CS));

initial
begin
	Status = Status_Init;
	Status_Init_Sta = Status_Init_ManualMode;
	//Data_Display = 4'b0;
	Set_Mode = 16'b0001_1001_1100_0000;
	Set_Mode_Reg = 16'b0001_1001_1100_0000;
	cnt = 0;
	ReadData_Flag = 1'b0;
	Data_Out = 16'b0;
end

always@(posedge CS)
begin
	case(Status)
		//Status_Reset:
		//begin
			//Data_Out = Reset;
			//Status = Status_Init;
		//end
		Status_Init:
		begin
			case(Status_Init_Sta)
				Status_Init_ManualMode:
				begin
					Data_Out = Init_ManualMode;
					Status_Init_Sta = Status_Init_Auto1Mode_Frame1;
				end
				Status_Init_Auto1Mode_Frame1:
				begin
					Data_Out = Init_Auto1Mode_Frame1;
					Status_Init_Sta = Status_Init_Auto1Mode_Frame2;
				end
				Status_Init_Auto1Mode_Frame2:
				begin
					Data_Out = Init_Auto1Mode_Frame2;
					Status_Init_Sta = Status_Init_Auto2Mode;
				end
				Status_Init_Auto2Mode:
				begin
					Data_Out = Init_Auto2Mode;
					Status_Init_Sta = Status_Init_SetAlarm_Frame1;
				end
				Status_Init_SetAlarm_Frame1:
				begin
					Data_Out = Init_Set_Alarm_Frame1;
					Status_Init_Sta = Status_Init_SetAlarm_Frame2;
				end
				Status_Init_SetAlarm_Frame2:
				begin
					Data_Out = Init_Set_Alarm_Frame2;
					Status_Init_Sta = Status_Init_SetGPIO;
				end
				Status_Init_SetGPIO:
				begin
					Data_Out = Init_Set_GPIO;
					Status = Status_Set_Mode;
				end
				default:
				begin
					Data_Out = 16'b0;
					Status_Init_Sta = Status_Init_ManualMode;
					Status = Status_Init;
				end
			endcase		
		end
		Status_Set_Mode:
		begin
			Data_Out = Set_Mode;
			Status = Status_Remain_Mode;
		end
		Status_Remain_Mode:
		begin
			if(Set_Mode == Set_Mode_Reg)
				Data_Out = Remain_Mode;
			else
			begin
				Status = Status_Set_Mode;
				Set_Mode_Reg = Set_Mode;
			end
		end
		default:
		begin
			Status = Status_Init;
			Status_Init_Sta = Status_Init_ManualMode;
			Data_Out = 16'b0;
		end
	endcase
end

//assign ReadData_Flag = (Status == Status_Remain_Mode)?1'b1:1'b0;

always@(posedge CS)
begin
	if(Status == Status_Remain_Mode)
		ReadData_Flag = 1'b1;
	else
		ReadData_Flag = 1'b0;
end 

always@(posedge CLK)
begin
	case(Switch)
	2'b00:
		Set_Mode = 16'b0001_1001_1100_0000;
	2'b01:
		Set_Mode = 16'b0001_1001_0100_0000;
	2'b10:
		Set_Mode = 16'b0001_1000_1100_0000;
	2'b11:
		Set_Mode = 16'b0001_1000_0100_0000;
	default:
		Set_Mode = 16'b0;
	endcase
end

/*
always@(posedge CS)
begin
	if(cnt < 10000)
		cnt = cnt + 1'b1;
	else
	begin
		case(Switch)
		2'b00:
			Data_Display = Data_In[15:12];
		2'b01:
			Data_Display = Data_In[11:8];
		2'b10:
			Data_Display = Data_In[7:4];
		2'b11:
			Data_Display = Data_In[3:0];
		default:
			Data_Display = 4'b0;
		endcase
		cnt = 0;
	end
end
*/

endmodule
