#import "@preview/touying:0.5.3": *
#import "stargazer.typ": *

#set text(font: ("Segoe UI", "Arial", "New Computer Modern"), lang: "en")
#set par(justify: true, leading: 0.62em)
#show strong: set text(weight: "bold")

#let navy = rgb("#0B1220")
#let teal = rgb("#0F766E")
#let cyan = rgb("#0891B2")
#let green = rgb("#15803D")
#let amber = rgb("#B45309")
#let rose = rgb("#BE185D")
#let blue = rgb("#1D4ED8")
#let slate = rgb("#334155")
#let muted = rgb("#64748B")
#let paper = rgb("#F6F8FB")
#let line = rgb("#CBD5E1")

#let chip(it, fill: teal, fg: white) = block(
  fill: fill,
  inset: (x: 8pt, y: 4pt),
  radius: 4pt,
  text(size: 11pt, fill: fg, weight: "bold", it),
)

#let card(title, body, fill: white, stroke: line, accent: teal) = block(
  fill: fill,
  stroke: stroke,
  radius: 6pt,
  inset: 13pt,
  width: 100%,
)[
  #text(size: 16pt, fill: accent, weight: "bold", title)
  #v(5pt)
  #body
]

#let metric(value, label, accent: teal) = block(
  fill: white,
  stroke: line,
  radius: 6pt,
  inset: 11pt,
  width: 100%,
)[
  #text(size: 25pt, fill: accent, weight: "bold", value)
  #v(1pt)
  #text(size: 12pt, fill: slate, label)
]

#let photo(path, caption: none, fit: "cover", height: 100%) = block(
  fill: white,
  stroke: line,
  radius: 6pt,
  inset: 4pt,
  width: 100%,
  height: height,
)[
  #image(path, width: 100%, height: 100%, fit: fit)
  #if caption != none [
    #v(2pt)
    #align(center, text(size: 9pt, fill: muted, caption))
  ]
]

#let arrow-step(title, body, accent: teal, fill: rgb("#ECFDF5")) = block(
  fill: fill,
  stroke: accent.lighten(35%),
  radius: 6pt,
  inset: 11pt,
  width: 100%,
)[
  #text(size: 15pt, fill: accent, weight: "bold", title)
  #v(3pt)
  #text(size: 12pt, fill: slate, body)
]

#let addr-row(name, addr, target, fill: white) = block(
  fill: fill,
  stroke: line,
  radius: 3pt,
  inset: (x: 9pt, y: 6pt),
  width: 100%,
)[
  #grid(
    columns: (1fr, 1.45fr, .8fr),
    gutter: 8pt,
    align: horizon + left,
    text(size: 12pt, weight: "bold", name),
    text(size: 12pt, font: "Consolas", fill: blue, addr),
    text(size: 12pt, fill: slate, target),
  )
]

#let two(lhs, rhs, columns: (1fr, 1fr), gutter: 18pt) = grid(
  columns: columns,
  gutter: gutter,
  align: top + left,
  lhs,
  rhs,
)

#let smallnote(it) = text(size: 10pt, fill: muted, it)

#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [System-Integrated SoC Ethernet],
    subtitle: [Firmware and PC TCP command application],
    author: [Group 17 - 22DTV_CLC],
    instructor: [M.Sc. Tran Tuan Kiet, M.Sc. Do Quoc Minh Dang, M.Sc. Nguyen Nhu Hoang],
    date: "05/2026",
    institution: [Faculty of Electronics and Telecommunications, VNUHCM - University of Science],
  ),
)

// Overall script: 12 slides, 10-15 minutes.
// Recommended timing:
// 1) Opening and objective: 2 minutes.
// 2) Architecture, hardware and address map: 4 minutes.
// 3) Firmware, clients and testing: 5 minutes.
// 4) Results, limits and conclusion: 2-3 minutes.

