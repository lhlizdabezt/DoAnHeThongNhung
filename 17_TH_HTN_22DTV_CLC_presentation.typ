#import "@preview/touying:0.5.3": *
#import "stargazer.typ": *

#set text(font: ("Segoe UI", "Arial", "New Computer Modern"), lang: "vi")
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
    title: [SoC - Ethernet tích hợp hệ thống],
    subtitle: [Firmware và ứng dụng nhận lệnh TCP từ PC],
    author: [Nhóm 17 - 22DTV_CLC],
    instructor: [ThS. Trần Tuấn Kiệt, ThS. Đỗ Quốc Minh Đăng, ThS. Nguyễn Như Hoàng],
    date: "05/2026",
    institution: [Khoa Điện tử - Viễn thông, Trường Đại học Khoa học Tự nhiên, ĐHQG-HCM],
  ),
)

// Kịch bản tổng: 12 slide, 10-15 phút.
// Nhịp nói khuyến nghị:
// 1) Mở đầu và mục tiêu: 2 phút.
// 2) Kiến trúc, phần cứng, address map: 4 phút.
// 3) Firmware, client, kiểm thử: 5 phút.
// 4) Kết quả, hạn chế, kết luận: 2-3 phút.

// ------------------------------------------------------------
// Slide 1 - 45 giây.
#slide(navigation: none, progress-bar: false, self => [
  #grid(
    columns: (1.05fr, .95fr),
    gutter: 18pt,
    align: horizon,
    [
      #v(5pt)
      #chip[Đề tài 13 | Nhóm 17 | 22DTV_CLC]
      #v(18pt)
      #text(size: 31pt, fill: navy, weight: "bold")[
        SoC - Ethernet tích hợp hệ thống, firmware và ứng dụng nhận lệnh TCP từ PC
      ]
      #v(12pt)
      #text(size: 16pt, fill: slate)[
        DE10-Standard Cyclone V SoC FPGA \
        HPS Linux -> TCP -> Lightweight HPS-FPGA Bridge -> HEX0..HEX5
      ]
      #v(18pt)
      #card[Thông tin báo cáo][
        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          row-gutter: 6pt,
          [*GV phụ trách*], [ThS. Trần Tuấn Kiệt; ThS. Đỗ Quốc Minh Đăng; ThS. Nguyễn Như Hoàng],
          [*Thành viên*], [Văn Đình Nam; Lương Hải Long; Trần Sĩ Nam; Lê Tấn Phi Pha; Vũ Châu Thắng Lợi],
          [*Thời lượng*], [10-15 phút],
        )
      ]
    ],
    [
      #photo("assets/20260420_155317_001_57.png", fit: "cover", height: 100%)
    ],
  )
])

// ------------------------------------------------------------
// Slide 2 - 60 giây.
#slide(title: "Thông điệp chính")[
  #two(
    [
      #text(size: 23pt, weight: "bold", fill: navy)[Không trình bày rời rạc từng module.]
      #v(8pt)
      #text(size: 15pt, fill: slate)[
        Trục trình bày là một luồng điều khiển đầu-cuối có thể kiểm chứng:
      ]
      #v(10pt)
      #card[Luồng kỹ thuật][
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
        metric("1", [đường đi điều khiển xuyên suốt], accent: teal),
        metric("6", [ký tự tối đa trên HEX0..HEX5], accent: blue),
        metric("5000", [cổng dịch vụ TCP trên board], accent: amber),
        metric("LW", [bridge tại vùng 0xFF200000], accent: rose),
      )
      #v(10pt)
      #smallnote[Điểm cần thuyết phục thầy: nhóm không chỉ làm giao diện, mà đã nối được phần mềm hệ thống với ngoại vi phần cứng quan sát được.]
    ],
    columns: (1.05fr, .95fr),
  )
]

