# Đồ án Hệ thống nhúng - DE10-Standard SoC Ethernet

Repo này lưu mã nguồn, tài liệu báo cáo và slide cho đồ án Hệ thống nhúng của nhóm 17 - 22DTV_CLC. Đề tài tập trung xây dựng một hệ thống điều khiển trên board Terasic DE10-Standard Cyclone V SoC FPGA, trong đó máy tính hoặc thiết bị Android gửi chuỗi ký tự qua TCP/Ethernet, phía HPS/Linux trên board tiếp nhận dữ liệu và ghi xuống các ngoại vi FPGA để hiển thị trên LED 7 đoạn.

## Tài liệu chính

- [Báo cáo đồ án - 17_TH_HTN_22DTV_CLC.pdf](./17_TH_HTN_22DTV_CLC.pdf)
- [Slide thuyết trình - 17_TH_HTN_22DTV_CLC_presentation.pdf](./17_TH_HTN_22DTV_CLC_presentation.pdf)
- [Source slide Typst](./17_TH_HTN_22DTV_CLC_presentation.typ)
- [PowerPoint tổng hợp](./SoC_Ethernet_Integration_Blueprint.pptx)

## Mục tiêu đồ án

- Tích hợp phần cứng HPS/FPGA trên DE10-Standard bằng Intel Quartus Platform Designer.
- Thiết kế hệ thống nhận lệnh qua Ethernet từ PC/Android tới board.
- Xây dựng luồng xử lý TCP ở phía HPS/Linux.
- Ghi dữ liệu nhận được xuống vùng địa chỉ ngoại vi FPGA.
- Hiển thị chuỗi tối đa 6 ký tự lên LED 7 đoạn.
- Viết giao diện Python/Tkinter trên PC để nhập IP board, port và nội dung cần gửi.
- Kiểm thử hệ thống trong mô hình laptop - router - DE10-Standard.

## Kiến trúc tổng quan

```text
PC / Android client
        |
        | TCP/IP qua Ethernet LAN
        v
HPS Linux trên DE10-Standard
        |
        | Ghi thanh ghi ngoại vi qua lightweight HPS-to-FPGA bridge
        v
FPGA fabric / PIO
        |
        v
LED 7 đoạn HEX0 - HEX5
```

Hệ thống sử dụng Ethernet làm kênh truyền giữa thiết bị điều khiển và board. Dữ liệu nhận được được chuẩn hóa thành chuỗi ký tự giới hạn, sau đó chuyển thành mã LED 7 đoạn và ghi vào các địa chỉ PIO tương ứng.

## Công nghệ sử dụng

- Terasic DE10-Standard, Cyclone V SoC FPGA
- Intel Quartus Prime và Platform Designer
- Embedded Linux trên HPS
- VHDL/HDL cho phần cứng FPGA
- C/C++ cho phần mềm nhúng và thử nghiệm
- Python/Tkinter cho giao diện PC
- TCP/IP qua Ethernet
- Typst, PowerPoint và PDF cho tài liệu báo cáo

## Cấu trúc thư mục

```text
.
├── DoAn/
│   ├── de10_hex_text_ssh_project/   # Project DE10-Standard: phần cứng, HPS, SD card files
│   ├── pc_hex_tcp_pink_gui.py        # GUI Python gửi text tới board qua TCP
│   ├── s1.cpp, s2.cpp, s3.cpp        # Ghi chú/script triển khai TCP server trên board
│   └── 0.txt                         # Lệnh cấu hình nhanh Ethernet trên board
├── assets/                           # Ảnh dùng cho slide Typst
├── src/build_deck.cjs                # Script dựng slide bằng artifact-tool
├── 17_TH_HTN_22DTV_CLC.pdf           # Báo cáo đồ án
├── 17_TH_HTN_22DTV_CLC_presentation.pdf
├── 17_TH_HTN_22DTV_CLC_presentation.typ
├── SoC_Ethernet_Integration_Blueprint.pptx
└── README.md
```

## Chạy GUI trên PC

Yêu cầu máy tính có Python 3.

```powershell
python DoAn\pc_hex_tcp_pink_gui.py
```

Trong giao diện, nhập IP của board DE10-Standard và port TCP, mặc định là `5000`. Nội dung gửi nên có tối đa 6 ký tự để khớp với 6 LED 7 đoạn HEX0 đến HEX5.

## Cấu hình Ethernet trên board

Trên terminal Linux của DE10-Standard có thể cấu hình nhanh Ethernet bằng:

```sh
ifconfig eth0 up
udhcpc -i eth0
ifconfig eth0
```

Sau khi có địa chỉ IP, nhập IP đó vào GUI trên PC để kiểm tra kết nối và gửi dữ liệu thử nghiệm.

## Làm việc với project Quartus

Project Quartus chính nằm trong:

```text
DoAn/de10_hex_text_ssh_project/hw/quartus/project.qpf
```

Khi cần build lại:

1. Mở `project.qpf` bằng Intel Quartus Prime.
2. Mở Platform Designer nếu cần kiểm tra hoặc generate lại hệ thống.
3. Compile project để sinh bitstream.
4. Nạp hoặc boot hệ thống trên DE10-Standard theo quy trình trong tài liệu của thư mục `DoAn/de10_hex_text_ssh_project`.

Các file cache, database, report và bitstream sinh ra từ Quartus đã được bỏ qua trong Git để repo nhẹ hơn và phù hợp public trên GitHub.

## Phạm vi repo

Repo này được chuẩn bị cho mục đích học tập ngành Điện tử - Viễn thông, tập trung vào hệ thống nhúng, FPGA SoC, truyền thông Ethernet và ứng dụng điều khiển từ PC/Android. Nội dung chính gồm mã nguồn, project Quartus cần thiết, GUI PC, ảnh minh họa, báo cáo PDF và slide thuyết trình.
