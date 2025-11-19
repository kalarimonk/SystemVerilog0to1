
module mux4to1_tb;

    // Inputs
    logic a;
    logic b;
    logic c;
    logic d;
    logic [1:0]sel;

    // Output
    logic y;
    logic expected;

    int test_count = 0;         // Number of tests run
    int pass_count = 0;         // Number of passed tests
    int fail_count = 0;        // Number of failed tests

    // Instantiate the Unit Under Test (UUT)
    mux4to1 uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .y(y)
    );

    initial begin
    $dumpfile("sim/waves/mux4to1.vcd");
    $dumpvars(0, mux4to1_tb);

    $display("\n========================================");
    $display("  Running MUX4to1 Testbench");
    $display("========================================");


    for (int i = 0; i < 64; i++) begin
        // Unpack bits: {a, b, c, d, sel[1], sel[0]}
        // {a, b, c, d, sel} = i; // fails for icarus verilog simulator

        a   = i[5];
        b   = i[4];
        c   = i[3];
        d   = i[2];
        sel = i[1:0];

        
        case (sel)
            2'b00: expected = a;
            2'b01: expected = b;
            2'b10: expected = c;
            2'b11: expected = d;
        endcase

        #5;

        if (y !== expected) begin
            $display("[FAIL] i=%0d | a=%0b b=%0b c=%0b d=%0b sel=%02b | y=%0b expected=%0b",
                     i, a, b, c, d, sel, y, expected);
            fail_count++;
        end else begin
            $display("[PASS] i=%0d | a=%0b b=%0b c=%0b d=%0b sel=%02b | y=%0b",
                     i, a, b, c, d, sel, y);
            pass_count++;
        end
        
        test_count++;
        assert (y == expected)
            else $error("Assertion failed: a=%0b b=%0b c=%0b d=%0b sel=%02b | y=%0b expected=%0b",
                        a, b, c, d, sel, y, expected);
    end
        // ===== Summary Report =====
        $display("\n========================================");
        $display("  Test Summary");
        $display("========================================");
        $display("Total Tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        $display("Success Rate: %0.1f%%", (pass_count * 100.0) / test_count);
        $display("========================================\n");

        if (fail_count == 0) begin
            $display("✓ All tests PASSED!");
        end else begin
            $display("✗ %0d test(s) FAILED!", fail_count);
        end
        $finish;
    end
endmodule