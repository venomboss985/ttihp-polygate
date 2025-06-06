/*
 * Copyright (c) 2024 Jake Taylor
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 1ps

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
  input  wire [3:0] in,
  output reg  [1:0] out
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

module tt_um_polygate (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  polygate pg0 (
    .in (ui_in[3:0]),
    .out (uo_out[1:0])
  );

  polygate pg1 (
    .in (ui_in[7:4]),
    .out (uo_out[3:2])
  );

  assign uo_out[7:4] = 0;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{uio_in, ena, clk, rst_n, 1'b0};

endmodule
