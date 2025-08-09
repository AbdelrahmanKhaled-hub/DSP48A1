module Project_tb ();
//Signal Declaration
reg CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
reg [7:0] OPMODE;
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
wire CARRYOUT,CARRYOUTF;
wire [17:0] BCOUT;
wire[35:0] M;
wire [47:0] PCOUT,P;
//DUT instantiation
DSP48A1_Project DUT (A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
//CLOCK generation
initial begin
    CLK=0;
    forever begin
        #1 CLK=~CLK;
    end
end
initial begin
    //reset all
    CEA=1;CEB=1;CEM=1;CEP=1;CEC=1;CED=1;CECARRYIN=1;CEOPMODE=1;
    RSTA=1;RSTB=1;RSTM=1;RSTP=1;RSTC=1;RSTD=1;RSTCARRYIN=1;RSTOPMODE=1;
    #20;
    if(P!=0) begin
        $display("output is wrong");
        $stop;
    end
    RSTA=0;RSTB=0;RSTM=0;RSTP=0;RSTC=0;RSTD=0;RSTCARRYIN=0;RSTOPMODE=0;
    OPMODE='b00111101; //C+[([D+B].A)+OPMODE[5]]
    D=1000;B=2000;A=3;C=10; //Expected output = 3311
    #20;
    if(P!=9011) begin
        $display("output is wrong");
        $stop;
    end
    OPMODE='b01011101; //C+[(D-B).A]
    D=35;B=15;A=5;C=50;//Expected output =150
    #20
    if(P!=150) begin
        $display("output is wrong");
        $stop;
    end
    OPMODE='b11001101; //C-(A.B)
    B=15;A=5;C=250;    //Expected output =175
    #20
    if(P!=175) begin
        $display("output is wrong");
        $stop;
    end
$stop;
end
endmodule