// ------------------------------------------------------------
// Slide 3 - 70 giây.
#slide(title: "Bài toán và phạm vi")[
  #two(
    [
      #card[Đầu vào][
        - Người dùng nhập IP board, cổng TCP và chuỗi tối đa 6 ký tự.
        - Client gửi payload qua socket TCP trong cùng mạng LAN.
        - Board phản hồi `OK:<text>` hoặc `ERR:<reason>`.
      ]
      #v(8pt)
      #card[Đầu ra][
        - Chuỗi đã chuẩn hóa được hiển thị trên cụm HEX5..HEX0.
        - Có log phía PC để đối chiếu request/response.
        - Có Android client dùng chung dịch vụ để kiểm chứng endpoint độc lập.
      ]
    ],
    [
      #card[Phạm vi chủ động giới hạn][
        - Mạng LAN cục bộ, chưa xử lý Internet/NAT.
        - Tập trung đúng chức năng, chưa đo latency/throughput định lượng.
        - Giao thức hiện ở mức text line đơn giản, chưa có frame `len/cmd/crc`.
        - Dùng `devmem` phù hợp prototype, chưa viết kernel driver.
      ]
      #v(8pt)
      #card(fill: rgb("#F0FDFA"), stroke: teal.lighten(35%), accent: teal)[Giá trị của prototype][
        Nhóm có hiện vật quan sát được ở từng tầng: Linux shell, IP `eth0`, socket TCP, phản hồi `OK/ERR`, và trạng thái vật lý trên HEX.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 4 - 90 giây.
#slide(title: "Kiến trúc tổng thể")[
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    gutter: 7pt,
    align: top + left,
    arrow-step("PC GUI", [Nhập payload, gửi TCP, ghi log], accent: cyan, fill: rgb("#ECFEFF")),
    arrow-step("TCP", [STREAM socket, request/response một kết nối], accent: teal, fill: rgb("#F0FDFA")),
    arrow-step("HPS Linux", [Server Python lắng nghe `0.0.0.0:5000`], accent: green, fill: rgb("#F0FDF4")),
    arrow-step("Sanitize", [Upper-case, lọc ký tự, cắt/pad đúng 6], accent: amber, fill: rgb("#FFFBEB")),
    arrow-step("Bridge", [`devmem` ghi các thanh ghi PIO], accent: rose, fill: rgb("#FFF1F2")),
    arrow-step("HEX", [HEX5..HEX0 hiển thị trái qua phải], accent: blue, fill: rgb("#EEF2FF")),
  )
  #v(15pt)
  #two(
    [
      #card(fill: paper, stroke: line, accent: navy)[Tư duy thiết kế][
        Mỗi tầng có đầu vào, đầu ra và cách kiểm thử riêng. Vì vậy khi lỗi xảy ra, nhóm khoanh vùng theo vị trí đầu tiên bị đứt mạch thay vì đoán toàn hệ thống.
      ]
    ],
    [
      #card(fill: rgb("#F0FDFA"), stroke: teal.lighten(35%), accent: teal)[Điểm nhấn khi nói][
        Android client không phải sản phẩm phụ để trang trí. Nó chứng minh dịch vụ TCP trên board không phụ thuộc riêng vào PC GUI.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 5 - 75 giây.
#slide(title: "Nền tảng phần cứng và bring-up")[
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
        photo("assets/MicroSDCard.png", caption: [Boot Linux từ MicroSD], fit: "contain", height: 95pt),
        photo("assets/DayEtherent.jpg", caption: [Ethernet LAN], fit: "contain", height: 95pt),
        photo("assets/board_connections.jpg", caption: [USB-UART + Ethernet + nguồn], fit: "cover", height: 95pt),
      )
      #v(8pt)
      #card(accent: green)[Bring-up tối thiểu][
        1. Nạp/cấu hình bitstream và file boot. \
        2. Boot Linux qua MicroSD, vào shell bằng USB-UART. \
        3. Bật `eth0`, xin IP bằng DHCP. \
        4. Chạy TCP server và kiểm thử từ PC trong LAN.
      ]
    ],
    columns: (1.05fr, .95fr),
  )
]

