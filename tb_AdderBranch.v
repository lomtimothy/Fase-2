`timescale 1ns / 1ps

module tb_AdderBranch;

  // Entradas y salidas
  reg  [31:0] PCplus4;
  reg  [31:0] Shifted;
  wire [31:0] PCBranch;

  // Instanciación del DUT (Device Under Test)
  AdderBranch uut (
    .PCplus4(PCplus4),
    .Shifted(Shifted),
    .PCBranch(PCBranch)
  );

  initial begin
  
    // Vectores de prueba
    // 1) Suma simple: 4 + 8 = 12
    PCplus4 = 32'b00000000000000000000000000000100;  // 4
    Shifted = 32'b00000000000000000000000000001000;  // 8
    #5;

    // 2) Suma con diferentes bits
    PCplus4 = 32'b00000000000000000000000000010010;  // 18
    Shifted = 32'b00000000000000000000000000000110;  // 6
    #5;

    // 3) Suma con carry a bit alto
    PCplus4 = 32'b11111111111111111111111111111111;  // -1 (2's complement)
    Shifted = 32'b00000000000000000000000000000001;  // 1
    #5;

    // 4) Suma de patrones
    PCplus4 = 32'b10101010101010101010101010101010;
    Shifted = 32'b01010101010101010101010101010101;
    #5;

    // Fin de la simulación
    $finish;
  end

endmodule

