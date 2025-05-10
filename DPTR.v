module DPTR (
    input  wire        Clk,
    output wire [31:0] Instr,
    output wire [31:0] PCout
);
    // Buses internos
    wire [31:0] PCin, PCnext;
    wire [5:0]  OpCode;
    wire [4:0]  Rs;
    wire [4:0]  Rt;
    wire [4:0]  Rd;
    wire [5:0]  Funct;

    // Señales de control
    wire MemToReg, MemWrite, RegWrite, RegDst, ALUSrc, Branch, ZF, Br_AND_ZF, MemRead;
    wire [2:0]  ALUOp;

    // Más buses internos
    wire [31:0] Read1, Read2, ALURes, ReadMem, WriteDataBr, OP2, Extended, Shifted, AddRes;
    wire [2:0]  AluCtrl;
    wire [4:0]  WriteReg;

    // Cables de buffer
    wire [63:0] Cable_combinado1, Cable_salida1;
    wire [153:0] Cable_combinado2, Cable_salida2;
    wire [138:0] Cable_combinado3, Cable_salida3;
    wire [70:0] Cable_combinado4, Cable_salida4;

    // Señales de los buffers
    // Buffer 1
    wire [31:0] Instr_B1, PCnext_B1;
    // Buffer 2
    wire MemRead_B2, MemToReg_B2, MemWrite_B2, RegWrite_B2, RegDst_B2, ALUSrc_B2, Branch_B2;
    wire [2:0] ALUOp_B2;
    wire [31:0] Read1_B2, Read2_B2, Extended_B2, PCnext_B2;
    wire [4:0] Rt_B2, Rd_B2;
    wire [5:0] Funct_B2;
    // Buffer 3
    wire [31:0] PCnext_B3;
    wire [4:0] WriteReg_B3;
    wire [31:0] ALURes_B3, AddRes_B3, Read2_B3;
    wire ZF_B3, MemRead_B3, MemWrite_B3, MemToReg_B3, RegWrite_B3, Branch_B3;
    // Buffer 4
    wire [31:0] ReadMem_B4, ALURes_B4;
    wire MemToReg_B4, RegWrite_B4;
    wire [4:0] WriteReg_B4;

    // Program Counter
    PC pc_inst (
        .In(PCin),
        .Clk(Clk),
        .Out(PCout)
    );

    // Suma 4 al PC
    ADD4 add_inst (
        .A(PCout),
        .Res(PCnext)
    );

    // Multiplexor 1
    Mux2to1Param #(32) MUXPC (
        .Entrada0(PCnext_B3),
        .Entrada1(AddRes_B3),
        .Sel(Br_AND_ZF),    
        .Salida(PCin)
    );

    // Memoria de instrucciones
    MemI memi_inst (
        .DR(PCout),
        .INS(Instr)
    );
        
    // Buffer uno IF/ID    
    assign Cable_combinado1 = {Instr, PCnext};
    BF #(64) B1 (
        .IN(Cable_combinado1),
        .CLK(Clk),
        .OUT(Cable_salida1)
    );

    // Separamos las señales en el buffer 1
    assign Instr_B1   = Cable_salida1[63:32];
    assign PCnext_B1  = Cable_salida1[31:0];
        
    // Asignamos las variables de instruccion
    assign OpCode = Instr_B1[31:26];
    assign Rs     = Instr_B1[25:21];
    assign Rt     = Instr_B1[20:16];
    assign Rd     = Instr_B1[15:11];
    assign Funct  = Instr_B1[5:0];
        
    // Control
    UnidadDeControl UC (
        .OpCode(OpCode),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .ALUOp(ALUOp),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .Branch(Branch)
    );
        
    // Banco de registros
    BancoReg BR (
        .Clk(Clk),
        .RegEn(RegWrite_B4),
        .ReadReg1(Rs),
        .ReadReg2(Rt),
        .WriteReg(WriteReg_B4),
        .WriteData(WriteDataBr),
        .ReadData1(Read1),
        .ReadData2(Read2)
    );
        
    // Extensor de signo
    SignExtend SE (
        .Imm16(Instr_B1[15:0]),
        .Imm32(Extended)
    );
        
    // Buffer dos ID/EX
    assign Cable_combinado2 = {MemRead, MemToReg, MemWrite, RegWrite, RegDst, ALUSrc, Branch, ALUOp, Read1, Read2, Extended, Rt, Rd, PCnext_B1, Funct};
    BF #(154) B2 (
        .IN(Cable_combinado2), 
        .CLK(Clk), 
        .OUT(Cable_salida2)
    );

    // Separamos las señales en B2
    assign MemRead_B2      = Cable_salida2[153];
    assign MemToReg_B2     = Cable_salida2[152];
    assign MemWrite_B2     = Cable_salida2[151];
    assign RegWrite_B2     = Cable_salida2[150];
    assign RegDst_B2       = Cable_salida2[149];
    assign ALUSrc_B2       = Cable_salida2[148];
    assign Branch_B2       = Cable_salida2[147];

    assign ALUOp_B2        = Cable_salida2[146:144];

    assign Read1_B2        = Cable_salida2[143:112];
    assign Read2_B2        = Cable_salida2[111:80];
    assign Extended_B2     = Cable_salida2[79:48];

    assign Rt_B2           = Cable_salida2[47:43];
    assign Rd_B2           = Cable_salida2[42:38];

    assign PCnext_B2       = Cable_salida2[37:6];
    assign Funct_B2        = Cable_salida2[5:0];
        
    // Multiplexor 2
    Mux2to1Param #(5) MUXWR (
        .Entrada0(Rt_B2),
        .Entrada1(Rd_B2),
        .Sel(RegDst_B2),
        .Salida(WriteReg)
    );
        
    // ALU control
    ALUControl AC (
        .ALUOp(ALUOp_B2),
        .Funct(Funct_B2),
        .ALUCtl(AluCtrl)
    );
        
    // Multiplexor 3
    Mux2to1Param #(32) MUXAL (
        .Entrada0(Read2_B2),
        .Entrada1(Extended_B2), 
        .Sel(ALUSrc_B2),
        .Salida(OP2)
    );
        
    // ALU
    ALU alu (
        .Op1(Read1_B2),
        .Op2(OP2),
        .ALUCtl(AluCtrl),
        .Res(ALURes),
        .ZF(ZF)
    );
        
    // Shift left 2
    ShiftLeft2 SL2 (
        .In(Extended_B2),
        .Out(Shifted)
    );
        
    // AdderBranch
    AdderBranch AB (
        .PCplus4(PCnext_B2),
        .Shifted(Shifted),
        .PCBranch(AddRes)
    );
        
    // Buffer tres EX/MEM modificado:
    assign Cable_combinado3 = {PCnext_B2, WriteReg, ALURes, ZF, AddRes, MemRead_B2, MemWrite_B2, MemToReg_B2, RegWrite_B2, Read2_B2, Branch_B2};
    BF #(139) B3 (
        .IN(Cable_combinado3), 
        .CLK(Clk), 
        .OUT(Cable_salida3)
    );
        
    // Separamos las señales en B3
    assign PCnext_B3  = Cable_salida3[138:107];
    assign WriteReg_B3  = Cable_salida3[106:102];
    assign ALURes_B3    = Cable_salida3[101:70];
    assign ZF_B3        = Cable_salida3[69];
    assign AddRes_B3    = Cable_salida3[68:37];
    assign MemRead_B3   = Cable_salida3[36];
    assign MemWrite_B3  = Cable_salida3[35];
    assign MemToReg_B3  = Cable_salida3[34];
    assign RegWrite_B3  = Cable_salida3[33];
    assign Read2_B3     = Cable_salida3[32:1];
    assign Branch_B3    = Cable_salida3[0];
        
    // AND para branch y flag zero
    assign Br_AND_ZF = ZF_B3 & Branch_B3;
        
    // MemDatos
    MemDatos MD (
        .Clk(Clk),
        .MemWrite(MemWrite_B3),
        .MemRead(MemRead_B3),
        .Address(ALURes_B3),
        .WriteData(Read2_B3),
        .ReadData(ReadMem)
    );
        
    // Buffer cuatro MEM/WB
    assign Cable_combinado4 = {ReadMem, MemToReg_B3, RegWrite_B3, WriteReg_B3, ALURes_B3};
    BF #(71) B4 (
        .IN(Cable_combinado4), 
        .CLK(Clk), 
        .OUT(Cable_salida4)
    );
        
    // Separamos las señales en B4
    assign ReadMem_B4   = Cable_salida4[70:39];
    assign MemToReg_B4  = Cable_salida4[38];
    assign RegWrite_B4  = Cable_salida4[37];
    assign WriteReg_B4  = Cable_salida4[36:32];
    assign ALURes_B4    = Cable_salida4[31:0];
        
    // Multiplexor 4
    Mux2to1Param #(32) MUXWD (
        .Entrada0(ALURes_B4),
        .Entrada1(ReadMem_B4),
        .Sel(MemToReg_B4),
        .Salida(WriteDataBr)
    );

endmodule