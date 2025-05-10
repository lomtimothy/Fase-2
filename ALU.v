module ALU(
    input  wire [31:0] Op1,
    input  wire [31:0] Op2,
    input  wire [2:0]  ALUCtl,    // Lee del ALUControl
    output reg  [31:0] Res,
    output wire        ZF
);

always @(*) begin
    case (ALUCtl)
        3'b000: Res = Op1 & Op2;                      // AND
        3'b001: Res = Op1 | Op2;                      // OR
        3'b010: Res = Op1 + Op2;                      // ADD
        3'b110: Res = Op1 - Op2;                      // SUB
        3'b111: Res = (Op1 < Op2) ? 32'd1 : 32'd0;    // SLT
        3'b100: Res = ($signed(Op1) > 0) ? 32'd0 : 32'd1; // para que "cero" signifique salto
        3'b011: Res = 32'd0;                          // NOP
        default: Res = 32'd0;
    endcase
end

assign ZF = (Res == 32'd0);

endmodule
