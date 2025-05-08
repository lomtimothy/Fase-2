module ADD4(
    input [31:0] A,
    output reg [31:0] Res
);

// En esta ocasión solo sumaremos 4 cada vez, esto para guardar en múltiplos de 4 en la memoria
always @(*) begin
    Res = A + 32'd4;
end

endmodule
