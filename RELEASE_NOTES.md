# Release notes - v1.0.3

## Điểm chính

- Render lại `assets/soc-ethernet-flow.gif` để bỏ tiêu đề lớn bên trong GIF, tránh các block che chữ khi GitHub thu nhỏ hoặc dùng cache cũ.
- Tăng khoảng cách giữa `FPGA PIO` và `HEX`, giữ line nối rõ ràng và có đoạn line sau `HEX` để luồng nhìn liên tục hơn.
- Thêm `src/render_soc_ethernet_flow.py` làm nguồn render lại GIF, giúp lần sau sửa layout có thể tái tạo được thay vì chỉnh thủ công từng frame.
- Giữ README, bảng biểu và chú thích bằng tiếng Việt; riêng SVG vẫn dùng tiếng Anh/ASCII-safe để tránh lỗi hiển thị dấu.

## Tài sản review

| Tài sản | Vai trò |
| --- | --- |
| `17_TH_HTN_22DTV_CLC.pdf` | Báo cáo đồ án Hệ thống nhúng |
| `17_TH_HTN_22DTV_CLC_presentation.pdf` | Slide bảo vệ 16:9 |
| `17_TH_HTN_22DTV_CLC_presentation.typ` | Source Typst để tái dựng slide |
| `SoC_Ethernet_Integration_Blueprint.pptx` | PowerPoint blueprint kỹ thuật |
| `soc-ethernet-flow.gif` | GIF mô phỏng luồng PC/Android -> TCP -> HPS Linux -> Bridge -> FPGA PIO -> HEX |
| `DoAnHeThongNhung-source-v1.0.3.zip` | Source snapshot từ commit phát hành |

## Phạm vi kỹ thuật

Repo này là đồ án học phần Thực hành Hệ thống nhúng của Nhóm 17, 22DTV_CLC. Phạm vi đúng là prototype trong mạng LAN: PC hoặc Android gửi chuỗi qua TCP/Ethernet đến HPS/Linux trên DE10-Standard, sau đó ghi qua bridge HPS-FPGA để hiển thị trên LED 7 đoạn.
