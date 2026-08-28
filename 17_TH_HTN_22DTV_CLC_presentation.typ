#import "@preview/touying:0.5.3": *
#import "stargazer.typ": *

#set text(font: ("Segoe UI", "Arial", "New Computer Modern"), lang: "en")
#set par(justify: false, leading: 0.58em)
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
  inset: 10pt,
  width: 100%,
)[
  #text(size: 14pt, fill: accent, weight: "bold", title)
  #v(3pt)
  #set text(size: 12.5pt, fill: slate)
  #set par(justify: false, leading: 0.54em)
  #body
]

#let metric(value, label, accent: teal) = block(
  fill: white,
  stroke: line,
  radius: 6pt,
  inset: 9pt,
  width: 100%,
)[
  #text(size: 22pt, fill: accent, weight: "bold", value)
  #v(1pt)
  #text(size: 10.5pt, fill: slate, label)
]

#let photo(path, caption: none, fit: "cover", height: 100%) = block(
  fill: white,
  stroke: line,
  radius: 6pt,
  inset: 4pt,
  width: 100%,
  height: height,
)[
  #layout(size => {
    let reserved = if caption == none { 0pt } else { 10pt }
    image(path, width: 100%, height: size.height - reserved, fit: fit)
    if caption != none {
      v(2pt)
      align(center, text(size: 7pt, fill: muted, caption))
    }
  })
]

#let arrow-step(title, body, accent: teal, fill: rgb("#ECFDF5")) = block(
  fill: fill,
  stroke: accent.lighten(35%),
  radius: 6pt,
  inset: 8pt,
  width: 100%,
  breakable: false,
)[
  #text(size: 13pt, fill: accent, weight: "bold", title)
  #v(2pt)
  #text(size: 10.5pt, fill: slate, body)
]

#let addr-row(name, addr, target, fill: white) = block(
  fill: fill,
  stroke: line,
  radius: 3pt,
  inset: (x: 8pt, y: 5pt),
  width: 100%,
  breakable: false,
)[
  #grid(
    columns: (1fr, 1.45fr, .8fr),
    gutter: 8pt,
    align: horizon + left,
    text(size: 10.5pt, weight: "bold", name),
    text(size: 10.5pt, font: "Consolas", fill: blue, addr),
    text(size: 10.5pt, fill: slate, target),
  )
]

#let two(lhs, rhs, columns: (1fr, 1fr), gutter: 14pt) = grid(
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
    title: [SoC Ethernet system integration],
    subtitle: [Firmware and TCP command applications for PC clients],
    author: [Group 17 - 22DTV_CLC],
    instructor: [MSc. Trần Tuấn Kiệt, MSc. Đỗ Quốc Minh Đăng, MSc. Nguyễn Như Hoàng],
    date: "05/2026",
    institution: [Faculty of Electronics and Telecommunications, VNUHCM - University of Science],
  ),
)

// Twelve slides for a 10-15 minute presentation.
// Suggested pacing:
// 1) Introduction and objective: 2 minutes.
// 2) Architecture, hardware, and address map: 4 minutes.
// 3) Firmware, clients, and tests: 5 minutes.
// 4) Results, limits, and conclusion: 2-3 minutes.

// ------------------------------------------------------------
// Slide 1 - 45 seconds.
#slide(
  navigation: none,
  progress-bar: false,
  config: config-page(margin: (top: 2.4em, bottom: 1.2em, x: 2.5em)),
  self => [
    #grid(
      columns: (1.22fr, .78fr),
      gutter: 14pt,
      align: top + left,
      [
        #v(5pt)
        #chip[TOPIC 13 | GROUP 17 | 22DTV_CLC]
        #v(12pt)
        #text(size: 28pt, fill: navy, weight: "bold")[
          SoC Ethernet Controller
        ]
        #v(8pt)
        #text(size: 13.5pt, fill: slate)[
          DE10-Standard Cyclone V SoC FPGA \
          TCP control path from PC clients to FPGA HEX displays
        ]
        #v(16pt)
        #card[Presentation information][
          #grid(
            columns: (auto, 1fr),
            gutter: 8pt,
            row-gutter: 6pt,
            [*Course*], [Embedded Systems | Group 17 | 22DTV_CLC],
            [*Team*], [Five members; names are listed in the technical report],
            [*Duration*], [10-15 minutes],
          )
        ]
      ],
      [
        #photo("assets/20260420_155317_001_57.png", fit: "cover", height: 330pt)
      ],
    )
  ],
)

