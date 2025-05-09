`timescale 1ns / 1ps

module tb_UnidadDeControl;

  // Señales de prueba
  reg  [5:0] OpCode;
  wire       RegDst;
  wire       Branch;
  wire       MemRead;
  wire       MemToReg;
  wire [2:0] ALUOp;
  wire       MemWrite;
  wire       ALUSrc;
  wire       RegWrite;

  // Instanciación del DUT
  UnidadDeControl uut (
    .OpCode   (OpCode),
    .RegDst   (RegDst),
    .Branch   (Branch),
    .MemRead  (MemRead),
    .MemToReg (MemToReg),
    .ALUOp    (ALUOp),
    .MemWrite (MemWrite),
    .ALUSrc   (ALUSrc),
    .RegWrite (RegWrite)
  );

  initial begin

    // R-type (000000)
    OpCode = 6'b000000; #5;

    // addi (001000)
    OpCode = 6'b001000; #5;

    // ori (001101)
    OpCode = 6'b001101; #5;

    // andi (001100)
    OpCode = 6'b001100; #5;

    // slti (001010)
    OpCode = 6'b001010; #5;

    // lw (100011)
    OpCode = 6'b100011; #5;

    // sw (101011)
    OpCode = 6'b101011; #5;

    // beq (000100)
    OpCode = 6'b000100; #5;

    // bne (000101)
    OpCode = 6'b000101; #5;

    // bgtz (000111)
    OpCode = 6'b000111; #5;

    $finish;
  end

endmodule


