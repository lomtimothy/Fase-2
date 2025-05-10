module MemDatos(
    input  wire        Clk,
	input  wire        MemWrite,
	input  wire		   MemRead,
    input  wire [31:0] Address,
    input  wire [31:0] WriteData,
    output reg  [31:0] ReadData
);

reg [31:0]Mem[0:127];

//Leemos el archivo
initial begin 
	$readmemb("Mdatos", Mem); 
end
	
// Lectura combinacional
always @(*) begin
	if(MemRead)
	ReadData = Mem[Address];
end

// Escritura síncrona
always @(posedge Clk) begin
	if (MemWrite)
		Mem[Address] <= WriteData;
end

endmodule
