`timescale 1ns / 1ps

module tb_SignExtend;
    // Señales de prueba
    reg  [15:0] Imm16;
    wire [31:0] Imm32;

    // Instanciación del módulo bajo prueba
    SignExtend uut (
        .Imm16(Imm16),
        .Imm32(Imm32)
    );

    initial begin

        // Vector de pruebas
        #10 Imm16 = 16'b0000_0000_0000_1010; // +10
        #10 Imm16 = 16'b0000_0000_1001_0001; // +145
        #10 Imm16 = 16'b1000_0000_0000_0000; // -32768
        #10 Imm16 = 16'b1111_1111_1111_1010; // -6
        #10 Imm16 = 16'b0111_1111_1111_1111; // +32767
        #10 Imm16 = 16'b1000_0000_0000_0001; // -32767

        #10 $finish;
    end
endmodule

