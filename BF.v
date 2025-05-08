module BF #(parameter WIDTH = 32) (
    input [WIDTH-1:0] IN,
    input CLK,
    output reg [WIDTH-1:0] OUT
);

always @(posedge CLK) begin	// Cada positivo en el reloj
	OUT <= IN;	// Utilizamos <= para las distintas asignaciones en paralelo
end

endmodule