// ------------------------------------------------------------
// Slide 1 - 45 seconds.
#slide(navigation: none, progress-bar: false, self => [
  #grid(
    columns: (1.05fr, .95fr),
    gutter: 18pt,
    align: horizon,
    [
      #v(5pt)
      #chip[Topic 13 | Group 17 | 22DTV_CLC]
      #v(18pt)
      #text(size: 31pt, fill: navy, weight: "bold")[
        System-integrated SoC Ethernet: firmware and PC TCP command application
      ]
      #v(12pt)
      #text(size: 16pt, fill: slate)[
        DE10-Standard Cyclone V SoC FPGA \
        HPS Linux -> TCP -> Lightweight HPS-FPGA Bridge -> HEX0..HEX5
      ]
      #v(18pt)
      #card[Report Information][
        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          row-gutter: 6pt,
          [*Instructors*], [M.Sc. Tran Tuan Kiet; M.Sc. Do Quoc Minh Dang; M.Sc. Nguyen Nhu Hoang],
          [*Members*], [Van Dinh Nam; Luong Hai Long; Tran Si Nam; Le Tan Phi Pha; Vu Chau Thang Loi],
          [*Duration*], [10-15 minutes],
        )
      ]
    ],
    [
      #photo("assets/20260420_155317_001_57.png", fit: "cover", height: 100%)
    ],
  )
])

// ------------------------------------------------------------
// Slide 2 - 60 seconds.
#slide(title: "Main Message")[
  #v(12pt)
  #two(
    [
      #text(size: 23pt, weight: "bold", fill: navy)[Do not present isolated modules.]
      #v(8pt)
      #text(size: 15pt, fill: slate)[
        The presentation follows an end-to-end control path that can be verified:
      ]
      #v(10pt)
      #card[Engineering Flow][
        #align(center)[
          #text(size: 18pt, weight: "bold", fill: teal)[PC GUI]
          #text(size: 18pt)[ -> ]
          #text(size: 18pt, weight: "bold", fill: cyan)[TCP]
          #text(size: 18pt)[ -> ]
          #text(size: 18pt, weight: "bold", fill: green)[HPS Linux]
          #text(size: 18pt)[ -> ]
          #text(size: 18pt, weight: "bold", fill: amber)[Bridge]
          #text(size: 18pt)[ -> ]
          #text(size: 18pt, weight: "bold", fill: rose)[HEX]
        ]
      ]
    ],
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 9pt,
        row-gutter: 9pt,
        metric("1", [end-to-end control path], accent: teal),
        metric("6", [maximum characters on HEX0..HEX5], accent: blue),
        metric("5000", [board TCP service port], accent: amber),
        metric("LW", [bridge in the 0xFF200000 region], accent: rose),
      )
      #v(10pt)
      #smallnote[Main point for reviewers: the team did not only build a GUI. The software path reaches a hardware peripheral that can be observed directly.]
    ],
    columns: (1.05fr, .95fr),
  )
]

// ------------------------------------------------------------
// Slide 3 - 70 seconds.
#slide(title: "Problem and Scope")[
  #v(12pt)
  #two(
    [
      #card[Input][
        - User enters the board IP, TCP port and a payload up to 6 characters.
        - Client sends the payload through a TCP socket inside the same LAN.
        - Board returns `OK:<text>` or `ERR:<reason>`.
      ]
      #v(8pt)
      #card[Output][
        - Normalized payload is displayed on `HEX5..HEX0`.
        - PC-side log is available for request/response checking.
        - Android client uses the same service to verify an independent endpoint.
      ]
    ],
    [
      #card[Deliberate Boundaries][
        - Local LAN only, without Internet or NAT traversal.
        - Function correctness first; latency and throughput are not measured quantitatively.
        - Protocol is currently a simple text line, without a `len/cmd/crc` frame.
        - `devmem` fits the prototype; no kernel driver is implemented.
      ]
      #v(8pt)
      #card(fill: rgb("#F0FDFA"), stroke: teal.lighten(35%), accent: teal)[Prototype Value][
        The team has observable evidence at each layer: Linux shell, `eth0` IP, TCP socket, `OK/ERR` response and physical HEX state.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 4 - 90 seconds.
