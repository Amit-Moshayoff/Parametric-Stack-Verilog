module stack_tb();

    // Testbench parameter definitions
    parameter WIDTH = 8;
    parameter DEPTH = 4;

    // Signal declarations (registers for inputs, wires for outputs)
    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg [WIDTH-1:0] data_in;

    wire [WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Device Under Test (DUT) instantiation
    stack #(
        .DATA_WIDTH(WIDTH),
        .STACK_DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation logic
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus process
    initial begin

        $dumpfile("dump.vcd");  // Generate VCD file for waveform viewer (required by EPWave)
        $dumpvars(0, stack_tb); // Dump all variables inside stack_tb
        // --- Phase 1: System Reset ---
        $display("Starting Testbench: System Reset");
        rst = 1; push = 0; pop = 0; data_in = 0;
        #15 rst = 0; // Release reset slightly after the clock edge to avoid race conditions

        // --- Phase 2: Push operations until stack is full ---
        repeat (DEPTH) begin
            @(negedge clk); // Drive inputs on negedge for stable setup time at posedge
            push = 1;
            data_in = $random % 256; // Randomized data input
            $display("Pushing: %d", data_in);
        end

        @(negedge clk);
        push = 0;
        $display("Stack should be FULL now. Full flag: %b", full);

        // --- Phase 3: Write attempt to a full stack (Overflow check) ---
        #10;
        push = 1; data_in = 8'hFF;
        #10 push = 0;
        $display("Attempted push to full stack. Full flag remains: %b", full);

        // --- Phase 4: Pop operations until stack is empty ---
        repeat (DEPTH) begin
            @(negedge clk);
            pop = 1;
            #10; // Wait for one read cycle
            $display("Popped: %d", data_out);
        end

        @(negedge clk);
        pop = 0;
        $display("Stack should be EMPTY now. Empty flag: %b", empty);

        // --- Phase 5: Testbench termination ---
        #50;
        $display("Testbench finished.");
        $finish;
    end

endmodule