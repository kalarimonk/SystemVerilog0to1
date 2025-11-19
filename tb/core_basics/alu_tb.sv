`timescale 1ns/1ps

/**
 * @module alu_tb
 * @brief Testbench for Arithmetic Logic Unit (ALU)
 * 
 * Tests all ALU operations with multiple test cases including:
 * - Basic operations (add, sub, and, or, xor)
 * - Edge cases (zero, max values, overflow)
 * - Output verification with assertions
 * 
 * @author SystemVerilog Learning
 * @date 2025-11-13
 */
module alu_tb;
    // Test parameters
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    
    // Testbench signals
    logic [7:0] a, b;           // ALU inputs
    logic [2:0] op;             // Operation selector
    logic [7:0] y;              // ALU output
    logic [7:0] expected;       // Expected result for verification
    int test_count = 0;         // Number of tests run
    int pass_count = 0;         // Number of passed tests
    int fail_count = 0;         // Number of failed tests

    // DUT instantiation with named port mapping
    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .y(y)
    );

    /**
     * @task test_operation
     * @brief Helper task to test a specific operation
     * @param test_a First operand
     * @param test_b Second operand
     * @param test_op Operation to perform
     * @param expected_result Expected output
     * @param test_name Description of test
     */
    task test_operation(
        logic [7:0] test_a,
        logic [7:0] test_b,
        logic [2:0] test_op,
        logic [7:0] expected_result,
        string test_name
    );
        a = test_a;
        b = test_b;
        op = test_op;
        #10;  // Wait for combinational logic to settle
        
        test_count++;
        
        if (y == expected_result) begin
            pass_count++;
            $display("[PASS] Test %0d: %s | a=%0d, b=%0d, op=%3b, result=%0d, expected=%0d", 
                     test_count, test_name, test_a, test_b, test_op, y, expected_result);
        end else begin
            fail_count++;
            $display("[FAIL] Test %0d: %s | a=%0d, b=%0d, op=%3b, result=%0d, expected=%0d", 
                     test_count, test_name, test_a, test_b, test_op, y, expected_result);
        end
        
        // Assertions for additional verification
        assert (y == expected_result) 
            else $error("Mismatch in %s: got %0d, expected %0d", test_name, y, expected_result);
    endtask

    initial begin
        // Setup waveform dumping
        $dumpfile("sim/waves/alu.vcd");
        $dumpvars(0, alu_tb);
        
        $display("\n========================================");
        $display("  ALU Testbench - Comprehensive Testing");
        $display("========================================\n");

        // ===== Test Group 1: Basic Operations =====
        $display("Test Group 1: Basic Operations");
        $display("------------------------------");
        test_operation(8'd10, 8'd5, ADD, 8'd15, "Basic ADD");
        test_operation(8'd10, 8'd5, SUB, 8'd5,  "Basic SUB");
        test_operation(8'd10, 8'd5, AND, 8'd0,  "Basic AND (1010 & 0101 = 0000)");
        test_operation(8'd10, 8'd5, OR,  8'd15, "Basic OR  (1010 | 0101 = 1111)");
        test_operation(8'd10, 8'd5, XOR, 8'd15, "Basic XOR (1010 ^ 0101 = 1111)");

        // ===== Test Group 2: Zero Operations =====
        $display("\nTest Group 2: Zero Operations");
        $display("------------------------------");
        test_operation(8'd0, 8'd0, ADD, 8'd0, "ADD with zeros");
        test_operation(8'd0, 8'd5, ADD, 8'd5, "ADD zero + value");
        test_operation(8'd5, 8'd0, SUB, 8'd5, "SUB value - zero");
        test_operation(8'd0, 8'd0, AND, 8'd0, "AND with zeros");
        test_operation(8'd0, 8'd0, OR,  8'd0, "OR with zeros");
        test_operation(8'd0, 8'd0, XOR, 8'd0, "XOR with zeros");

        // ===== Test Group 3: Maximum Values =====
        $display("\nTest Group 3: Maximum Values");
        $display("------------------------------");
        test_operation(8'hFF, 8'hFF, ADD, 8'hFE, "ADD overflow (255+255=510, wraps to 254)");
        test_operation(8'hFF, 8'h00, SUB, 8'hFF, "SUB 255-0=255");
        test_operation(8'hFF, 8'hFF, AND, 8'hFF, "AND all ones");
        test_operation(8'hFF, 8'hFF, OR,  8'hFF, "OR all ones");
        test_operation(8'hFF, 8'hFF, XOR, 8'h00, "XOR identical (255^255=0)");

        // ===== Test Group 4: Bitwise Operations =====
        $display("\nTest Group 4: Bitwise Operations");
        $display("--------------------------------");
        test_operation(8'b10101010, 8'b01010101, AND, 8'b00000000, "AND complementary patterns");
        test_operation(8'b10101010, 8'b01010101, OR,  8'b11111111, "OR complementary patterns");
        test_operation(8'b10101010, 8'b01010101, XOR, 8'b11111111, "XOR complementary patterns");
        test_operation(8'b11001100, 8'b00110011, XOR, 8'b11111111, "XOR another pattern");

        // ===== Test Group 5: Single Bit Operations =====
        $display("\nTest Group 5: Single Bit Operations");
        $display("-----------------------------------");
        test_operation(8'b00000001, 8'b00000001, ADD, 8'b00000010, "ADD single bits");
        test_operation(8'b10000000, 8'b10000000, OR,  8'b10000000, "OR MSB set");
        test_operation(8'b00000001, 8'b00000000, XOR, 8'b00000001, "XOR with LSB");

        // ===== Test Group 6: Invalid Operation Code =====
        $display("\nTest Group 6: Invalid Operation Code");
        $display("------------------------------------");
        test_operation(8'd10, 8'd5, 3'b101, 8'd0, "Invalid op (101) - should return 0");
        test_operation(8'd10, 8'd5, 3'b110, 8'd0, "Invalid op (110) - should return 0");
        test_operation(8'd10, 8'd5, 3'b111, 8'd0, "Invalid op (111) - should return 0");

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