#slide(title: "Overall Architecture")[
  #v(12pt)
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    gutter: 7pt,
    align: top + left,
    arrow-step("PC GUI", [Enter payload, send TCP and write log], accent: cyan, fill: rgb("#ECFEFF")),
    arrow-step("TCP", [STREAM socket with one-connection request/response], accent: teal, fill: rgb("#F0FDFA")),
    arrow-step("HPS Linux", [Python server listens on `0.0.0.0:5000`], accent: green, fill: rgb("#F0FDF4")),
    arrow-step("Sanitize", [Uppercase, filter characters, trim or pad to 6], accent: amber, fill: rgb("#FFFBEB")),
    arrow-step("Bridge", [`devmem` writes PIO registers], accent: rose, fill: rgb("#FFF1F2")),
    arrow-step("HEX", [HEX5..HEX0 displays left to right], accent: blue, fill: rgb("#EEF2FF")),
  )
  #v(15pt)
  #two(
    [
      #card(fill: paper, stroke: line, accent: navy)[Design Reasoning][
        Each layer has its own input, output and test method. When a fault appears, the team isolates the first broken layer instead of guessing across the whole system.
      ]
    ],
    [
      #card(fill: rgb("#F0FDFA"), stroke: teal.lighten(35%), accent: teal)[Key Speaking Point][
        The Android client is not decoration. It proves that the board TCP service is not locked to the PC GUI endpoint.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 5 - 75 seconds.
#slide(title: "Hardware Platform and Bring-up")[
  #v(12pt)
  #two(
    [
      #photo("assets/de10_standard.jpg", caption: [DE10-Standard Cyclone V SoC FPGA], fit: "contain", height: 72%)
    ],
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 8pt,
        row-gutter: 8pt,
        photo("assets/msel.jpg", caption: [MSEL = 000000], fit: "cover", height: 95pt),
        photo("assets/MicroSDCard.png", caption: [Boot Linux from MicroSD], fit: "contain", height: 95pt),
        photo("assets/DayEtherent.jpg", caption: [Ethernet LAN], fit: "contain", height: 95pt),
        photo("assets/board_connections.jpg", caption: [USB-UART + Ethernet + power], fit: "cover", height: 95pt),
      )
      #v(8pt)
      #card(accent: green)[Minimum Bring-up][
        1. Load/configure the bitstream and boot files. \
        2. Boot Linux from MicroSD and access the shell over USB-UART. \
        3. Enable `eth0` and request an IP address through DHCP. \
        4. Run the TCP server and test from a PC inside the LAN.
      ]
    ],
    columns: (1.05fr, .95fr),
  )
]

// ------------------------------------------------------------
// Slide 6 - 95 seconds.
#slide(title: "Platform Designer and Address Map")[
  #v(12pt)
  #two(
    [
      #photo("assets/platform_designer.png", caption: [Platform Designer system], fit: "contain", height: 67%)
      #v(6pt)
      #card(accent: navy)[Hardware-Software Contract][
        The top-level VHDL connects `pio_hex0_external_export` through `pio_hex5_external_export` to `HEX0` through `HEX5`. HPS code only needs to write the agreed PIO addresses.
      ]
    ],
    [
      #addr-row("pio_hex0", "0xFF200040", "HEX0", fill: rgb("#F8FAFC"))
      #v(4pt)
      #addr-row("pio_hex1", "0xFF200050", "HEX1")
      #v(4pt)
      #addr-row("pio_hex2", "0xFF200060", "HEX2", fill: rgb("#F8FAFC"))
      #v(4pt)
      #addr-row("pio_hex3", "0xFF200070", "HEX3")
      #v(4pt)
      #addr-row("pio_hex4", "0xFF200080", "HEX4", fill: rgb("#F8FAFC"))
      #v(4pt)
      #addr-row("pio_hex5", "0xFF200090", "HEX5")
      #v(8pt)
      #card(fill: rgb("#F0FDF4"), stroke: green.lighten(35%), accent: green)[Quartus Result][
        Fitter successful. Logic utilization: *1,960 / 41,910 ALMs (5%)*. Total registers: *2,614*. Total pins: *302 / 499 (61%)*.
      ]
    ],
    columns: (1.08fr, .92fr),
  )
]

