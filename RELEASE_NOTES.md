# v1.0.8 - English Documentation and Visual QA

## Scope

This release integrates the concurrent reviewer-documentation refresh with an independently rendered English presentation, English desktop-client labels, and a static ASCII-safe system overview.

## Changes

- Preserved the v1.0.7 reviewer guide, nested board documentation, report companion, line-free hero SVG, and line-free flow GIF.
- Rebuilt and visually inspected the twelve-slide Typst presentation after correcting the checked-in theme margin that caused an address-map slide to intrude into its header.
- Updated the Python/Tkinter client labels, status messages, and error dialog to US English without changing its TCP behavior.
- Added `assets/soc-ethernet-flow.svg`, a self-hosted ASCII-English overview with opacity-only motion and no connector or decorative lines behind text.
- Excluded duplicate presentation PDFs, local render checks, archive copies, and bundled system fonts from the public repository.

## Verification

- `typstyle --check` passed for the presentation and theme source.
- The regenerated PDF has twelve rendered pages; visual checks covered the title, architecture, hardware, address-map, firmware, client, test, results, limits, and conclusion slides.
- Python syntax compilation passed for `DoAn/pc_hex_tcp_pink_gui.py`.
- The static SVG is ASCII-only, renders without clipping, and uses no `path`, `line`, dotted, or dashed connector elements.

---

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
