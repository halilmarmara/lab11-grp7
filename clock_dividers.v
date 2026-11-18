// ---------------- D flip-flop ----------------
module dff (
    input  clk,
    input  rst,      // async, active high
    input  d,
    output reg q
);
    always @(posedge clk or posedge rst)
        if (rst) q <= 1'b0;
        else     q <= d;
endmodule

// ---------------- T flip-flop built from a D-FF ----------------
module tff (
    input  clk,
    input  rst,
    input  t,
    output q
);
    wire d = q ^ t;
    dff u_dff (.clk(clk), .rst(rst), .d(d), .q(q));
endmodule

// ---------------- Full adder ----------------
module full_adder (
    input  a, b, cin,
    output sum, cout
);
    wire axb = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

// ---------------- Ripple counter: 3 cascaded T-FFs ----------------
// Each stage is clocked by the previous stage's Q, so each divides by 2.
module ripple_counter (
    input  clk,
    input  rst,
    output [2:0] q
);
    tff t0 (.clk(clk),  .rst(rst), .t(1'b1), .q(q[0]));
    tff t1 (.clk(q[0]), .rst(rst), .t(1'b1), .q(q[1]));
    tff t2 (.clk(q[1]), .rst(rst), .t(1'b1), .q(q[2]));
endmodule

// ---------------- Modulo divider: count 0..5, toggle out on wrap ----------------
// Output toggles every 6 input clocks -> divide by 12.
module modulo_divider (
    input  clk,
    input  rst,
    output [2:0] count,
    output out
);
    // count + 1 using the full adders (b = 001, cin = 0)
    wire [2:0] sum;
    wire c0, c1, c2;
    full_adder fa0 (.a(count[0]), .b(1'b1), .cin(1'b0), .sum(sum[0]), .cout(c0));
    full_adder fa1 (.a(count[1]), .b(1'b0), .cin(c0),   .sum(sum[1]), .cout(c1));
    full_adder fa2 (.a(count[2]), .b(1'b0), .cin(c1),   .sum(sum[2]), .cout(c2));

    // Comparator: count == 5 (101)
    wire hit = count[2] & ~count[1] & count[0];

    // Next state: 0 when hit, else count + 1
    wire [2:0] d_cnt = sum & {3{~hit}};
    // Output toggles when hit
    wire d_out = out ^ hit;

    dff c_b0  (.clk(clk), .rst(rst), .d(d_cnt[0]), .q(count[0]));
    dff c_b1  (.clk(clk), .rst(rst), .d(d_cnt[1]), .q(count[1]));
    dff c_b2  (.clk(clk), .rst(rst), .d(d_cnt[2]), .q(count[2]));
    dff o_ff  (.clk(clk), .rst(rst), .d(d_out),    .q(out));
endmodule
