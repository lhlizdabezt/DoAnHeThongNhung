cat > /tmp/start_board_tcp_hex_server.sh <<'SH'
#!/bin/sh
python /tmp/board_tcp_hex_server.py
SH

chmod +x /tmp/start_board_tcp_hex_server.sh