module AdderBranch(
  input  wire [31:0] PCplus4,
  input  wire [31:0] Shifted,
  output wire [31:0] PCBranch
);

assign PCBranch = PCplus4 + Shifted;
  
endmodule
