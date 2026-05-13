# Đồ án Hệ thống nhúng - DE10-Standard SoC Ethernet

Repo này lưu mã nguồn và tài liệu cho đồ án Hệ thống nhúng sử dụng board Terasic DE10-Standard Cyclone V SoC FPGA. Mục tiêu chính là xây dựng hệ thống nhận lệnh qua TCP/Ethernet từ máy tính hoặc thiết bị Android, sau đó hiển thị nội dung lên các LED 7 đoạn trên FPGA.

## Mục tiêu

- Tích hợp phần cứng HPS/FPGA trên DE10-Standard bằng Intel Quartus Platform Designer.
- Thiết kế luồng điều khiển từ PC qua Ethernet tới board.
- Viết chương trình phía HPS/Linux để nhận dữ liệu TCP và ghi xuống các thanh ghi ngoại vi FPGA.
- Xây dựng GUI Python/Tkinter trên máy tính để gửi chuỗi ký tự tới board.
- Chuẩn bị slide và tài liệu trình bày cho nhóm 17 - 22DTV_CLC.

## Công nghệ sử dụng

- Terasic DE10-Standard, Cyclone V SoC FPGA
- Intel Quartus Prime, Platform Designer
- Embedded Linux trên HPS
- VHDL/HDL cho phần cứng FPGA
- C/C++ cho phần mềm nhúng và thử nghiệm
- Python/Tkinter cho giao diện PC
- TCP/IP qua Ethernet
- Typst/PowerPoint cho slide báo cáo

## Cấu trúc thư mục

```text
.
├── DoAn/
│   ├── de10_hex_text_ssh_project/   # Project DE10-Standard, phần cứng và phần mềm HPS
│   ├── pc_hex_tcp_pink_gui.py        # GUI Python gửi text tới board qua TCP
│   ├── s1.cpp, s2.cpp, s3.cpp        # Ghi chú/script triển khai TCP server trên board
│   └── 0.txt                         # Lệnh cấu hình nhanh Ethernet trên board
├── assets/                           # Ảnh dùng cho slide Typst
├── src/build_deck.cjs                # Script dựng slide bằng artifact-tool
├── 17_TH_HTN_22DTV_CLC_presentation.typ
├── SoC_Ethernet_Integration_Blueprint.pptx
└── README.md
```

## Chạy GUI trên PC

Yêu cầu máy tính có Python 3.

```powershell
python DoAn\pc_hex_tcp_pink_gui.py
```

Trong giao diện, nhập IP của board DE10-Standard, port mặc định `5000`, sau đó gửi chuỗi tối đa 6 ký tự. Board cần đang chạy TCP server và cùng mạng LAN với máy tính.

## Cấu hình Ethernet trên board

Trên terminal Linux của DE10-Standard có thể cấu hình nhanh Ethernet bằng:

```sh
ifconfig eth0 up
udhcpc -i eth0
ifconfig eth0
```

Sau khi có IP, nhập IP đó vào GUI trên PC để kiểm tra kết nối.

## Làm việc với project Quartus

Project chính nằm trong:

```text
DoAn/de10_hex_text_ssh_project/hw/quartus/project.qpf
```

Các file cache, database, report và bitstream sinh ra từ Quartus đã được bỏ qua trong Git để repo nhẹ và dễ public. Khi cần build lại, mở project bằng Intel Quartus Prime, generate Platform Designer nếu cần, sau đó compile lại trên máy có đầy đủ bộ Intel FPGA tools.

## Slide báo cáo

Slide Typst nằm ở:

```text
17_TH_HTN_22DTV_CLC_presentation.typ
```

Ảnh minh họa nằm trong thư mục `assets/`. File PowerPoint tổng hợp hiện có ở `SoC_Ethernet_Integration_Blueprint.pptx`.

## Ghi chú

Repo được chuẩn bị cho mục đích học tập ngành Điện tử - Viễn thông, tập trung vào hệ thống nhúng, FPGA SoC, truyền thông Ethernet và ứng dụng điều khiển từ PC.