// ------------------------------------------------------------
// Slide 6 - 95 giây.
#slide(title: "Platform Designer và address map")[
  #two(
    [
      #photo("assets/platform_designer.png", caption: [Hệ thống Platform Designer], fit: "contain", height: 67%)
      #v(6pt)
      #card(accent: navy)[Hợp đồng phần cứng - phần mềm][
        Top-level VHDL nối `pio_hex0_external_export`..`pio_hex5_external_export` ra `HEX0`..`HEX5`. Code HPS chỉ cần ghi đúng địa chỉ PIO đã thống nhất.
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
      #card(fill: rgb("#F0FDF4"), stroke: green.lighten(35%), accent: green)[Kết quả Quartus][
        Fitter successful. Logic utilization: *1,960 / 41,910 ALMs (5%)*. Total registers: *2,614*. Total pins: *302 / 499 (61%)*.
      ]
    ],
    columns: (1.08fr, .92fr),
  )
]

// ------------------------------------------------------------
// Slide 7 - 95 giây.
#slide(title: "Firmware trên HPS Linux")[
  #two(
    [
      #arrow-step("handle_client()", [Nhận `recv(1024)`, decode UTF-8, xử lý một request rồi đóng kết nối.], accent: cyan, fill: rgb("#ECFEFF"))
      #v(8pt)
      #arrow-step("sanitize_text()", [Strip, upper-case, lọc ký tự ngoài bảng, cắt hoặc pad về đúng 6 ký tự.], accent: teal, fill: rgb("#F0FDFA"))
      #v(8pt)
      #arrow-step("seg() + write_hex()", [Mã hóa 7 đoạn active-low rồi gọi `devmem` ghi 6 thanh ghi PIO.], accent: amber, fill: rgb("#FFFBEB"))
      #v(8pt)
      #card(fill: rgb("#FFF1F2"), stroke: rose.lighten(35%), accent: rose)[Active-low][
        `0` nghĩa là bật đoạn, `1` nghĩa là tắt đoạn. Vì vậy `8 = 0`, còn khoảng trắng là `127`.
      ]
    ],
    [
      #block(fill: rgb("#F8FAFC"), stroke: line, radius: 6pt, inset: 11pt, width: 100%)[
        #text(size: 15pt, weight: "bold", fill: navy)[Lõi logic server]
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
      #smallnote[Nếu thầy hỏi về lỗi: server trả `ERR:<reason>`, nhờ đó phân biệt lỗi socket, lỗi `devmem`, lỗi quyền root hoặc sai address map.]
    ],
    columns: (.94fr, 1.06fr),
  )
]

// ------------------------------------------------------------
// Slide 8 - 80 giây.
#slide(title: "Ứng dụng đầu cuối")[
  #two(
    [
      #photo("assets/Python.png", caption: [PC GUI Python/Tkinter], fit: "contain", height: 58%)
      #v(8pt)
      #card(accent: rose)[PC GUI][
        - Thread riêng cho thao tác TCP để giao diện không treo.
        - Timeout 5 giây cho socket.
        - Log rõ dòng gửi, dòng nhận và lỗi.
      ]
    ],
    [
      #photo("assets/Android.jpg", caption: [Android client dùng chung TCP service], fit: "contain", height: 58%)
      #v(8pt)
      #card(accent: cyan)[Android client][
        - Gửi cùng payload UTF-8 kết thúc bằng newline.
        - Nhận cùng `OK:<text>` hoặc `ERR:<reason>`.
        - Dùng để đối chiếu rằng server không phụ thuộc endpoint.
      ]
    ],
  )
]

// ------------------------------------------------------------
// Slide 9 - 85 giây.
#slide(title: "Kiểm thử đầu-cuối")[
  #two(
    [
      #card(accent: green)[Quy trình 5 bước][
        1. Boot Linux và vào shell qua USB-UART. \
        2. Bật `eth0`, xin IP DHCP, ping kiểm tra mạng. \
        3. Chạy server TCP ở cổng `5000`. \
        4. Gửi payload bằng PC GUI và nhận `OK:<text>`. \
        5. Đối chiếu HEX5..HEX0 với chuỗi đã chuẩn hóa.
      ]
      #v(8pt)
      #card(accent: blue)[Payload kiểm thử][
        `HELLO-`, `ABC123`, `P-0001`, `123456`, `------`, chuỗi rỗng, chuỗi dài hơn 6 ký tự, ký tự ngoài bảng.
      ]
    ],
    [
      #photo("assets/20260420_155317_001_109.png", caption: [Môi trường kiểm thử laptop - router - board], fit: "cover", height: 78%)
    ],
    columns: (.95fr, 1.05fr),
  )
]

