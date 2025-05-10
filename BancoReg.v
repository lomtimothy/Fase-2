module BancoReg(
    input  wire        Clk,
    input  wire        RegEn,
    input  wire [4:0]  ReadReg1,
    input  wire [4:0]  ReadReg2,
    input  wire [4:0]  WriteReg,
    input  wire [31:0] WriteData,
    output reg  [31:0] ReadData1,
    output reg  [31:0] ReadData2
);

reg [31:0]Mem[0:31];
    
initial begin
	$readmemb("Bdatos", Mem); 
end
	
// Escritura sincrona
always @(posedge Clk) begin
	if (RegEn)
		Mem[WriteReg] <= WriteData;
end

// Lectura combinacional
always @(*) begin
	ReadData1 = Mem[ReadReg1];
	ReadData2 = Mem[ReadReg2];
end

endmodule

