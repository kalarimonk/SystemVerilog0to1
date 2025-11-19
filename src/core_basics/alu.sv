module alu #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a, b, // Input ports
    input  logic [2:0] op,         // 000:add, 001:sub, 010:and, 011:or, 100:xor
    output logic [WIDTH-1:0] y
);

    always_comb begin
        unique case (op)
            3'b000: y = a + b;
            3'b001: y = a - b;
            3'b010: y = a & b;
            3'b011: y = a | b;
            3'b100: y = a ^ b;
            default: y = '0;
        endcase
    end

        // Simulation-only assertion block
    `ifndef SYNTHESIS
        always_comb begin
            assert (op <= 3'b100)
                else $error("Invalid operation code: %0b", op);
        end
    `endif
endmodule
