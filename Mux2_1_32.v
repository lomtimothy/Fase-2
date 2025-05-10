module Mux2to1Param#(parameter WIDTH = 32)(
    input  wire [WIDTH-1:0] Entrada0,
    input  wire [WIDTH-1:0] Entrada1,
    input  wire             Sel,
    output reg  [WIDTH-1:0] Salida
);

always @(*) begin
	Salida = Sel ? Entrada1 : Entrada0;
end

endmodule
