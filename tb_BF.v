`timescale 1ns / 1ps

module tb_BF;

  // Parámetros y señales
  localparam WIDTH = 32;
  reg  [WIDTH-1:0] IN;
  reg             CLK;
  wire [WIDTH-1:0] OUT;

  // Instanciación del DUT
  BF #(
    .WIDTH(WIDTH)
  ) uut (
    .IN(IN),
    .CLK(CLK),
    .OUT(OUT)
  );

  // Generación de reloj: periodo 10ns
  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
  end

  initial begin

    // Vectores de prueba: aplicados en flanco de reloj
    IN = 32'b00000000000000000000000000000001;  // 1
    #10;
    IN = 32'b00000000000000000000000000000010;  // 2
    #10;
    IN = 32'b00000000000000000000000000001111;  // 15
    #10;
    IN = 32'b11110000111100001111000011110000;  // patrón
    #10;
    IN = 32'b10101010101010101010101010101010;  // alternancia
    #10;

    // Fin de simulación
    $finish;
  end

endmodule
