# Release notes - v1.0.2

## Điểm chính

- Thay các visual phụ thuộc dịch vụ ngoài bằng asset tự host trong repo: `assets/soc-ethernet-hero.svg` và `assets/soc-ethernet-flow.gif`.
- Bổ sung đường kiểm tra nhanh cho HR/kỹ sư: GUI PC/Android, HPS/Linux, bridge HPS-FPGA, Platform Designer, báo cáo và release.
- Giữ README, bảng biểu và chú thích bằng tiếng Việt; riêng SVG dùng tiếng Anh/ASCII-safe để tránh lỗi hiển thị dấu tiếng Việt.
- Đóng gói release như mốc review kỹ thuật: báo cáo PDF, slide PDF, Typst source, PowerPoint blueprint, GIF motion và source snapshot.

## Tài sản review

| Tài sản | Vai trò |
| --- | --- |
| `17_TH_HTN_22DTV_CLC.pdf` | Báo cáo đồ án Hệ thống nhúng |
| `17_TH_HTN_22DTV_CLC_presentation.pdf` | Slide bảo vệ 16:9 |
| `17_TH_HTN_22DTV_CLC_presentation.typ` | Source Typst để tái dựng slide |
| `SoC_Ethernet_Integration_Blueprint.pptx` | PowerPoint blueprint kỹ thuật |
| `soc-ethernet-flow.gif` | GIF mô phỏng luồng PC/Android → TCP → HPS Linux → Bridge → FPGA PIO → HEX |
| `DoAnHeThongNhung-source-v1.0.2.zip` | Source snapshot từ commit phát hành |

## Phạm vi kỹ thuật

Repo này là đồ án học phần Thực hành Hệ thống nhúng của Nhóm 17, 22DTV_CLC. Phạm vi đúng là prototype trong mạng LAN: PC hoặc Android gửi chuỗi qua TCP/Ethernet đến HPS/Linux trên DE10-Standard, sau đó ghi qua bridge HPS-FPGA để hiển thị trên LED 7 đoạn.
