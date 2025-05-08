module SignExtend(
    input  wire [15:0] Imm16,
    output reg  [31:0] Imm32
);

always @(*) 
    Imm32 = {{16{Imm16[15]}}, Imm16};
    
endmodule

