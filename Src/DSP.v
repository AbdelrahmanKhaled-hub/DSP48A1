//instantiated module among the whole project
module Register_Mux #(parameter WIDTH=18,REG_IDENTIFIER=1,RSTTYPE="SYNC") (input [WIDTH-1:0] X,input CLK ,rst,EN,output  [WIDTH-1:0] out);
reg [WIDTH-1:0] X_reg;
always@(posedge CLK, posedge rst) begin
    if(RSTTYPE=="ASYNC") begin
        if(rst) X_reg<=0;
        else if(EN) X_reg<=X;    
    end
end
always@(posedge CLK) begin
    if(RSTTYPE=="SYNC")begin 
        if(EN) begin
            if(rst) X_reg<=0;
            else  X_reg <=X;
  end
end
end
assign out =(REG_IDENTIFIER)?X_reg:X;
endmodule

module DSP48A1_Project (A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
//parameters declaration
parameter A0REG=0; 
parameter A1REG=1; 
parameter B0REG=0;
parameter B1REG=1;
parameter CREG=1; 
parameter DREG=1; 
parameter MREG=1;
parameter PREG=1; 
parameter CARRYINREG=1; 
parameter CARRYOUTREG=1;
parameter OPMODEREG=1;
parameter CARRYINSEL= "OPMODE5";
parameter B_INPUT ="DIRECT";
parameter RSTTYPE ="SYNC";
//input/output declaration
input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input [7:0] OPMODE;
input CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
output  [17:0] BCOUT;
output  [47:0] PCOUT,P;
output  [35:0] M;
output  CARRYOUT,CARRYOUTF;
//internal signals
wire [17:0] A0_reg,A1_reg,B0_input,B0_reg,B1_input,B1_reg,D_reg,Pre_add_sub_out;
wire [47:0] C_reg,concat_out,X_out ,Z_out;
wire [48:0] Post_add_sub_out;
wire[35:0] M_reg,multiplier_out;
wire [7:0] OPMODE_reg;
wire CARRYIN_reg,CYI,CYO;
//Project Main
assign B0_input =(B_INPUT=="DIRECT")?B:BCIN;
Register_Mux #(18,DREG,RSTTYPE) D_register (D,CLK,RSTD,CED,D_reg);
Register_Mux #(18,B0REG,RSTTYPE) B0_register (B0_input,CLK,RSTB,CEB,B0_reg);
Register_Mux #(18,A0REG,RSTTYPE) A0_register (A,CLK,RSTA,CEA,A0_reg);
Register_Mux #(18,A1REG,RSTTYPE) A1_register (A0_reg,CLK,RSTA,CEA,A1_reg);
Register_Mux #(48,CREG,RSTTYPE) C_register (C,CLK,RSTC,CEC,C_reg);
Register_Mux #(8,OPMODEREG,RSTTYPE) OPMODE_register (OPMODE,CLK,RSTOPMODE,CEOPMODE,OPMODE_reg);
assign CYI =(CARRYINSEL=="OPMODE5")?OPMODE_reg[5]:(CARRYINSEL=="CARRYIN")?CARRYIN:0;
Register_Mux #(1,CARRYINREG,RSTTYPE) CARRYIN_register (CYI,CLK,RSTCARRYIN,CECARRYIN,CARRYIN_reg);
//Pre_adder/Subtracter
assign Pre_add_sub_out =(OPMODE_reg[6])?(D_reg-B0_reg):(D_reg+B0_reg);
assign B1_input =(OPMODE_reg[4])?Pre_add_sub_out:B0_reg;
Register_Mux #(18,B1REG,RSTTYPE) B1_register (B1_input,CLK,RSTB,CEB,B1_reg);
assign BCOUT = B1_reg;
//Multiplier
assign multiplier_out = A1_reg*B1_reg;
assign concat_out ={D[11:0],A1_reg,B1_reg};
Register_Mux #(36,MREG,RSTTYPE) M_register (multiplier_out,CLK,RSTM,CEM,M_reg);
assign M =~(~M_reg);
assign X_out=(OPMODE_reg[1:0]==0)?0:(OPMODE_reg[1:0]==1)?M_reg:(OPMODE_reg[1:0]==2)?P:concat_out;
assign Z_out=(OPMODE_reg[3:2]==0)?0:(OPMODE_reg[3:2]==1)?PCIN:(OPMODE_reg[3:2]==2)?P:C_reg;
//Post_adder/Subtracter
assign Post_add_sub_out =(OPMODE_reg[7])?(Z_out-(X_out+CARRYIN_reg)):(Z_out+X_out+CARRYIN_reg);
assign CYO = Post_add_sub_out[48];
Register_Mux #(1,CARRYOUTREG,RSTTYPE) CARRYOUT_register (CYO,CLK,RSTCARRYIN,CECARRYIN,CARRYOUT);
assign CARRYOUTF =CARRYOUT;
Register_Mux #(48,PREG,RSTTYPE) P_register (Post_add_sub_out[47:0],CLK,RSTP,CEP,P);
assign PCOUT=P;
endmodule

