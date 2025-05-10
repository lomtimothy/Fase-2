module ALUControl(
    input  wire [2:0] ALUOp,
    input  wire [5:0] Funct,
    output reg  [2:0] ALUCtl
);

always @(*) begin
    case (ALUOp)
        3'b000: ALUCtl = 3'b010; // ADD (para addi, lw, sw)
        3'b001: ALUCtl = 3'b110; // SUB	(para beq, bne)
		
		// Instrucciones tipo R
        3'b010: begin 
            case (Funct)
                6'b100000: ALUCtl = 3'b010; // ADD
                6'b100010: ALUCtl = 3'b110; // SUB
                6'b100100: ALUCtl = 3'b000; // AND
                6'b100101: ALUCtl = 3'b001; // OR
                6'b101010: ALUCtl = 3'b111; // SLT
                6'b000000: ALUCtl = 3'b011; // NOP
            endcase
        end
	
        3'b100: ALUCtl = 3'b000; // AND (para andi)
        3'b101: ALUCtl = 3'b001; // OR  (para ori)
        3'b110: ALUCtl = 3'b100; // BGTZ (usa > 0, necesitas extender esto en la ALU real)
		3'b111: ALUCtl = 3'b111; // SLT (slti)
        default: ALUCtl = 3'b011; // NOP / default
    endcase
end

endmodule
