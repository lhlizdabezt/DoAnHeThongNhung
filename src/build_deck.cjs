const fs = require("fs");
const path = require("path");
const Module = require("module");

const runtimeRoot = "C:\\Users\\Xuan\\.cache\\codex-runtimes\\codex-primary-runtime\\dependencies\\node\\node_modules";
process.env.NODE_PATH = [runtimeRoot, process.env.NODE_PATH].filter(Boolean).join(path.delimiter);
Module._initPaths();
const {
  Presentation,
  PresentationFile,
  row,
  column,
  grid,
  layers,
  panel,
  text,
  image,
  shape,
  rule,
  fill,
  hug,
  fixed,
  wrap,
  grow,
  fr,
  auto,
} = require("@oai/artifact-tool");

const ROOT = "D:\\DoAnHeThongNhung";
const OUT = path.join(ROOT, "output");
const RENDER_DIR = path.join(ROOT, "scratch", "renders");
const REPORT_DIR = path.join(ROOT, "scratch", "reports");

fs.mkdirSync(OUT, { recursive: true });
fs.mkdirSync(RENDER_DIR, { recursive: true });
fs.mkdirSync(REPORT_DIR, { recursive: true });

const W = 1920;
const H = 1080;

const asset = (name) => path.join(ROOT, name);
const dataUrlCache = new Map();

const A = {
  cover: asset("20260420_155317_001_57.png"),
  labWide: asset("20260420_155317_001_109.png"),
  labAndroid: asset("20260420_155346.jpg"),
  labBoard: asset("20260420_155357.jpg"),
  board: asset("de10_standard.jpg"),
  boardConn: asset("board_connections.jpg"),
  msel: asset("msel.jpg"),
  microSd: asset("MicroSDCard.png"),
  ethernet: asset("DayEtherent.jpg"),
  platform: asset("platform_designer.png"),
  pcGui: asset("Python.png"),
  android: asset("Android.jpg"),
};

const C = {
  ink: "#0B1220",
  navy: "#11243A",
  slate: "#334155",
  muted: "#64748B",
  paper: "#F6F8FB",
  white: "#FFFFFF",
  line: "#CBD5E1",
  teal: "#0F766E",
  cyan: "#0891B2",
  green: "#15803D",
  amber: "#B45309",
  rose: "#BE185D",
  blue: "#1D4ED8",
  softTeal: "#D7F4F0",
  softCyan: "#DDF4FF",
  softGreen: "#DCFCE7",
  softAmber: "#FEF3C7",
  softRose: "#FCE7F3",
};

const titleStyle = { fontSize: 54, bold: true, color: C.ink };
const subtitleStyle = { fontSize: 27, color: C.slate };
const kickerStyle = { fontSize: 18, bold: true, color: C.teal };
const bodyStyle = { fontSize: 25, color: C.slate };
const smallStyle = { fontSize: 18, color: C.muted };
const monoStyle = { fontSize: 22, color: "#172033", typeface: "Consolas" };

function addSlide(presentation, node, notes) {
  const slide = presentation.slides.add();
  slide.compose(node, {
    frame: { left: 0, top: 0, width: W, height: H },
    baseUnit: 8,
  });
  slide.speakerNotes.setText(notes.trim());
  return slide;
}

function footer(n, source = "Nguồn: Báo cáo nhóm 17 và mã nguồn đồ án trong workspace.") {
  return row(
    { name: `footer-${n}`, width: fill, height: hug, align: "center", gap: 16 },
    [
      rule({ name: `footer-rule-${n}`, width: grow(1), stroke: "#D7DEE8", weight: 1 }),
      text(`Slide ${n}/10`, {
        name: `footer-page-${n}`,
        width: fixed(120),
        height: hug,
        style: { fontSize: 15, color: C.muted },
      }),
      text(source, {
        name: `footer-source-${n}`,
        width: wrap(700),
        height: hug,
        style: { fontSize: 15, color: C.muted },
      }),
    ],
  );
}