// ------------------------------------------------------------
// Slide 7 - 95 seconds.
#slide(title: "Firmware on HPS Linux")[
  #v(12pt)
  #two(
    [
      #arrow-step("handle_client()", [Receives `recv(1024)`, decodes UTF-8, handles one request and closes the connection.], accent: cyan, fill: rgb("#ECFEFF"))
      #v(8pt)
      #arrow-step("sanitize_text()", [Strips, uppercases, filters unsupported characters, then trims or pads to exactly 6 characters.], accent: teal, fill: rgb("#F0FDFA"))
      #v(8pt)
      #arrow-step("seg() + write_hex()", [Encodes active-low seven-segment values and calls `devmem` to write 6 PIO registers.], accent: amber, fill: rgb("#FFFBEB"))
      #v(8pt)
      #card(fill: rgb("#FFF1F2"), stroke: rose.lighten(35%), accent: rose)[Active-low][
        `0` means segment on, and `1` means segment off. Therefore `8 = 0`, while blank space is `127`.
      ]
    ],
    [
      #block(fill: rgb("#F8FAFC"), stroke: line, radius: 6pt, inset: 11pt, width: 100%)[
        #text(size: 15pt, weight: "bold", fill: navy)[Server Core Logic]
        #v(5pt)
        #set text(size: 10pt, font: "Consolas", fill: navy)
        ```python
s.bind(("0.0.0.0", 5000))
s.listen(5)

data = conn.recv(1024)
text = sanitize_text(data)

v5, v4, v3, v2, v1, v0 = map(seg, text[:6])
devmem 0xFF200040..0xFF200090 32 value

conn.sendall(("OK:%s\n" % text).encode())
        ```
      ]
      #v(8pt)
      #smallnote[If a reviewer asks about errors: the server returns `ERR:<reason>`, which separates socket errors, `devmem` errors, root-permission issues and wrong address-map issues.]
    ],
    columns: (.94fr, 1.06fr),
  )
]

// ------------------------------------------------------------
// Slide 8 - 80 seconds.
#slide(title: "Client Applications")[
  #v(12pt)
  #two(
    [
      #photo("assets/Python.png", caption: [PC GUI with Python/Tkinter], fit: "contain", height: 58%)
      #v(8pt)
      #card(accent: rose)[PC GUI][
        - Separate thread for TCP actions so the interface does not freeze.
        - 5-second socket timeout.
        - Clear log for sent line, received line and error.
      ]
    ],
    [
      #photo("assets/Android.jpg", caption: [Android client using the same TCP service], fit: "contain", height: 58%)
      #v(8pt)
      #card(accent: cyan)[Android client][
        - Sends the same newline-terminated UTF-8 payload.
        - Receives the same `OK:<text>` or `ERR:<reason>`.
        - Used to verify that the server does not depend on one endpoint.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 9 - 85 seconds.
#slide(title: "End-to-End Testing")[
  #v(12pt)
  #two(
    [
      #card(accent: green)[Five-Step Procedure][
        1. Boot Linux and access the shell through USB-UART. \
        2. Enable `eth0`, request a DHCP IP and ping to check the network. \
        3. Run the TCP server on port `5000`. \
        4. Send a payload from the PC GUI and receive `OK:<text>`. \
        5. Compare `HEX5..HEX0` with the normalized string.
      ]
      #v(8pt)
      #card(accent: blue)[Test Payloads][
        `HELLO-`, `ABC123`, `P-0001`, `123456`, `------`, empty string, strings longer than 6 characters and unsupported characters.
      ]
    ],
    [
      #photo("assets/20260420_155317_001_109.png", caption: [Laptop - router - board test environment], fit: "cover", height: 78%)
    ],
    columns: (.95fr, 1.05fr),
  )
]

