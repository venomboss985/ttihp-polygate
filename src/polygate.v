`default_nettype none

/*
    INPUT
    b0: 0 = or, 1 = and;
    b1: 0 = Q, 1 = ~Q;
    b2: A input
    b3: B input

    OUTPUT
    b0: reserved for internal buffer;
    b1: reserved for internal buffer;
    b2: Q;
    b3: ~Q;
*/

module polygate (
  input  [3:0] in,
  output [1:0] out
);

  reg [3:0] in_buf;

  always @(*) begin
    // Reset input buffer
    in_buf = 4'b0;

    // OR/AND selection logic
    if (in[0] == 0)
      in_buf[0] = in[2] | in[3];
    else
      in_buf[0] = in[2] & in[3];

    // INVERT selection logic
    if (in[1] == 1)
    begin
      in_buf[2] = ~in_buf[0];
      in_buf[3] = in_buf[0];
    end else
    begin
      in_buf[2] = in_buf[0];
      in_buf[3] = ~in_buf[0];
    end
  end
  
  assign out[0] = in_buf[2];
  assign out[1] = in_buf[3];
endmodule