// ------------------------------------------------------------
// Slide 2 - 60 seconds.
#slide(title: "Main message")[
  #two(
    [
      #text(
        size: 23pt,
        weight: "bold",
        fill: navy,
      )[This is not a collection of separate modules.]
      #v(8pt)
      #text(size: 15pt, fill: slate)[
        The presentation follows one verifiable end-to-end control path:
      ]
      #v(10pt)
      #card[Technical path][
        #align(center)[
          #text(size: 15.5pt, weight: "bold", fill: teal)[PC GUI]
          #text(size: 15.5pt)[ -> ]
          #text(size: 15.5pt, weight: "bold", fill: cyan)[TCP]
          #text(size: 15.5pt)[ -> ]
          #text(size: 15.5pt, weight: "bold", fill: green)[HPS Linux]
          #text(size: 15.5pt)[ -> ]
          #text(size: 15.5pt, weight: "bold", fill: amber)[Bridge]
          #text(size: 15.5pt)[ -> ]
          #text(size: 15.5pt, weight: "bold", fill: rose)[HEX]
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

        metric("5000", [TCP service port on the board], accent: amber),
        metric("LW", [bridge base at 0xFF200000], accent: rose),
      )
    ],
    columns: (1.05fr, .95fr),
  )
]

// ------------------------------------------------------------
// Slide 3 - 70 seconds.
#slide(title: "Problem and scope")[
  #two(
    [
      #card[Input][
        - The user supplies a board IP address, TCP port, and payload of up to six characters.
        - A client sends the payload through a TCP socket on the local LAN.
        - The board returns `OK:<text>` or `ERR:<reason>`.
      ]
      #v(8pt)
      #card[Output][
        - The normalized string appears on HEX5..HEX0.
        - The PC log records each request and response.
        - An Android client uses the same service to validate an independent endpoint.
      ]
    ],
    [
      #card[Deliberately bounded scope][
        - Local LAN only; no Internet or NAT traversal.
        - Functional integration, not measured latency or throughput targets.
        - A simple text-line protocol; no `len/cmd/crc` frame.
        - `devmem` for the prototype; no custom kernel driver.
      ]
      #v(8pt)
      #card(
        fill: rgb("#F0FDFA"),
        stroke: teal.lighten(35%),
        accent: teal,
      )[Prototype value][
        Each layer has observable evidence: a Linux shell, `eth0` address, TCP socket, `OK/ERR` response, and physical HEX state.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 4 - 90 seconds.
#slide(title: "System architecture")[
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    gutter: 7pt,
    align: top + left,
    arrow-step(
      "PC GUI",
      [Enter payload, send TCP, store log],
      accent: cyan,
      fill: rgb("#ECFEFF"),
    ),
    arrow-step(
      "TCP",
      [STREAM socket, one request-response connection],
      accent: teal,
      fill: rgb("#F0FDFA"),
    ),
    arrow-step(
      "HPS Linux",
      [Python service listens on `0.0.0.0:5000`],
      accent: green,
      fill: rgb("#F0FDF4"),
    ),
    arrow-step(
      "Sanitize",
      [Uppercase, filter characters, crop or pad to six],
      accent: amber,
      fill: rgb("#FFFBEB"),
    ),
    arrow-step(
      "Bridge",
      [`devmem` writes the PIO registers],
      accent: rose,
      fill: rgb("#FFF1F2"),
    ),
    arrow-step(
      "HEX",
      [HEX5..HEX0, displayed left to right],
      accent: blue,
      fill: rgb("#EEF2FF"),
    ),
  )
  #v(15pt)
  #two(
    [
      #card(fill: paper, stroke: line, accent: navy)[Design approach][
        Each layer has an input, output, and test method. A failure is isolated at the first broken link instead of guessed across the entire system.
      ]
    ],
    [
      #card(
        fill: rgb("#F0FDFA"),
        stroke: teal.lighten(35%),
        accent: teal,
      )[Speaking point][
        The Android client is not decoration. It shows that the board TCP service is not coupled to the PC GUI.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 5 - 75 seconds.
#slide(title: "Hardware platform and bring-up")[
  #two(
    [
      #photo(
        "assets/de10_standard.jpg",
        caption: [DE10-Standard Cyclone V SoC FPGA],
        fit: "contain",
        height: 72%,
      )
    ],
    [
      #grid(
        columns: (1fr, 1fr),
        gutter: 8pt,
        row-gutter: 8pt,
        photo(
          "assets/msel.jpg",
          caption: [MSEL = 000000],
          fit: "cover",
          height: 95pt,
        ),
        photo(
          "assets/MicroSDCard.png",
          caption: [Boot Linux from MicroSD],
          fit: "contain",
          height: 95pt,
        ),

        photo(
          "assets/DayEtherent.jpg",
          caption: [Ethernet LAN],
          fit: "contain",
          height: 95pt,
        ),
        photo(
          "assets/board_connections.jpg",
          caption: [USB-UART, Ethernet, and power],
          fit: "cover",
          height: 95pt,
        ),
      )
      #v(8pt)
      #card(accent: green)[Minimum bring-up][
        1. Load the bitstream and boot files. \
        2. Boot Linux from MicroSD and open the shell through USB-UART. \
        3. Enable `eth0` and request an address by DHCP. \
        4. Run the TCP server and test it from a PC on the LAN.
      ]
    ],
    columns: (1.05fr, .95fr),
  )
]

