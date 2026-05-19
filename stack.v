module stack #(
    parameter DATA_WIDTH = 8,
    parameter STACK_DEPTH = 16
)(
    input  wire                   clk,   // Clock
    input  wire                   rst,   // Reset
    input  wire                   push,  // Push operation
    input  wire                   pop,   // Pop operation
    input  wire [DATA_WIDTH-1:0]  data_in,
    
    output reg  [DATA_WIDTH-1:0]  data_out,
    output wire                   full,  // Stack full flag
    output wire                   empty  // Stack empty flag
);

// Stack memory storage
    reg [DATA_WIDTH-1:0] stack_mem [0:STACK_DEPTH-1];

    // Parametric Stack Pointer - automatically scales with stack depth
    reg [$clog2(STACK_DEPTH):0] sp;

    // Write/Read logic and Stack Pointer (SP) update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            data_out <= 0;
        end
        else begin
            if (push && !full) begin
                stack_mem[sp] <= data_in;
                sp <= sp + 1;
            end
            else if (pop && !empty) begin
                sp <= sp - 1;
                data_out <= stack_mem[sp-1];
            end
        end
    end

    // Output flags logic
    assign empty = (sp == 0);
    assign full  = (sp == STACK_DEPTH);

endmodule