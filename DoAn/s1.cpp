cat > /tmp/board_tcp_hex_server.py <<'PY'
#!/usr/bin/env python
import socket
import subprocess

HOST = "0.0.0.0"
PORT = 5000

A0 = "0xFF200040"
A1 = "0xFF200050"
A2 = "0xFF200060"
A3 = "0xFF200070"
A4 = "0xFF200080"
A5 = "0xFF200090"

ALLOWED = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-_ "

def seg(ch):
    table = {
        '0':64, '1':121, '2':36, '3':48, '4':25, '5':18, '6':2, '7':120,
        '8':0,  '9':16,
        'A':8,  'B':3,  'C':70, 'D':33, 'E':6,  'F':14,
        'H':9,  'L':71, 'O':64, 'P':12, 'U':65, 'Y':17,
        '-':63, '_':119, ' ':127
    }
    return table.get(ch, 127)

def sanitize_text(s):
    s = s.strip().upper()
    s = "".join(ch if ch in ALLOWED else " " for ch in s)
    return s[:6].ljust(6)

def write_hex(text):
    c0, c1, c2, c3, c4, c5 = list(text[:6])
    v5 = seg(c0)
    v4 = seg(c1)
    v3 = seg(c2)
    v2 = seg(c3)
    v1 = seg(c4)
    v0 = seg(c5)

    cmds = [
        ["devmem", A0, "32", str(v0)],
        ["devmem", A1, "32", str(v1)],
        ["devmem", A2, "32", str(v2)],
        ["devmem", A3, "32", str(v3)],
        ["devmem", A4, "32", str(v4)],
        ["devmem", A5, "32", str(v5)],
    ]

    for cmd in cmds:
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate()
        if p.returncode != 0:
            raise Exception("devmem fail: " + " ".join(cmd))

def handle_client(conn, addr):
    try:
        data = conn.recv(1024)
        if not data:
            return

        if not isinstance(data, str):
            data = data.decode("utf-8", "ignore")

        text = sanitize_text(data)
        write_hex(text)

        reply = "OK:%s\n" % text
        conn.sendall(reply)
        print("[%s:%s] -> %s" % (addr[0], addr[1], text))
    except Exception as e:
        try:
            conn.sendall("ERR:%s\n" % str(e))
        except Exception:
            pass
    finally:
        conn.close()

def main():
    print("TCP HEX server listening on %s:%s" % (HOST, PORT))
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(5)

    while True:
        conn, addr = s.accept()
        handle_client(conn, addr)

if __name__ == "__main__":
    main()
PY

chmod +x /tmp/board_tcp_hex_server.py