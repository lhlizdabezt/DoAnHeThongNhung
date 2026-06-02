# v1.0.7 - Nested Board Guide and Reviewer Safety Refresh

## Scope

This release completes the reviewer-facing documentation pass for `DoAnHeThongNhung`. It keeps the US English portfolio README structure from `v1.0.6`, then replaces the old nested Terasic boilerplate README with a project-specific DE10-Standard hardware and HPS Linux guide.

## Changes

- Replaced `DoAn/de10_hex_text_ssh_project/README.md` with a project-specific board guide for Quartus, Platform Designer, HPS Linux, PIO registers and the six-HEX display path.
- Added nested guide links to the top-level `README.md` so HR, seminar, faculty and engineering reviewers can find the hardware/software integration guide quickly.
- Documented the exact review path for `soc_system.qsys`, `project.vhd`, `sw/hps/hex_text.sh`, the repository-level TCP server wrappers and the PC client.
- Added `REPORT_REVIEW_GUIDE.md` as a US English companion to the original course report artifact.
- Translated and rebuilt `17_TH_HTN_22DTV_CLC_presentation.typ` and `17_TH_HTN_22DTV_CLC_presentation.pdf` into US English.
- Added direct SD-card, `devmem`, LAN-only and prototype-boundary safety notes.
- Kept all visible Markdown text in US English and kept SVG assets ASCII-safe.

## Visual Safety

The featured SVG and GIF assets remain designed for GitHub README rendering. They avoid moving connector lines, dotted lines, dashed lines and decorative paths behind text. SVG text is ASCII-safe English to reduce mojibake, blocked glyphs and rendering noise.

## Review Context

This project remains an academic LAN-based prototype. It demonstrates a TCP/Ethernet command path from client software to HPS Linux and FPGA-driven seven-segment outputs. It does not claim production deployment, internet exposure, production security hardening, a custom kernel driver or commercial readiness.
