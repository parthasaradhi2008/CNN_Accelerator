module mac #(
    parameter W_bits=8,
    parameter acc_bits=32
)(
    input clk,rst_n,en,clear,
    input  [W_bits-1:0] w,a,
    output reg signed [acc_bits-1:0] acc
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) acc<={acc_bits{1'b0}};
    else if (clear) acc<={acc_bits{1'b0}};
    else if (en) acc<=acc+w*a;
end
endmodule