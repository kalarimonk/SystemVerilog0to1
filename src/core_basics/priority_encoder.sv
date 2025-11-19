module priority_encoder (
    input logic [3:0] data,
    output logic [1:0] out
);

// `casez` uses ?? which means don't care, however It doesn’t treat X (unknown) as a match → safer 
//  This 4'b1??? matches 4'b1100 or 4'b1010 or even 4'b1Z10 but not 4'b1X10

always_comb begin
    casez (data)    
        4'b1???: out = 2'b11;
        4'b01??: out = 2'b10;
        4'b001?: out = 2'b01;
        4'b0001: out = 2'b00;
        default: out = 2'b00;
    endcase
end
     
endmodule