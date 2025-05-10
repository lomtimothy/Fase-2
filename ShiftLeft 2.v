module ShiftLeft2(
  input  wire [31:0] In,
  output wire [31:0] Out
);

// Hacemos un recorrido concatenando dos bits 0
// Con ello multiplicamos x4 en binario
assign Out = {In[29:0], 2'b00};

endmodule
