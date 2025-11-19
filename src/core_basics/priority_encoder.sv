module priority_encoder #(
   parameter int INPUT_LINES = 4 ,
   parameter int OUTPUT_LINES = $clog2(INPUT_LINES) 
)  (
    input logic [INPUT_LINES - 1:0] data,
    output logic [OUTPUT_LINES - 1:0] out,
    output logic valid
);

initial begin
    if (INPUT_LINES < 2) begin
        $error("INPUT_LINES must be >= 2. Got %0d", INPUT_LINES);
    end
end


always_comb begin
    valid = 0;
    out = '0; // default value

    logic flag = 1;

    for (int i = INPUT_LINES - 1; i >= 0 && flag; i--) begin
        if (data[i]) begin
            out = i[OUTPUT_LINES - 1:0];
            valid = 1;
            flag = 0;
            // break; //using flag until icarus stops complaining about this
        end
    end
end
     
endmodule