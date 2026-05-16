# Release notes - v1.0.4

## Điểm chính

- Sửa `assets/soc-ethernet-hero.svg`: bỏ cụm card chữ `TCP`, `HPS`, `FPGA`, `GUI`, `Bridge`, `HEX` để không còn đè lên tiêu đề banner.
- Thay cụm card bằng motif mạch không chữ ở góc phải dưới, giữ chuyển động nhẹ nhưng không cạnh tranh với nội dung chính.
- Giữ bản GIF `assets/soc-ethernet-flow.gif` đã render lại ở `v1.0.3`, trong đó line giữa `FPGA PIO` và `HEX` hiển thị rõ hơn.
- Giữ README, bảng biểu và chú thích bằng tiếng Việt; riêng SVG vẫn dùng tiếng Anh/ASCII-safe để tránh lỗi hiển thị dấu.

## Tài sản review

| Tài sản | Vai trò |
| --- | --- |
| `17_TH_HTN_22DTV_CLC.pdf` | Báo cáo đồ án Hệ thống nhúng |
| `17_TH_HTN_22DTV_CLC_presentation.pdf` | Slide bảo vệ 16:9 |
| `17_TH_HTN_22DTV_CLC_presentation.typ` | Source Typst để tái dựng slide |
| `SoC_Ethernet_Integration_Blueprint.pptx` | PowerPoint blueprint kỹ thuật |
| `soc-ethernet-flow.gif` | GIF mô phỏng luồng PC/Android -> TCP -> HPS Linux -> Bridge -> FPGA PIO -> HEX |
| `DoAnHeThongNhung-source-v1.0.4.zip` | Source snapshot từ commit phát hành |

## Phạm vi kỹ thuật

Repo này là đồ án học phần Thực hành Hệ thống nhúng của Nhóm 17, 22DTV_CLC. Phạm vi đúng là prototype trong mạng LAN: PC hoặc Android gửi chuỗi qua TCP/Ethernet đến HPS/Linux trên DE10-Standard, sau đó ghi qua bridge HPS-FPGA để hiển thị trên LED 7 đoạn.
