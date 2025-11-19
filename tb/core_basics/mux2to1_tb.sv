`timescale 1ns/1ps

module mux2to1_tb;

    // Inputs
    logic a;
    logic b;
    logic sel;

    // Output
    logic y;

    int test_count = 0;         // Number of tests run
    int pass_count = 0;         // Number of passed tests
    int fail_count = 0;        // Number of failed tests

    // Instantiate the Unit Under Test (UUT)
    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    task test_case(
        input logic test_a,
        input logic test_b,
        input logic test_sel,
        input logic expected_y,
        input string case_name
    );
        a = test_a;
        b = test_b;
        sel = test_sel;
        #10; // Wait for combinational logic to settle

        test_count++;

        if (y == expected_y) begin
            pass_count++;
            $display("[PASS] Test %0d: %s | a=%0b, b=%0b, sel=%0d, result=%0b, expected=%0b", 
                     test_count, case_name, test_a, test_b, test_sel, y, expected_y);
        end else begin
            fail_count++;
            $display("[FAIL] Test %0d: %s | a=%0b, b=%0b, sel=%0d, result=%0b, expected=%0b", 
                     test_count, case_name, test_a, test_b, test_sel, y, expected_y);
        end
        assert (y == expected_y) else $error("%s Mismatch: y=%b, expected=%b", case_name, y, expected_y);
    endtask

    initial begin
        $dumpfile("sim/waves/mux2to1.vcd");
        $dumpvars(0, mux2to1_tb);
        
        $display("\n========================================");
        $display("  Running MUX2to1 Testbench");
        $display("========================================");
        
        test_case(0, 0, 0, 0, "Case 1");
        test_case(0, 0, 1, 0, "Case 2");
        test_case(0, 1, 0, 0, "Case 3");
        test_case(0, 1, 1, 1, "Case 4");
        test_case(1, 0, 0, 1, "Case 5");
        test_case(1, 0, 1, 0, "Case 6");
        test_case(1, 1, 0, 1, "Case 7");
        test_case(1, 1, 1, 1, "Case 8");

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