`timescale 1ns/1ps

module priority_encoder_tb;

    // =============================================================
    //  Parameter Sweep (change INPUT_LINES here)
    // =============================================================
    parameter int INPUT_LINES  = 8;
    parameter int OUTPUT_LINES = $clog2(INPUT_LINES);

    // =============================================================
    //  DUT Signals
    // =============================================================
    logic [INPUT_LINES-1:0] data;
    logic [OUTPUT_LINES-1:0] out;
    logic valid;

    // =============================================================
    //  Instantiate DUT
    // =============================================================
    priority_encoder #(
        .INPUT_LINES(INPUT_LINES),
        .OUTPUT_LINES(OUTPUT_LINES)
    ) dut (
        .data(data),
        .out(out),
        .valid(valid)
    );

    // =============================================================
    //  Reference Model (Golden Model)
    // =============================================================
    function automatic int ref_encode(input logic [INPUT_LINES-1:0] x);
        ref_encode = -1;  // -1 means "no valid bits"
        for (int i = INPUT_LINES - 1; i >= 0; i--) begin
            if (x[i]) return i;
        end
    endfunction

    // =============================================================
    //  Compare DUT vs Reference Model
    // =============================================================
    task automatic check(input logic[INPUT_LINES-1:0] d);
        int expected_idx;
        logic expected_valid;

        data = d;
        #1;

        expected_idx   = ref_encode(d);
        expected_valid = (expected_idx != -1);

        // Output check
        if (expected_valid)
            assert(out == expected_idx[OUTPUT_LINES-1:0])
                else $error("Mismatch: data=%b expected_idx=%0d got_out=%0d",
                            d, expected_idx, out);

        // Valid check
        assert(valid == expected_valid)
            else $error("Valid mismatch: data=%b expected_valid=%0b got_valid=%0b",
                        d, expected_valid, valid);

        $display("[PASS] data=%b → out=%0d valid=%0b",
                 d, out, valid);
    endtask

    // =============================================================
    //  Main stimulus process
    // =============================================================
    initial begin
        $dumpfile("sim/waves/priority_encoder.vcd");
        $dumpvars(0, priority_encoder_tb);

        $display("\n=== Running Parameterized Priority Encoder Testbench ===");
        $display("INPUT_LINES = %0d, OUTPUT_LINES = %0d\n",
                  INPUT_LINES, OUTPUT_LINES);

        // ------------------------------------------
        // Always test the all-zero case
        // ------------------------------------------
        $display("Testing all-zero case...");
        check('0);

        // ------------------------------------------
        // Exhaustive testing for small N
        // ------------------------------------------
        if (INPUT_LINES <= 8) begin
            $display("Running exhaustive test for %0d-bit encoder...", INPUT_LINES);
            for (int i = 0; i < (1 << INPUT_LINES); i++) begin
                check(i[INPUT_LINES-1:0]);
            end
        end else begin
            // ------------------------------------------
            // Randomized testing for large N
            // ------------------------------------------
            $display("Running randomized tests for large encoder...");
            for (int j = 0; j < 200; j++) begin
                check($urandom());
            end

            // Directed tests
            check('1);                 // all ones
            check({1'b1, '0});        // MSB set
            check({1'b0, '1});        // LSB set
            check({1'b1, 1'b0, '1});  // MSB and LSB set
        end

        $display("\n=== TESTBENCH COMPLETED SUCCESSFULLY ===");
        $finish;
    end

endmodule
