module PC(
    input [31:0] In,
    input Clk,
    output reg [31:0] Out = 32'd0   // Inicializado a 0
);

always @(posedge Clk) begin
    Out = In;
end	

endmodule
