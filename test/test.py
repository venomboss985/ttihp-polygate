# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


async def start_and_reset(dut, cycles: int = 10):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, cycles)
    dut.rst_n.value = 1

@cocotb.test()
async def test_project(dut):
    await start_and_reset(dut)

    dut._log.info("Test default behavior")

    # Set the input values you want to test
    dut.ui_in.value = 0b00000000
    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)
    # Test the expected output
    assert dut.uo_out.value == 0b1010

@cocotb.test()
async def test_or(dut):
    dut._log.info("Test OR logic behavior")
    await start_and_reset(dut, 2)

    ## Test pg0 OR A=0, B=0
    dut._log.info("Testing OR A=0, B=0")
    dut.ui_in.value = 0b0000
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b10

    ## Test pg0 OR A=1, B=0
    dut._log.info("Testing OR A=1, B=0")
    dut.ui_in.value = 0b0100
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b01

    ## Test pg0 OR A=0, B=1
    dut._log.info("Testing OR A=0, B=1")
    dut.ui_in.value = 0b1000
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b01

    ## Test pg0 OR A=1, B=1
    dut._log.info("Testing OR A=1, B=1")
    dut.ui_in.value = 0b1100
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b01

    ## Test pg0 OR INV A=0, B=0
    dut._log.info("Testing OR INV A=0, B=0")
    dut.ui_in.value = 0b0010
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b01

@cocotb.test()
async def test_and(dut):
    dut._log.info("Test AND logic behavior")
    await start_and_reset(dut, 2)
    
    ## Test pg0 AND A=0, B=0
    dut._log.info("Testing AND A=0, B=0")
    dut.ui_in.value = 0b0001
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b10

    ## Test pg0 AND A=1, B=0
    dut._log.info("Testing AND A=1, B=0")
    dut.ui_in.value = 0b0101
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b10

    ## Test pg0 AND A=0, B=1
    dut._log.info("Testing AND A=0, B=1")
    dut.ui_in.value = 0b1001
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b10

    ## Test pg0 AND A=1, B=1
    dut._log.info("Testing AND A=1, B=1")
    dut.ui_in.value = 0b1101
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b01

    ## Test pg0 AND INV A=0, B=0
    dut._log.info("Testing AND INV A=0, B=0")
    dut.ui_in.value = 0b0011
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value & 0b11 == 0b01