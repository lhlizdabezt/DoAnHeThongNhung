# English Report Review Guide

This guide is the US English companion to the original course report artifact `17_TH_HTN_22DTV_CLC.pdf`. The original PDF is preserved as submitted coursework evidence, while this file gives HR, seminar, faculty and engineering reviewers a concise English path through the project.

## Abstract

`DoAnHeThongNhung` demonstrates a LAN-based SoC Ethernet control path on the Intel DE10-Standard Cyclone V board. A PC or Android client sends a short text payload over TCP port `5000`. The HPS Linux side receives and normalizes the payload, writes active-low seven-segment values through the Lightweight HPS-to-FPGA bridge, and the FPGA fabric displays the result on `HEX5..HEX0`.

## Review Map

| Review question | Evidence to inspect |
|---|---|
| What is the system objective? | `README.md`, this guide and `17_TH_HTN_22DTV_CLC_presentation.pdf` |
| How does the TCP path work? | `DoAn/pc_hex_tcp_pink_gui.py`, `DoAn/s1.cpp`, `DoAn/s2.cpp`, `DoAn/s3.cpp` |
| How does HPS software reach FPGA output? | `DoAn/de10_hex_text_ssh_project/README.md`, `hw/quartus/soc_system.qsys`, `hw/hdl/project.vhd` |
| Which addresses are written? | `0xFF200040` through `0xFF200090` for `pio_hex0` through `pio_hex5` |
| What proves board-level output? | `assets/20260420_155346.jpg`, `assets/Android.jpg`, `assets/Python.png`, `assets/soc-ethernet-flow.gif` |
| What is not claimed? | Production security, internet deployment, NAT traversal, custom kernel driver or real-time certification |

## System Architecture

```text
PC or Android client
-> TCP port 5000
-> HPS Linux server
-> Lightweight HPS-to-FPGA bridge
-> PIO registers
-> HEX5..HEX0 seven-segment displays
```

The important engineering point is the end-to-end path. The project is not only a graphical client. It connects network input to HPS Linux processing, memory-mapped bridge writes and visible FPGA output.

## Hardware Evidence

| Hardware item | Role |
|---|---|
| DE10-Standard Cyclone V SoC | Main board platform |
| HPS Ethernet | Receives commands from PC or Android client over LAN |
| Lightweight HPS-to-FPGA bridge | Provides memory-mapped software access to FPGA-side PIO registers |
| Platform Designer PIO blocks | Export six seven-segment control signals |
| `HEX0..HEX5` | Physical output used to verify the payload |

Reviewer path:

1. Open `DoAn/de10_hex_text_ssh_project/hw/quartus/soc_system.qsys`.
2. Confirm `pio_hex0` through `pio_hex5` connect to `hps_0.h2f_lw_axi_master`.
3. Open `DoAn/de10_hex_text_ssh_project/hw/hdl/project.vhd`.
4. Confirm `pio_hex0_external_export` through `pio_hex5_external_export` connect to `HEX0` through `HEX5`.

## Software Evidence

| Software item | Role |
|---|---|
| `DoAn/pc_hex_tcp_pink_gui.py` | Python/Tkinter PC client with board IP, port, payload, status and log |
| `DoAn/s1.cpp` | Writes the board-side Python TCP server to `/tmp/board_tcp_hex_server.py` |
| `DoAn/s2.cpp` | Writes the board-side start script |
| `DoAn/s3.cpp` | Starts the board-side service |
| `sw/hps/hex_text.sh` | Direct shell test for writing six HEX displays with `devmem` |

The board-side server normalizes text to six characters, converts each character to active-low seven-segment codes, writes six PIO registers with `devmem`, and returns `OK:<payload>` or `ERR:<reason>`.

## Test Procedure

1. Boot the DE10-Standard board into HPS Linux.
2. Confirm Ethernet connectivity and identify the board IP address.
3. Start the board-side TCP server on port `5000`.
4. Open the PC GUI with Python.
5. Send payloads such as `HELLO-`, `ABC123`, `P-0001`, `123456`, `------` and blank input.
6. Confirm the response in the PC log.
7. Compare `HEX5..HEX0` with the normalized display payload.
8. Repeat with the Android client to show that the board service is not tied to one PC endpoint.

## Boundaries

This is an academic prototype for embedded systems practice. It is useful as evidence of FPGA/SoC integration, HPS Linux control, TCP/IP command paths and hardware/software debugging. It is not presented as a production embedded product.

The current design intentionally does not claim:

- internet-facing operation;
- NAT traversal;
- TLS, authentication or production security hardening;
- a custom Linux kernel driver;
- real-time safety certification;
- measured latency or throughput guarantees.

## Reviewer Summary

This project is strongest when evaluated as an inspectable hardware/software integration artifact. The evidence is concrete: board photos, PC and Android clients, source files, PIO address map, VHDL wiring, release notes and a regenerated English presentation PDF.