// ------------------------------------------------------------
// Slide 10 - 80 giây.
#slide(title: "Kết quả và cách khoanh vùng lỗi")[
  #two(
    [
      #photo("assets/20260420_155346.jpg", caption: [PC/Android cùng điều khiển dịch vụ TCP], fit: "cover", height: 58%)
      #v(8pt)
      #card(fill: rgb("#F0FDF4"), stroke: green.lighten(35%), accent: green)[Kết quả chức năng][
        Luồng PC/Android -> TCP -> HPS Linux -> PIO -> HEX hoạt động lặp lại được trong LAN. Payload hợp lệ nhận `OK`, payload được chuẩn hóa trước khi hiển thị.
      ]
    ],
    [
      #card(accent: amber)[Cây khoanh vùng lỗi][
        - Không có shell: kiểm nguồn, MSEL, MicroSD, USB-UART.
        - Có shell, không IP: kiểm Ethernet, DHCP, `udhcpc`.
        - Có IP, client không kết nối: kiểm server và cổng `5000`.
        - Có `OK` nhưng HEX sai: kiểm `seg()`, thứ tự HEX5..HEX0, VHDL.
        - Có `ERR`: đọc reason, kiểm `devmem`, quyền root, địa chỉ PIO.
      ]
      #v(8pt)
      #smallnote[Đây là phần nên nói chắc: nhóm có phương pháp debug theo tầng, không chỉ demo thành công một lần.]
    ],
    columns: (1.03fr, .97fr),
  )
]

// ------------------------------------------------------------
// Slide 11 - 70 giây.
#slide(title: "Hạn chế và hướng phát triển")[
  #two(
    [
      #card(fill: rgb("#FFF1F2"), stroke: rose.lighten(35%), accent: rose)[Hạn chế hiện tại][
        - Server chưa tự khởi động sau reboot.
        - Giao thức còn là dòng text đơn giản.
        - `devmem` phù hợp prototype nhưng chưa tối ưu cho sản phẩm lâu dài.
        - Chưa có xác thực, mã hóa hay cơ chế chống gửi lệnh ngoài ý muốn.
        - Chưa đo định lượng latency/throughput.
      ]
    ],
    [
      #card(fill: rgb("#FFFBEB"), stroke: amber.lighten(35%), accent: amber)[Phát triển tiếp][
        - Tự khởi động server bằng init/systemd.
        - Thiết kế frame `len/cmd/payload/crc`.
        - Thay `devmem` bằng `mmap` hoặc kernel driver.
        - Thêm xác thực đơn giản trong LAN.
        - Ghi script test tự động cho nhiều payload.
      ]
    ],
  )
  #v(12pt)
  #card(fill: paper, stroke: line, accent: navy)[Thông điệp trả lời khi bị hỏi sâu][
    Các hạn chế trên không làm mất giá trị của đồ án, vì mục tiêu học phần là tích hợp và kiểm chứng được chuỗi phần cứng - phần mềm. Nhóm đã biết rõ điểm nào là prototype và điểm nào cần nâng cấp nếu đưa vào hệ thống nghiêm túc hơn.
  ]
]

// ------------------------------------------------------------
// Slide 12 - 45 giây.
#slide(title: "Kết luận")[
  #align(center + horizon)[
    #block(fill: rgb("#F0FDFA"), stroke: teal.lighten(35%), radius: 8pt, inset: 20pt, width: 86%)[
      #text(size: 27pt, fill: navy, weight: "bold")[
        Nhóm đã xây dựng được một prototype SoC - Ethernet có luồng điều khiển đầu-cuối rõ ràng, có thể kiểm thử và giải thích theo từng tầng.
      ]
      #v(14pt)
      #text(size: 17pt, fill: slate)[
        Điểm chính cần nhớ: PC/Android gửi lệnh TCP, HPS Linux xử lý và ghi qua Lightweight HPS-FPGA Bridge, FPGA fabric hiển thị kết quả trên HEX0..HEX5.
      ]
      #v(22pt)
      #text(size: 24pt, fill: teal, weight: "bold")[Xin cảm ơn thầy/cô đã lắng nghe.]
    ]
  ]
]
