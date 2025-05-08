module DPTR (
    input  wire        Clk,
	output wire [31:0] Instr,
	output wire [31:0] PCout
);

// Buses internos
    wire [31:0] PCin, PCnext;
    wire [5:0]  OpCode = Instr[31:26];
    wire [4:0]  Rs     = Instr[25:21];
    wire [4:0]  Rt     = Instr[20:16];
    wire [4:0]  Rd     = Instr[15:11];
    wire [5:0]  Funct  = Instr[5:0];

// Señales de control
    wire MemToReg, MemToWrite, RegWrite, RegDst, 
	MemRead, ALUSrc, Branch, ZF, Br_AND_ZF;
    wire [2:0]  ALUOp;

// Más buses internos
    wire [31:0] Read1, Read2, Res, ReadMem, WriteData, OP2;
    wire [2:0]  AluCtrl;
    wire [4:0]  WriteReg;

// Program Counter
    PC pc_inst (
        .IN(PCin),
        .Clk(Clk),
        .OUT(PCout)
    );

// Suma 4 al PC
    ADD4 add_inst (
        .A(PCout),
        .RES(PCnext)
    );
	
// Multiplexor 1
   Mux2to1Param #(.WIDTH(32)) MUXPC (
    .entrada0(PCnext),
    .entrada1(32'b0),		// Dirección de salto
    .sel(Br_AND_ZF),	
    .salida(PCin)
);

// Memoria de instrucciones
    MEMI memi_inst (
        .DR(PCout),
        .INS(Instr)
    );
	
// Control
    UnidadDeControl UC(
        .OpCode(OpCode),
		.MemRead(),			// Conectado a modulo aun inexistente
        .MemToReg(MemToReg),
        .MemToWrite(MemToWrite),
        .ALUOp(ALUOp),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
		.Branch(Branch)
    );
	
// Multiplexor 2
    Mux2to1Param #(.WIDTH(5)) MUXWR (
    .entrada0(Rt),
    .entrada1(Rd),
    .sel(RegDst),
    .salida(WriteReg)
	);
	
	
// Banco de registros
    BancoReg BR(
        .Clk(Clk),
        .RegEn(RegWrite),
        .ReadReg1(Rs),
        .ReadReg2(Rt),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
        .ReadData1(Read1),
        .ReadData2(Read2)
    );
	
	
// ALU control
    ALuControl AC(
        .ALUOp(ALUOp),
        .Funct(Funct),
        .ALUCtl(AluCtrl)
    );
	
// Multiplexor 3
    Mux2to1Param #(.WIDTH(32)) MUXAL (
        .entrada0(Read2),
        .entrada1(32'b0),	// Inmediato con extensión de signo  
        .sel(ALUSrc),
        .salida(OP2)
	);	
	
// ALU
    ALU alu(
        .OP1(Read1),
        .OP2(OP2),
        .ALUCtl(AluCtrl),
        .Res(Res),
        .ZF(ZF)
    );
	
// Agregamos el and que une branch y zflag
assign Br_AND_ZF = ZF & Branch;
	
// --- NO UTILIZADO PARA TIPO R ---	
// MemDatos
    MemDatos MD(
        .Clk(Clk),
        .MemToWrite(MemToWrite),
        .Address(Res),
        .WriteData(Read2),
        .ReadData(ReadMem)
    );
	
// Multiplexor 4
	Mux2to1Param #(.WIDTH(32)) MUXWD (
    .entrada0(Res),
    .entrada1(ReadMem),
    .sel(MemToReg),
    .salida(WriteData)
	);

endmodule

