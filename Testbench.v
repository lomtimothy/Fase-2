module DPTR_tb;
// Señales del testbench
    reg         Clk;
    wire [31:0] PCout;
    wire [31:0] Instr;

// Instanciación de la DUT
DPTR DUT (
	.Clk(Clk),
    .PCout(PCout),
    .Instr(Instr)
);

// Generación del reloj: periodo de 10 ns
initial begin
    Clk = 0;
	forever #10 Clk = ~Clk;
end
	
initial begin
    #1800; 
    $stop;
end
endmodule