function header(kicker, title, subtitle) {
  const children = [
    text(kicker.toUpperCase(), {
      name: "kicker",
      width: fill,
      height: hug,
      style: kickerStyle,
    }),
    text(title, {
      name: "slide-title",
      width: fill,
      height: hug,
      style: titleStyle,
    }),
  ];
  if (subtitle) {
    children.push(
      text(subtitle, {
        name: "slide-subtitle",
        width: fill,
        height: hug,
        style: subtitleStyle,
      }),
    );
  }
  return column({ name: "header", width: fill, height: hug, gap: 12 }, children);
}

function slideRoot(n, headerNode, bodyNode, source) {
  return grid(
    {
      name: `slide-root-${n}`,
      width: fill,
      height: fill,
      columns: [fr(1)],
      rows: [auto, fr(1), auto],
      rowGap: 34,
      padding: { x: 78, y: 56 },
    },
    [headerNode, bodyNode, footer(n, source)],
  );
}

function imageDataUrl(pathName) {
  if (!dataUrlCache.has(pathName)) {
    const ext = path.extname(pathName).toLowerCase();
    const mime = ext === ".png" ? "image/png" : "image/jpeg";
    const data = fs.readFileSync(pathName).toString("base64");
    dataUrlCache.set(pathName, `data:${mime};base64,${data}`);
  }
  return dataUrlCache.get(pathName);
}

function img(pathName, alt, fit = "cover") {
  return image({
    name: alt.replace(/\s+/g, "-").toLowerCase(),
    dataUrl: imageDataUrl(pathName),
    width: fill,
    height: fill,
    fit,
    alt,
  });
}

function photo(pathName, alt, fit = "cover") {
  return panel(
    {
      name: `${alt.replace(/\s+/g, "-").toLowerCase()}-frame`,
      width: fill,
      height: fill,
      fill: C.white,
      padding: 8,
    },
    img(pathName, alt, fit),
  );
}

function bullet(textValue, color = C.teal, size = 25) {
  return row(
    { name: `bullet-${textValue.slice(0, 14)}`, width: fill, height: hug, gap: 14, align: "center" },
    [
      shape({ name: "mark", geometry: "rect", width: fixed(14), height: fixed(14), fill: color }),
      text(textValue, {
        name: "bullet-text",
        width: fill,
        height: hug,
        style: { ...bodyStyle, fontSize: size },
      }),
    ],
  );
}

function bulletList(items, color = C.teal, size = 25, gap = 18) {
  return column(
    { name: "bullet-list", width: fill, height: hug, gap },
    items.map((item) => bullet(item, color, size)),
  );
}

function stage(label, desc, fillColor, accentColor, width = 238) {
  return panel(
    {
      name: `stage-${label}`,
      width: fixed(width),
      height: fixed(170),
      fill: fillColor,
      padding: { x: 20, y: 18 },
    },
    column(
      { width: fill, height: fill, gap: 10, justify: "center" },
      [
        text(label, {
          name: `stage-label-${label}`,
          width: fill,
          height: hug,
          style: { fontSize: 25, bold: true, color: C.ink },
        }),
        rule({ name: `stage-rule-${label}`, width: fixed(76), stroke: accentColor, weight: 5 }),
        text(desc, {
          name: `stage-desc-${label}`,
          width: fill,
          height: hug,
          style: { fontSize: 18, color: C.slate },
        }),
      ],
    ),
  );
}

function arrow() {
  return text("->", {
    name: "arrow",
    width: fixed(36),
    height: hug,
    style: { fontSize: 30, bold: true, color: C.muted },
  });
}

function twoCol(left, right, gap = 48, ratio = [fr(1), fr(1)]) {
  return grid(
    {
      name: "two-col",
      width: fill,
      height: fill,
      columns: ratio,
      columnGap: gap,
    },
    [left, right],
  );
}