// ------------------------------------------------------------
// Slide 6 - 95 seconds.
#slide(title: "Platform Designer map")[
  #two(
    [
      #photo(
        "assets/platform_designer.png",
        caption: [Platform Designer system],
        fit: "contain",
        height: 67%,
      )
      #v(6pt)
      #card(accent: navy)[Hardware-software contract][
        Top-level VHDL connects `pio_hex0_external_export` through `pio_hex5_external_export` to `HEX0` through `HEX5`. HPS code writes the agreed PIO addresses.
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
      #card(
        fill: rgb("#F0FDF4"),
        stroke: green.lighten(35%),
        accent: green,
      )[Quartus result][
        Fitter successful. Logic utilization: *1,960 / 41,910 ALMs (5%)*. Total registers: *2,614*. Total pins: *302 / 499 (61%)*.
      ]
    ],
    columns: (1.08fr, .92fr),
  )
]

// ------------------------------------------------------------
// Slide 7 - 95 seconds.
#slide(title: "HPS Linux firmware")[
  #two(
    [
      #arrow-step(
        "handle_client()",
        [Receive `recv(1024)`, decode UTF-8, process one request, then close the connection.],
        accent: cyan,
        fill: rgb("#ECFEFF"),
      )
      #v(8pt)
      #arrow-step(
        "sanitize_text()",
        [Trim, uppercase, filter unsupported characters, then crop or pad to exactly six.],
        accent: teal,
        fill: rgb("#F0FDFA"),
      )
      #v(8pt)
      #arrow-step(
        "seg() + write_hex()",
        [Encode active-low seven-segment values, then use `devmem` to write six PIO registers.],
        accent: amber,
        fill: rgb("#FFFBEB"),
      )
      #v(8pt)
      #card(
        fill: rgb("#FFF1F2"),
        stroke: rose.lighten(35%),
        accent: rose,
      )[Active-low convention][
        `0` turns a segment on and `1` turns it off. Therefore `8 = 0`, while a blank is `127`.
      ]
    ],
    [
      #block(
        fill: rgb("#F8FAFC"),
        stroke: line,
        radius: 6pt,
        inset: 11pt,
        width: 100%,
      )[
        #text(size: 15pt, weight: "bold", fill: navy)[Server logic core]
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
      #smallnote[For failures, `ERR:<reason>` distinguishes socket, `devmem`, root-permission, and address-map errors.]
    ],
    columns: (.94fr, 1.06fr),
  )
]

// ------------------------------------------------------------
// Slide 8 - 80 seconds.
#slide(title: "Client applications")[
  #two(
    [
      #photo(
        "assets/Python.png",
        caption: [Python/Tkinter PC GUI],
        fit: "contain",
        height: 58%,
      )
      #v(8pt)
      #card(accent: rose)[PC GUI][
        - A dedicated TCP thread keeps the interface responsive.
        - Five-second socket timeout.
        - Clear sent, received, and error logs.
      ]
    ],
    [
      #photo(
        "assets/Android.jpg",
        caption: [Android client using the shared TCP service],
        fit: "contain",
        height: 58%,
      )
      #v(8pt)
      #card(accent: cyan)[Android client][
        - Sends the same newline-terminated UTF-8 payload.
        - Receives the same `OK:<text>` or `ERR:<reason>` response.
        - Confirms that the server is independent of the endpoint.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 9 - 85 seconds.
