`timescale 1ns / 1ps

module tb_ALU;

  // Señales de prueba
  reg  [31:0] Op1;
  reg  [31:0] Op2;
  reg  [2:0]  ALUCtl;
  wire [31:0] Res;
  wire        ZF;

  // Instanciación del DUT
  ALU uut (
    .Op1(Op1),
    .Op2(Op2),
    .ALUCtl(ALUCtl),
    .Res(Res),
    .ZF(ZF)
  );

  initial begin
    // Caso 1: AND
    ALUCtl = 3'b000; // AND
    Op1     = 32'b10101010101010101010101010101010;
    Op2     = 32'b11001100110011001100110011001100;
    #10;

    // Caso 2: OR
    ALUCtl = 3'b001; // OR
    Op1     = 32'b00001111000011110000111100001111;
    Op2     = 32'b00110011001100110011001100110011;
    #10;

    // Caso 3: ADD
    ALUCtl = 3'b010; // ADD
    Op1     = 32'b00000000000000000000000000000101; // 5
    Op2     = 32'b00000000000000000000000000000110; // 6
    #10;

    // Caso 4: SUB
    ALUCtl = 3'b110; // SUB
    Op1     = 32'b00000000000000000000000000001000; // 8
    Op2     = 32'b00000000000000000000000000000101; // 5
    #10;

    // Caso 5: SLT
    ALUCtl = 3'b111; // SLT
    Op1     = 32'b00000000000000000000000000000100; // 4
    Op2     = 32'b00000000000000000000000000001000; // 8
    #10;

    // Caso 6: BGTZ (Op1 > 0?)
    ALUCtl = 3'b100; // BGTZ
    Op1     = 32'b11111111111111111111111111111111; // -1 (signed)
    Op2     = 32'b00000000000000000000000000000000; // no usado
    #10;
    ALUCtl = 3'b100; // BGTZ
    Op1     = 32'b00000000000000000000000000001010; // 10
    #10;

    // Caso 7: NOP
    ALUCtl = 3'b011; // NOP
    Op1     = 32'b00000000000000000000000000000000;
    Op2     = 32'b00000000000000000000000000000000;
    #10;

    // Fin de simulación
    $finish;
  end

endmodule
