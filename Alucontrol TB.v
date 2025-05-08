`timescale 1ns / 1ps

module tb_ALUControl;

  // Señales de prueba
  reg  [2:0]  ALUOp;
  reg  [5:0]  Funct;
  wire [2:0]  ALUCtl;

  // Instanciación del DUT
  ALUControl uut (
    .ALUOp  (ALUOp),
    .Funct  (Funct),
    .ALUCtl (ALUCtl)
  );

  initial begin
    
    // 1) ADDI/LW/SW (ALUOp=000)
    ALUOp = 3'b000; Funct = 6'bxxxxxx; #5;

    // 2) BEQ/BNE (ALUOp=001)
    ALUOp = 3'b001; Funct = 6'bxxxxxx; #5;

    // 3) R-type (ALUOp=010)
    ALUOp = 3'b010;
    Funct = 6'b100000; #5; // ADD
    Funct = 6'b100010; #5; // SUB
    Funct = 6'b100100; #5; // AND
    Funct = 6'b100101; #5; // OR
    Funct = 6'b101010; #5; // SLT
    Funct = 6'b000000; #5; // NOP

    // 4) ANDI (ALUOp=100)
    ALUOp = 3'b100; Funct = 6'bxxxxxx; #5;

    // 5) ORI (ALUOp=101)
    ALUOp = 3'b101; Funct = 6'bxxxxxx; #5;

    // 6) SLTI (ALUOp=111)
    ALUOp = 3'b111; Funct = 6'bxxxxxx; #5;

    // 7) BGTZ (ALUOp=110)
    ALUOp = 3'b110; Funct = 6'bxxxxxx; #5;

    // 8) Default (ALUOp=011)
    ALUOp = 3'b011; Funct = 6'bxxxxxx; #5;

    $finish;
  end

endmodule