// ------------------------------------------------------------
// Slide 10 - 80 seconds.
#slide(title: "Results and Fault Isolation")[
  #v(12pt)
  #two(
    [
      #photo("assets/20260420_155346.jpg", caption: [PC and Android controlling the same TCP service], fit: "cover", height: 58%)
      #v(8pt)
      #card(fill: rgb("#F0FDF4"), stroke: green.lighten(35%), accent: green)[Functional Result][
        PC/Android -> TCP -> HPS Linux -> PIO -> HEX works repeatedly inside LAN. Valid payloads receive `OK`.
      ]
    ],
    [
      #card(accent: amber)[Fault Isolation Tree][
        - No shell: check power, MSEL, MicroSD and USB-UART.
        - Shell exists but no IP: check Ethernet, DHCP and `udhcpc`.
        - IP exists but client cannot connect: check the server and port `5000`.
        - `OK` response but wrong HEX output: check `seg()`, `HEX5..HEX0` order and VHDL.
        - `ERR` response: read the reason, then check `devmem`, root permission and PIO address.
      ]
      #v(8pt)
      #smallnote[This is the strongest point: the team has a layer-by-layer debugging method, not only a one-time demo.]
    ],
    columns: (1.03fr, .97fr),
  )
]

// ------------------------------------------------------------
// Slide 11 - 70 seconds.
#slide(title: "Limitations and Future Work")[
  #v(12pt)
  #two(
    [
      #card(fill: rgb("#FFF1F2"), stroke: rose.lighten(35%), accent: rose)[Current Limitations][
        - Server does not auto-start after reboot.
        - Protocol is still a simple text line.
        - `devmem` fits the prototype but is not optimal for a long-term product.
        - No authentication, encryption or protection against unintended commands.
        - Latency and throughput are not measured quantitatively.
      ]
    ],
    [
      #card(fill: rgb("#FFFBEB"), stroke: amber.lighten(35%), accent: amber)[Next Development Steps][
        - Auto-start the server with init or systemd.
        - Design a `len/cmd/payload/crc` frame.
        - Replace `devmem` with `mmap` or a kernel driver.
        - Add simple LAN authentication.
        - Add automated test scripts for multiple payloads.
      ]
    ],
  )
  #v(12pt)
  #card(fill: paper, stroke: line, accent: navy)[Answer When Asked Deeply][
    These limitations do not reduce the project value because the course goal is to integrate and verify the hardware-software chain. The team knows which parts are prototype-level and which parts would need upgrading for a more serious system.
  ]
]

// ------------------------------------------------------------
// Slide 12 - 45 seconds.
#slide(title: "Conclusion")[
  #align(center + horizon)[
    #block(fill: rgb("#F0FDFA"), stroke: teal.lighten(35%), radius: 8pt, inset: 20pt, width: 86%)[
      #text(size: 27pt, fill: navy, weight: "bold")[
        The team built a SoC Ethernet prototype with a clear end-to-end control path that can be tested and explained layer by layer.
      ]
      #v(14pt)
      #text(size: 17pt, fill: slate)[
        Main takeaway: PC/Android sends TCP commands, HPS Linux processes and writes through the Lightweight HPS-FPGA Bridge, and FPGA fabric displays the result on HEX0..HEX5.
      ]
      #v(22pt)
      #text(size: 24pt, fill: teal, weight: "bold")[Thank you for listening.]
    ]
  ]
]
