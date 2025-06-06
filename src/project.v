/*
 * Copyright (c) 2024 Jake Taylor
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 1ps

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
