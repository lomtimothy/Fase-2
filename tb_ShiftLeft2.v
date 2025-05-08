`timescale 1ns / 1ps

module tb_ShiftLeft2;

  // Entradas y salidas
  reg  [31:0] In;
  wire [31:0] Out;

  // Instanciación del DUT (Device Under Test)
  ShiftLeft2 uut (
    .In(In),
    .Out(Out)
  );

  initial begin

    // Vectores de prueba
    In = 32'b00000000000000000000000000000001;  // 1 -> 4
    #5;
    In = 32'b00000000000000000000000000000010;  // 2 -> 8
    #5;
    In = 32'b00000000000000000000000000001111;  // 15 -> 60
    #5;
    In = 32'b11110000111100001111000011110000;  // prueba de patrón
    #5;
    In = 32'b10101010101010101010101010101010;  // prueba de alternancia
    #5;

    // Fin de la simulación
    $finish;
  end

endmodule

