# v1.0.6 - Reviewer-Ready English Portfolio Refresh

## Scope

This release refreshes `DoAnHeThongNhung` for US English HR screening, engineering review, seminar review and faculty-style inspection. It expands the README from a short repository summary into a complete reviewer guide with system scope, address map, run instructions, FAQ, release links, profile links and explicit prototype boundaries.

## Changes

- Rebuilt `README.md` as a complete English reviewer guide for the DE10-Standard SoC Ethernet project.
- Added concrete system evidence for the PC or Android client, TCP port `5000`, HPS Linux server path, Lightweight HPS-to-FPGA bridge, PIO address map and `HEX0..HEX5` output.
- Added step-by-step review instructions, PC client run notes, board-side service notes, visual evidence notes, release links, contact links and FAQ.
- Replaced `assets/soc-ethernet-hero.svg` with a line-free, ASCII-safe English SVG banner.
- Corrected the GIF render script so the HPS process is labeled as a Python server, matching the committed board-side workflow.
- Translated visible Python/Tkinter GUI labels and status messages to English.

## Visual Safety

The featured SVG and GIF assets are designed for GitHub README rendering. They avoid moving connector lines, dotted lines, dashed lines and decorative paths behind text. SVG text is ASCII-safe English to reduce mojibake, blocked glyphs and rendering noise.

## Review Context

This project remains an academic LAN-based prototype. It demonstrates a TCP/Ethernet command path from client software to HPS Linux and FPGA-driven seven-segment outputs. It does not claim production deployment, internet exposure, production security hardening, a custom kernel driver or commercial readiness.
