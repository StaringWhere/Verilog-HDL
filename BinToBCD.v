module BinToBCD(Data_Bin,Data_BCD,Sys_CLK);  // N/A not been igorned -- 20180824 noted

input Sys_CLK;					//系统时钟输入
input [15:0]Data_Bin;			//二进制码输入
output [19:0]Data_BCD;			//8421BCD码输出
wire [3:0]Hex[3:0];

reg [18:0]HexD;
reg [13:0]HexC;
reg [9:0]HexB;
reg [3:0]HexA;

reg [5:0]resa,resb,resc,resd;
reg [3:0]rese;

assign Hex[0] = Data_Bin[3:0];
assign Hex[1] = Data_Bin[7:4];
assign Hex[2] = Data_Bin[11:8];
assign Hex[3] = Data_Bin[15:12];

assign Data_BCD = {rese,resd[3:0],resc[3:0],resb[3:0],resa[3:0]};


always@(posedge Sys_CLK)                  //鬢it译码
begin
    case(Hex[3])
        4'h0: HexD <= 19'h00000;
        4'h1: HexD <= 19'h04096;
        4'h2: HexD <= 19'h08192;
        4'h3: HexD <= 19'h12288;
        4'h4: HexD <= 19'h16384;
        4'h5: HexD <= 19'h20480;
        4'h6: HexD <= 19'h24576;
        4'h7: HexD <= 19'h28672;
        default: HexD <= 19'h00000;
    endcase
end

always@(posedge Sys_CLK)                //次高4bit译码
begin
    case(Hex[2]) 
        4'h0: HexC <= 14'h0000;
        4'h1: HexC <= 14'h0256;
        4'h2: HexC <= 14'h0512;
        4'h3: HexC <= 14'h0768;
        4'h4: HexC <= 14'h1024;
        4'h5: HexC <= 14'h1280;
        4'h6: HexC <= 14'h1536;
        4'h7: HexC <= 14'h1792;
        4'h8: HexC <= 14'h2048;
        4'h9: HexC <= 14'h2304;
        4'ha: HexC <= 14'h2560;
        4'hb: HexC <= 14'h2816;
        4'hc: HexC <= 14'h3072;
        4'hd: HexC <= 14'h3328;
        4'he: HexC <= 14'h3584;
        4'hf: HexC <= 14'h3840;
        default: HexC <= 14'h0000;
    endcase
end 

always@(posedge Sys_CLK)
begin
    case(Hex[1])
        4'h0: HexB <= 10'h000;
        4'h1: HexB <= 10'h016;
        4'h2: HexB <= 10'h032;
        4'h3: HexB <= 10'h048;
        4'h4: HexB <= 10'h064;
        4'h5: HexB <= 10'h080;
        4'h6: HexB <= 10'h096;
        4'h7: HexB <= 10'h112;
        4'h8: HexB <= 10'h128;
        4'h9: HexB <= 10'h144;
        4'ha: HexB <= 10'h160;
        4'hb: HexB <= 10'h176;
        4'hc: HexB <= 10'h192;
        4'hd: HexB <= 10'h208;
        4'he: HexB <= 10'h224;
        4'hf: HexB <= 10'h240;
        default: HexB <= 10'h000;
    endcase
end 

always@(posedge Sys_CLK)
begin
    HexA <= Hex[0];
end

always@(posedge Sys_CLK) //每个结果按同级单个bcd码相勩?一级的bcd码要加上低一级的进位,也就是高判?的部分
begin   
    resa = AddBCD(HexA[3:0],HexB[3:0],HexC[3:0],HexD[3:0]);
    resb = AddBCD(resa[5:4],HexB[7:4],HexC[7:4],HexD[7:4]);
    resc = AddBCD(resb[5:4],HexB[9:8],HexC[11:8],HexD[11:8]);
    resd = AddBCD(resc[5:4],4'h0,HexC[13:12],HexD[15:12]);
    rese = resd[5:4] + HexD[17:16];
end

function [5:0]AddBCD; 
input [3:0]add1,add2,add3,add4;
begin
    AddBCD = add1 + add2 + add3 + add4;
    if(AddBCD > 6'h1d)               //>29 最低有一个可能出珸f,但由二进制转换而来的数在这里不会出现大亰的情冊        AddBCD = AddBCD + 5'h12;
    else if(AddBCD > 5'h13)          //>19对结果加12
        AddBCD = AddBCD + 4'hc;
    else if(AddBCD > 4'h9)           //>9对结果加6
        AddBCD = AddBCD + 4'h6;
end
endfunction

endmodule
