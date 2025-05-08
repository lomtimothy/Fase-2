module MemI(
    input [31:0] DR,		// Dirección
    output reg [31:0] INS	// Instruccion de salida
);

reg [7:0]Mem[0:999];    	// 1000 posiciones que guardan datos de 1 byte

// Leemos el archivo
initial begin
    $readmemb("instrucciones", Mem);
end

// Asignamos
always @(*) begin
	// Recorremos 4 posiciones para obtener los 32 bits
    INS[31:24] = Mem[DR];
    INS[23:16] = Mem[DR + 1];
    INS[15:8]  = Mem[DR + 2];
    INS[7:0]   = Mem[DR + 3];
end

endmodule
