module SignExtend(
  input  wire [15:0] Imm16,
  output reg  [31:0] Imm32
);

// El operador {} replica el bit de signo 16 veces y se concatena con Imm16
always @(*) Imm32 = {{16{Imm16[15]}}, Imm16};

endmodule

