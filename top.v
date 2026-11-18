module top (
    input  btnU,          // reset
    input  btnC,          // input clock
    output [6:0] led
);
    ripple_counter rc (.clk(btnC), .rst(btnU), .q(led[2:0]));
    modulo_divider md (.clk(btnC), .rst(btnU), .count(led[5:3]), .out(led[6]));
endmodule