#slide(title: "End-to-end test")[
  #two(
    [
      #card(accent: green)[Five-step procedure][
        1. Boot Linux and open the shell through USB-UART. \
        2. Enable `eth0`, request a DHCP address, and ping the network. \
        3. Run the TCP server on port `5000`. \
        4. Send a payload from the PC GUI and receive `OK:<text>`. \
        5. Compare HEX5..HEX0 with the normalized string.
      ]
      #v(8pt)
      #card(accent: blue)[Test payloads][
        `HELLO-`, `ABC123`, `P-0001`, `123456`, `------`, an empty string, a string longer than six characters, and unsupported characters.
      ]
    ],
    [
      #photo(
        "assets/20260420_155317_001_109.png",
        caption: [Laptop, router, and board test environment],
        fit: "cover",
        height: 78%,
      )
    ],
    columns: (.95fr, 1.05fr),
  )
]

// ------------------------------------------------------------
// Slide 10 - 80 seconds.
#slide(title: "Results and fault isolation")[
  #two(
    [
      #photo(
        "assets/20260420_155346.jpg",
        caption: [PC and Android controlling the TCP service],
        fit: "cover",
        height: 58%,
      )
      #v(8pt)
      #card(
        fill: rgb("#F0FDF4"),
        stroke: green.lighten(35%),
        accent: green,
      )[Functional result][
        The PC/Android -> TCP -> HPS Linux -> PIO -> HEX path was repeatable on the LAN. Valid payloads receive `OK` and are normalized before display.
      ]
    ],
    [
      #card(accent: amber)[Fault-isolation tree][
        - No shell: check power, MSEL, MicroSD, and USB-UART.
        - Shell but no IP: check Ethernet, DHCP, and `udhcpc`.
        - IP but no connection: check the server and port `5000`.
        - `OK` but wrong HEX: check `seg()`, HEX5..HEX0 order, and VHDL.
        - `ERR`: read the reason; check `devmem`, root permissions, and PIO addresses.
      ]
      #v(8pt)
      #smallnote[The team used a layer-by-layer debugging method, not a one-time successful demonstration.]
    ],
    columns: (1.03fr, .97fr),
  )
]

// ------------------------------------------------------------
// Slide 11 - 70 seconds.
#slide(title: "Limits and next steps")[
  #two(
    [
      #card(
        fill: rgb("#FFF1F2"),
        stroke: rose.lighten(35%),
        accent: rose,
      )[Current limits][
        - The server does not start automatically after reboot.
        - The protocol remains a simple text line.
        - `devmem` suits the prototype but not a long-term product.
        - No authentication, encryption, or command-protection mechanism.
        - No quantitative latency or throughput measurements.
      ]
    ],
    [
      #card(
        fill: rgb("#FFFBEB"),
        stroke: amber.lighten(35%),
        accent: amber,
      )[Next steps][
        - Start the server with init or systemd.
        - Design a `len/cmd/payload/crc` frame.
        - Replace `devmem` with `mmap` or a kernel driver.
        - Add simple LAN authentication.
        - Write automated tests for multiple payloads.
      ]
    ],
  )
  #v(12pt)
  #card(fill: paper, stroke: line, accent: navy)[Response to deeper questions][
    These limits do not remove the project's value: the course objective is integration and verification of a hardware-software path. The team identifies what is prototype scope and what a production system would require.
  ]
]

// ------------------------------------------------------------
// Slide 12 - 45 seconds.
#slide(title: "Conclusion")[
  #align(center + horizon)[
    #block(
      fill: rgb("#F0FDFA"),
      stroke: teal.lighten(35%),
      radius: 8pt,
      inset: 20pt,
      width: 86%,
    )[
      #text(size: 27pt, fill: navy, weight: "bold")[
        The team built a SoC Ethernet prototype with a clear end-to-end control path that can be tested and explained at every layer.
      ]
      #v(14pt)
      #text(size: 17pt, fill: slate)[
        Key point: PC or Android clients send TCP commands; HPS Linux processes them and writes through the lightweight HPS-to-FPGA bridge; FPGA fabric displays the result on HEX0..HEX5.
      ]
      #v(22pt)
      #text(
        size: 24pt,
        fill: teal,
        weight: "bold",
      )[Thank you for your attention.]
    ]
  ]
]
