
FILE_NAME=$1
FILE_NAME=${FILE_NAME/.sv/}
SRC_DIR=core_basics

echo "Running testbench for ${FILE_NAME}..."


mkdir -p sim/waves sim/logs
iverilog -g2012 -o sim/${FILE_NAME}_tb.out src/${SRC_DIR}/${FILE_NAME}.sv tb/${SRC_DIR}/${FILE_NAME}_tb.sv
vvp sim/${FILE_NAME}_tb.out | tee sim/logs/${FILE_NAME}.log
# surfer sim/waves/alu.vcd &