function metricLine(label, value, color = C.teal) {
  return row(
    { name: `metric-${label}`, width: fill, height: hug, gap: 18, align: "center" },
    [
      text(value, {
        name: `metric-value-${label}`,
        width: fixed(190),
        height: hug,
        style: { fontSize: 39, bold: true, color },
      }),
      text(label, {
        name: `metric-label-${label}`,
        width: fill,
        height: hug,
        style: { fontSize: 22, color: C.slate },
      }),
    ],
  );
}

function addressRow(hex, address, target, fillColor = C.white) {
  return panel(
    { name: `addr-row-${hex}`, width: fill, height: fixed(58), fill: fillColor, padding: { x: 18, y: 10 } },
    grid(
      { width: fill, height: fill, columns: [fr(0.8), fr(1.3), fr(0.7)], columnGap: 8 },
      [
        text(hex, { width: fill, height: hug, style: { fontSize: 23, bold: true, color: C.ink } }),
        text(address, { width: fill, height: hug, style: { ...monoStyle, fontSize: 21, color: C.blue } }),
        text(target, { width: fill, height: hug, style: { fontSize: 22, color: C.slate } }),
      ],
    ),
  );
}

function buildDeck() {
  const p = Presentation.create({
    slideSize: { width: W, height: H },
  });

  addSlide(
    p,
    grid(
      {
        name: "cover-root",
        width: fill,
        height: fill,
        columns: [fr(1)],
        rows: [fr(0.62), fr(0.38)],
      },
      [
        img(A.cover, "Anh thuc nghiem board DE10 va HEX", "cover"),
        panel(
          { name: "cover-title-band", width: fill, height: fill, fill: C.ink, padding: { x: 82, y: 48 } },
          grid(
            { width: fill, height: fill, columns: [fr(1.25), fr(0.75)], columnGap: 48 },
            [
              column(
                { width: fill, height: fill, gap: 18, justify: "center" },
                [
                  text("ĐỀ TÀI 13 | NHÓM 17 | 22DTV_CLC", {
                    name: "cover-kicker",
                    width: fill,
                    height: hug,
                    style: { fontSize: 19, bold: true, color: "#72D7C7" },
                  }),
                  text("SoC - Ethernet tích hợp hệ thống, firmware và ứng dụng nhận lệnh TCP từ PC", {
                    name: "cover-title",
                    width: fill,
                    height: hug,
                    style: { fontSize: 47, bold: true, color: C.white },
                  }),
                  text("DE10-Standard Cyclone V SoC FPGA | HPS Linux -> TCP -> HPS-FPGA Bridge -> HEX0..HEX5", {
                    name: "cover-subtitle",
                    width: fill,
                    height: hug,
                    style: { fontSize: 24, color: "#C8D7E4" },
                  }),
                ],
              ),
              column(
                { width: fill, height: fill, gap: 14, justify: "center" },
                [
                  text("GV phụ trách: ThS. Trần Tuấn Kiệt, ThS. Đỗ Quốc Minh Đăng, ThS. Nguyễn Như Hoàng", {
                    name: "cover-teachers",
                    width: fill,
                    height: hug,
                    style: { fontSize: 18, color: "#DDE9F5" },
                  }),
                  text("Thành viên: Văn Đình Nam, Lương Hải Long, Trần Sĩ Nam, Lê Tấn Phi Pha, Vũ Châu Thắng Lợi", {
                    name: "cover-team",
                    width: fill,
                    height: hug,
                    style: { fontSize: 18, color: "#B8C9D9" },
                  }),
                  text("Báo cáo thuyết trình 15 phút | Tháng 4/2026", {
                    name: "cover-date",
                    width: fill,
                    height: hug,
                    style: { fontSize: 18, bold: true, color: "#72D7C7" },
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    `
Muc tieu mo dau: noi ro day la mot do an tich hop, khong chi la GUI hay FPGA rieng le.
Nhan manh cau truc TCP-first: PC gui lenh, board nhan qua HPS Linux, ghi xuong HEX.
Goi y thoi luong: 45 giay.
`,
  );

  addSlide(
    p,
    slideRoot(
      2,
      header(
        "Bối cảnh và mục tiêu",
        "Bài toán được thu hẹp để có hiện vật kiểm chứng ở mỗi tầng",
        "Trong 15 phút, cần chứng minh được đường đi điều khiển đầu-cuối thay vì trình bày dài lý thuyết.",
      ),
      twoCol(
        column(
          { width: fill, height: fill, gap: 28, justify: "center" },
          [
            bulletList(
              [
                "HPS đảm nhận Linux, Ethernet và socket TCP.",
                "FPGA fabric cung cấp ngoại vi tùy biến: sáu PIO 7 bit cho HEX.",
                "PC GUI là đầu cuối chính; Android client dùng để đối chiếu.",
                "Phạm vi: mạng LAN cục bộ, chưa đo hiệu năng định lượng hay bảo mật.",
              ],
              C.teal,
              27,
              22,
            ),
          ],
        ),
        column(
          { width: fill, height: fill, gap: 22, justify: "center" },
          [
            metricLine("luồng kỹ thuật xuyên suốt: PC -> TCP -> HPS -> Bridge -> HEX", "1", C.teal),
            metricLine("ký tự tối đa hiển thị trên HEX0..HEX5", "6", C.blue),
            metricLine("cổng dịch vụ TCP trên board", "5000", C.amber),
            metricLine("địa chỉ bridge bắt đầu tại 0xFF200000", "LW", C.rose),
          ],
        ),
        70,
        [fr(1.05), fr(0.95)],
      ),
      "Tóm tắt, Chương 1 và Chương 2 của báo cáo PDF.",
    ),
    `
Slide nay dat van de: do an can noi duoc phan mem he thong voi ngoai vi vat ly.
Neu thay hoi tai sao chon TCP: vi TCP co ket noi, dam bao thu tu byte va co phan hoi OK/ERR ro rang.
Neu thay hoi pham vi: nhom chu dong gioi han vao LAN de tap trung vao tich hop chuc nang.
`,
  );

  addSlide(
    p,
    slideRoot(
      3,
      header(
        "Kiến trúc tổng thể",
        "Luôn giữ một trục TCP-first để khoanh vùng lỗi nhanh",
        "Mỗi tầng có đầu vào, đầu ra và cách kiểm thử độc lập.",
      ),
      column(
        { width: fill, height: fill, gap: 36, justify: "center" },
        [
          row(
            { name: "architecture-pipeline", width: fill, height: hug, gap: 12, align: "center", justify: "center" },
            [
              stage("PC GUI", "Nhập IP, cổng và payload 6 ký tự", C.softCyan, C.cyan, 210),
              arrow(),
              stage("TCP", "Kết nối STREAM, gửi yêu cầu và nhận OK/ERR", C.softTeal, C.teal, 210),
              arrow(),
              stage("HPS Linux", "Server Python lắng nghe 0.0.0.0:5000", C.softGreen, C.green, 225),
              arrow(),
              stage("Mã hóa", "sanitize_text + seg active-low", C.softAmber, C.amber, 205),
              arrow(),
              stage("Bridge", "devmem ghi thanh ghi PIO", C.softRose, C.rose, 205),
              arrow(),
              stage("HEX", "HEX5..HEX0 hiển thị trái qua phải", "#E9EEFF", C.blue, 200),
            ],
          ),
          panel(
            { name: "architecture-note", width: fill, height: hug, fill: C.white, padding: { x: 34, y: 26 } },
            text("Android client dùng chung dịch vụ TCP: nếu Android điều khiển được HEX, server board-side không phụ thuộc loại đầu cuối.", {
              name: "architecture-proof",
              width: fill,
              height: hug,
              style: { fontSize: 29, bold: true, color: C.ink },
            }),
          ),
        ],
      ),
      "Chương 1.3 và 3.1 của báo cáo PDF.",
    ),
    `
Day la slide can giai thich ro nhat.
Neu thay hoi tinh dong gop: dong gop nam o viec tach tang va kiem chung moi tang, khong phai o thuat toan phuc tap.
Goi y thoi luong: 1.5 phut.
`,
  );

  addSlide(
    p,
    slideRoot(
      4,
      header(
        "Nền tảng phần cứng và bring-up",
        "DE10-Standard cung cấp đồng thời HPS Linux và FPGA fabric",
        "Quá trình bring-up dùng MicroSD, USB-UART, Ethernet và MSEL = 000000.",
      ),
      twoCol(
        photo(A.board, "So do board DE10-Standard", "contain"),
        grid(
          { name: "bringup-grid", width: fill, height: fill, rows: [fr(1), fr(1)], columns: [fr(1), fr(1)], rowGap: 18, columnGap: 18 },
          [
            photo(A.msel, "Công tắc MSEL", "cover"),
            photo(A.microSd, "Thẻ MicroSD", "contain"),
            photo(A.ethernet, "Dây Ethernet", "contain"),
            photo(A.boardConn, "Kết nối board", "cover"),
          ],
        ),
        44,
        [fr(1.05), fr(0.95)],
      ),
      "Báo cáo PDF mục 2.1, 2.2 và hình ảnh trong workspace.",
    ),
    `
Noi ngan gon: board boot Linux tu MicroSD, serial console qua USB-UART, eth0 xin IP qua DHCP.
Neu thay hoi vi sao dung Linux: de tan dung TCP/IP stack va cong cu user-space nhu Python, shell, devmem.
Can tranh sa vao thong so board qua nhieu.
`,
  );

  addSlide(
    p,
    slideRoot(
      5,
      header(
        "Platform Designer và bản đồ địa chỉ",
        "Sáu PIO 7 bit được ánh xạ nhất quán từ Qsys đến code Python",
        "Đây là hợp đồng quan trọng giữa phần cứng, firmware và ứng dụng.",
      ),
      twoCol(
        column(
          { width: fill, height: fill, gap: 18 },
          [
            photo(A.platform, "Platform Designer soc_system", "contain"),
            text("project.vhd đấu nối pio_hex0_external_export..pio_hex5_external_export ra HEX0..HEX5 vật lý.", {
              name: "vhdl-note",
              width: fill,
              height: hug,
              style: { fontSize: 25, bold: true, color: C.ink },
            }),
          ],
        ),
        column(
          { width: fill, height: fill, gap: 8, justify: "center" },
          [
            addressRow("pio_hex0", "0xFF200040", "HEX0", "#F8FAFC"),
            addressRow("pio_hex1", "0xFF200050", "HEX1"),
            addressRow("pio_hex2", "0xFF200060", "HEX2", "#F8FAFC"),
            addressRow("pio_hex3", "0xFF200070", "HEX3"),
            addressRow("pio_hex4", "0xFF200080", "HEX4", "#F8FAFC"),
            addressRow("pio_hex5", "0xFF200090", "HEX5"),
            text("Logic utilization: 1,960 / 41,910 ALMs (5%) | Fitter: Successful", {
              name: "quartus-summary",
              width: fill,
              height: hug,
              style: { fontSize: 21, bold: true, color: C.green },
            }),
          ],
        ),
        54,
        [fr(1.05), fr(0.95)],
      ),
      "Báo cáo PDF mục 3.2; project.fit.summary trong source Quartus.",
    ),
    `
Can noi ro dia chi la phan cam ket giua Platform Designer, hex_text.sh va board_tcp_hex_server.py.
Neu thay hoi ve thu tu HEX: HEX5 nam ben trai, HEX0 ben phai nen code ghi dao thu tu de chuoi doc tu trai sang phai.
Co the nhac Fitter thanh cong va tai nguyen ALM chi khoang 5%.
`,
  );

  addSlide(
    p,
    slideRoot(
      6,
      header(
        "Firmware trên HPS Linux",
        "Server TCP gồm ba lớp nhỏ: nhận payload, mã hóa, ghi thanh ghi",
        "Việc không gọi script shell trong server giúp giảm fork/exec và dễ đọc lỗi hơn.",
      ),
      twoCol(
        column(
          { width: fill, height: fill, gap: 22, justify: "center" },
          [
            stage("handle_client", "recv(1024), decode UTF-8, đóng kết nối sau mỗi request", C.softCyan, C.cyan, 520),
            stage("sanitize_text", "upper-case, lọc ký tự, cắt/pad về đúng 6 ký tự", C.softTeal, C.teal, 520),
            stage("seg + write_hex", "mã 7 đoạn active-low và devmem đến 6 địa chỉ PIO", C.softAmber, C.amber, 520),
          ],
        ),
        panel(
          { name: "firmware-code-panel", width: fill, height: fill, fill: "#F8FAFC", padding: { x: 34, y: 30 } },
          column(
            { width: fill, height: fill, gap: 20, justify: "center" },
            [
              text("Lõi logic board_tcp_hex_server.py", {
                name: "code-title",
                width: fill,
                height: hug,
                style: { fontSize: 28, bold: true, color: C.ink },
              }),
              text(
                [
                  "s.bind((\"0.0.0.0\", 5000)); s.listen(5)",
                  "data = conn.recv(1024)",
                  "text = sanitize_text(data)",
                  "v5..v0 = (seg(c) for c in text[:6])",
                  "devmem 0xFF200040..90 32 value",
                  "conn.sendall(\"OK:%s\\n\" % text)",
                ].join("\n"),
                {
                  name: "code-snippet",
                  width: fill,
                  height: hug,
                  style: { ...monoStyle, fontSize: 24 },
                },
              ),
              text("Phản hồi lỗi theo dạng ERR:<lý do> giúp phân biệt lỗi socket, lỗi devmem hoặc lỗi địa chỉ.", {
                name: "code-note",
                width: fill,
                height: hug,
                style: { fontSize: 24, color: C.slate },
              }),
            ],
          ),
        ),
        50,
        [fr(0.9), fr(1.1)],
      ),
      "Báo cáo PDF mục 3.3 và Phụ lục C.",
    ),
    `
Giai thich theo thu tu: socket -> sanitize -> seg -> devmem -> OK/ERR.
Nhan manh active-low: 0 la bat doan, 1 la tat doan; vi vay '8' = 0 va space = 127.
Neu thay hoi ve bao mat: hien tai chua co xac thuc, day la huong phat trien.
`,
  );

  addSlide(
    p,
    slideRoot(
      7,
      header(
        "Ứng dụng đầu cuối",
        "PC GUI là đầu cuối chính; Android client chung một giao thức để đối chiếu",
        "Hai ứng dụng chỉ cần biết IP board, cổng 5000 và payload tối đa 6 ký tự.",
      ),
      twoCol(
        column(
          { width: fill, height: fill, gap: 18 },
          [
            photo(A.pcGui, "Giao dien Python Tkinter", "contain"),
            bulletList(
              [
                "socket timeout 5 s để tránh treo GUI.",
                "thread riêng cho thao tác TCP.",
                "log tách rõ dòng gửi, dòng nhận và lỗi.",
              ],
              C.rose,
              23,
              14,
            ),
          ],
        ),
        column(
          { width: fill, height: fill, gap: 18 },
          [
            photo(A.android, "Ung dung Android client", "contain"),
            bulletList(
              [
                "Cùng gửi chuỗi UTF-8 kết thúc bằng newline.",
                "Cùng nhận OK:<text> hoặc ERR:<lý do>.",
                "Chứng minh server không phụ thuộc endpoint.",
              ],
              C.cyan,
              23,
              14,
            ),
          ],
        ),
        56,
        [fr(1), fr(1)],
      ),
      "Báo cáo PDF mục 3.4; pc_hex_tcp_pink_gui.py và ảnh Android.jpg trong workspace.",
    ),
    `
Noi slide nay de thay thay duoc san pham nguoi dung cuoi.
Neu thay hoi vi sao dung Android: khong phai thay PC GUI, ma la phep kiem tra doc lap cho dich vu TCP tren board.
`,
  );

  addSlide(
    p,
    slideRoot(
      8,
      header(
        "Kiểm thử đầu-cuối",
        "Quy trình kiểm thử đi từ tầng thấp lên cao để không đổ lỗi sai tầng",
        "Mỗi bước chỉ chuyển tiếp khi bước trước đã chắc đúng.",
      ),
      twoCol(
        column(
          { width: fill, height: fill, gap: 18, justify: "center" },
          [
            bulletList(
              [
                "1. Boot Linux và vào shell qua USB-UART.",
                "2. Bật eth0, xin IP DHCP và ping board.",
                "3. Chạy server TCP ở cổng 5000.",
                "4. Gửi payload bằng PC GUI và nhận OK:<text>.",
                "5. Đối chiếu HEX5..HEX0 với chuỗi đã chuẩn hóa.",
              ],
              C.green,
              28,
              20,
            ),
          ],
        ),
        photo(A.labWide, "Moi truong kiem thu laptop va board", "cover"),
        54,
        [fr(0.95), fr(1.05)],
      ),
      "Báo cáo PDF mục 4.1 và 4.2; ảnh thực nghiệm trong workspace.",
    ),
    `
Slide nay la cau chuyen demo neu thuyet trinh: boot, mang, server, GUI, HEX.
Nhac rang nhom chua do latency dinh luong; ket qua hien tai la dung chuc nang va lap lai duoc.
`,
  );

  addSlide(
    p,
    slideRoot(
      9,
      header(
        "Kết quả và khoanh vùng lỗi",
        "Kết quả chức năng đạt; lỗi được khoanh theo vị trí đầu tiên bị đứt mạch",
        "Bảng payload và cây lỗi giúp trả lời nhanh khi thầy hỏi về độ tin cậy.",
      ),
      twoCol(
        column(
          { width: fill, height: fill, gap: 18, justify: "center" },
          [
            panel(
              { name: "payload-table", width: fill, height: hug, fill: "#F8FAFC", padding: { x: 28, y: 24 } },
              column(
                { width: fill, height: hug, gap: 14 },
                [
                  text("Payload kiểm thử", {
                    name: "payload-title",
                    width: fill,
                    height: hug,
                    style: { fontSize: 30, bold: true, color: C.ink },
                  }),
                  text("HELLO- | ABC123 | P-0001 | 123456 | ------ | <space>", {
                    name: "payload-main",
                    width: fill,
                    height: hug,
                    style: { ...monoStyle, fontSize: 28, color: C.blue },
                  }),
                  text("Biên: chuỗi rỗng -> tắt HEX; hello- -> HELLO-; HELLOWORLD -> HELLOW; ký tự ngoài bảng -> space.", {
                    name: "payload-edge",
                    width: fill,
                    height: hug,
                    style: { fontSize: 23, color: C.slate },
                  }),
                ],
              ),
            ),
            photo(A.labAndroid, "Ket qua PC va Android cung dich vu TCP", "cover"),
          ],
        ),
        column(
          { width: fill, height: fill, gap: 16, justify: "center" },
          [
            bullet("Không có shell: kiểm nguồn, MSEL, MicroSD, USB-UART.", C.rose, 24),
            bullet("Có shell, không IP: kiểm Ethernet, DHCP, udhcpc.", C.amber, 24),
            bullet("Có IP, client không kết nối: kiểm server và cổng 5000.", C.cyan, 24),
            bullet("OK nhưng HEX sai: kiểm seg(), thứ tự HEX5..HEX0, VHDL.", C.blue, 24),
            bullet("ERR: đọc thông điệp, kiểm devmem, quyền root, địa chỉ.", C.green, 24),
          ],
        ),
        52,
        [fr(1.08), fr(0.92)],
      ),
      "Báo cáo PDF mục 4.2 và 4.3.",
    ),
    `
Neu thay hoi test case: dua bang payload va cac bien.
Neu thay hoi loi da gap: sai IP sau reboot router, server chua chay sau reboot Linux, quen nap .sof, Android o Wi-Fi guest.
Noi ngan gon ve OK/ERR de chung minh co co che quan sat loi.
`,
  );

  addSlide(
    p,
    slideRoot(
      10,
      header(
        "Kết luận và hướng phát triển",
        "Đồ án đã ghép được phần cứng, Linux, TCP và ứng dụng thành một luồng có thể lặp lại",
        "Giá trị chính nằm ở khả năng giải thích, kiểm thử và mở rộng có kỷ luật.",
      ),
      twoCol(
        column(
          { width: fill, height: fill, gap: 22, justify: "center" },
          [
            text("Đã hoàn thành", {
              name: "done-title",
              width: fill,
              height: hug,
              style: { fontSize: 34, bold: true, color: C.green },
            }),
            bulletList(
              [
                "Platform Designer + top-level VHDL cho PIO HEX.",
                "HPS Linux boot từ MicroSD, eth0 hoạt động trong LAN.",
                "Server TCP 5000 chuẩn hóa payload và ghi devmem.",
                "PC GUI và Android client điều khiển cùng dịch vụ.",
              ],
              C.green,
              26,
              18,
            ),
          ],
        ),
        column(
          { width: fill, height: fill, gap: 22, justify: "center" },
          [
            text("Mở rộng tiếp theo", {
              name: "next-title",
              width: fill,
              height: hug,
              style: { fontSize: 34, bold: true, color: C.amber },
            }),
            bulletList(
              [
                "Tự khởi động server bằng init/systemd.",
                "Frame giao thức có len, cmd, payload, crc.",
                "Thay devmem bằng mmap hoặc driver.",
                "Thêm xác thực và đo latency/throughput.",
              ],
              C.amber,
              26,
              18,
            ),
          ],
        ),
        56,
        [fr(1), fr(1)],
      ),
      "Báo cáo PDF Chương 5.",
    ),
    `
Ket lai bang thong diep: nhom da lam duoc mot prototype co duong di dau-cuoi ro rang.
Neu thay hoi han che, noi thang: chua tu dong start, chua bao mat, chua co giao thuc frame, devmem chi phu hop prototype.
Cuoi slide de moi thay dat cau hoi.
`,
  );

  return p;
}

async function writeBlobToFile(blob, filePath) {
  const buffer = Buffer.from(await blob.arrayBuffer());
  fs.writeFileSync(filePath, buffer);
}

async function renderImportedPptx(pptxPath) {
  const imported = await PresentationFile.importPptx(fs.readFileSync(pptxPath));
  const rendered = [];
  for (let i = 0; i < imported.slides.count; i++) {
    const slide = imported.slides.getItem(i);
    const blob = await slide.export({ format: "png" });
    const file = path.join(RENDER_DIR, `deck_slide_${String(i + 1).padStart(2, "0")}.png`);
    await writeBlobToFile(blob, file);
    rendered.push(file);
  }
  return rendered;
}

async function main() {
  const deck = buildDeck();
  const pptxPath = path.join(OUT, "17_TH_HTN_22DTV_CLC_presentation.pptx");
  const pptx = await PresentationFile.exportPptx(deck);
  await pptx.save(pptxPath);

  const rendered = await renderImportedPptx(pptxPath);

  const manifest = {
    deck: pptxPath,
    rendered,
    slideCount: rendered.length,
    generatedAt: new Date().toISOString(),
  };
  fs.writeFileSync(path.join(REPORT_DIR, "deck_manifest.json"), JSON.stringify(manifest, null, 2), "utf8");
  console.log(JSON.stringify(manifest, null, 2));
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
