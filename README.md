# SoC Ethernet Controller on Intel DE10-Standard

<p align="center">
  <a href="https://github.com/lhlizdabezt/DoAnHeThongNhung/releases/latest"><img src="https://img.shields.io/github/v/release/lhlizdabezt/DoAnHeThongNhung?style=for-the-badge&logo=github&label=Release" alt="Latest release for DoAnHeThongNhung" /></a>
  <a href="https://github.com/lhlizdabezt/DoAnHeThongNhung/tags"><img src="https://img.shields.io/github/v/tag/lhlizdabezt/DoAnHeThongNhung?style=for-the-badge&logo=git&label=Tag" alt="Latest tag for DoAnHeThongNhung" /></a>
  <img src="https://img.shields.io/badge/Portfolio-English%20review%20ready-0f766e?style=for-the-badge" alt="English portfolio ready" />
</p>

## Overview

This project demonstrates a TCP/Ethernet control path from PC or Android clients to an embedded Linux daemon on the Cyclone V HPS, then through the lightweight HPS-to-FPGA bridge to seven-segment displays.

| Field | Details |
|---|---|
| Repository | [DoAnHeThongNhung](https://github.com/lhlizdabezt/DoAnHeThongNhung) |
| Portfolio category | Embedded systems / FPGA-SoC course project |
| Primary stack | DE10-Standard, Cyclone V, HPS/Linux, VHDL, Platform Designer, Quartus, PIO, TCP/IP, Ethernet, C/C++, Python, Tkinter. |
| Latest release | [GitHub Releases](https://github.com/lhlizdabezt/DoAnHeThongNhung/releases/latest) |
| Tags | [Version tags](https://github.com/lhlizdabezt/DoAnHeThongNhung/tags) |
| Owner profile | [Luong Hai Long](https://github.com/lhlizdabezt) |

## Reviewer Map

| What to Review | Where to Look | Why It Matters |
|---|---|---|
| Technical scope | This README and source tree | Gives a quick, bounded reading path before opening every file |
| Evidence assets | Release page and top-level project files | Shows what can be downloaded or inspected quickly |
| Implementation material | Source folders, scripts, notebooks or design files | Connects the portfolio claim to real project artifacts |
| Version history | Tags and release notes | Makes the repository easier to audit over time |

## Evidence Highlights

- DE10-Standard / Cyclone V SoC architecture.
- HPS/Linux TCP server and PC/Android client command flow.
- PIO-mapped HPS-to-FPGA bridge driving HEX0..HEX5 displays.
- Report, slide deck, visual flow and release evidence.

## Repository Structure

| Path | Purpose |
|---|---|
| `assets/` | Top-level directory included in the repository |
| `DoAn/` | Top-level directory included in the repository |
| `src/` | Top-level directory included in the repository |
| `17_TH_HTN_22DTV_CLC.pdf` | Top-level file included in the repository |
| `17_TH_HTN_22DTV_CLC_presentation.pdf` | Top-level file included in the repository |
| `17_TH_HTN_22DTV_CLC_presentation.typ` | Top-level file included in the repository |
| `20260420_155317_001_109.png` | Top-level file included in the repository |
| `20260420_155317_001_441.png` | Top-level file included in the repository |

## Scope and Boundaries

Team coursework prototype for LAN-based embedded-system control. It does not claim internet deployment, production security hardening or a custom kernel driver.

## Role and Portfolio Context

Luong Hai Long presents this repository as networked embedded-systems evidence and maintains the public portfolio packaging.

## Release and Tagging Notes

This repository is maintained as part of an English-facing engineering portfolio. Releases and tags are used to preserve reviewable snapshots of the project, including source state, documentation updates and any available visual or report assets.

## Writing Standard

The README follows an evidence-first style: direct technical nouns, clear project boundaries, release-backed artifacts and no inflated claims beyond what the repository can support.
