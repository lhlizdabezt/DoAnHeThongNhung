import socket
import threading
import tkinter as tk
from tkinter import ttk, messagebox

BG = "#fff0f6"
CARD = "#ffd6e7"
ACCENT = "#ff5fa2"
ACCENT_2 = "#ff85b8"
TEXT = "#5a2145"
WHITE = "#ffffff"

class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("DE10 HEX TCP App")
        self.geometry("760x560")
        self.minsize(720, 520)
        self.configure(bg=BG)

        self.ip = tk.StringVar(value="192.168.1.101")
        self.port = tk.StringVar(value="5000")
        self.text_to_send = tk.StringVar(value="HELLO-")
        self.status_text = tk.StringVar(value="San sang")

        self.build_style()
        self.build_ui()

    def build_style(self):
        style = ttk.Style(self)
        try:
            style.theme_use("clam")
        except Exception:
            pass

        style.configure("Main.TFrame", background=BG)
        style.configure("Card.TFrame", background=CARD)
        style.configure("Title.TLabel", background=BG, foreground=ACCENT, font=("Segoe UI", 22, "bold"))
        style.configure("Sub.TLabel", background=BG, foreground=TEXT, font=("Segoe UI", 10))
        style.configure("CardTitle.TLabel", background=CARD, foreground=TEXT, font=("Segoe UI", 12, "bold"))
        style.configure("CardLabel.TLabel", background=CARD, foreground=TEXT, font=("Segoe UI", 10))
        style.configure("Pink.TButton", font=("Segoe UI", 10, "bold"), foreground=WHITE, background=ACCENT, padding=8)
        style.map("Pink.TButton", background=[("active", ACCENT_2), ("pressed", ACCENT_2)])
        style.configure("Soft.TButton", font=("Segoe UI", 10, "bold"), foreground=TEXT, background=WHITE, padding=8)
        style.map("Soft.TButton", background=[("active", "#ffe4ef"), ("pressed", "#ffe4ef")])

    def build_ui(self):
        root = ttk.Frame(self, style="Main.TFrame", padding=16)
        root.pack(fill="both", expand=True)

        ttk.Label(root, text="DE10-Standard HEX Text App", style="Title.TLabel").pack(anchor="w")
        ttk.Label(root, text="PC gui TCP -> board nhan text -> hien len HEX 7-seg", style="Sub.TLabel").pack(anchor="w", pady=(0, 12))

        top = ttk.Frame(root, style="Main.TFrame")
        top.pack(fill="x", pady=(0, 10))

        left = ttk.Frame(top, style="Card.TFrame", padding=14)
        left.pack(side="left", fill="both", expand=True, padx=(0, 8))

        right = ttk.Frame(top, style="Card.TFrame", padding=14)
        right.pack(side="left", fill="both", expand=True, padx=(8, 0))

        ttk.Label(left, text="Ket noi TCP", style="CardTitle.TLabel").grid(row=0, column=0, columnspan=2, sticky="w", pady=(0, 10))

        fields = [
            ("IP board", self.ip),
            ("Port", self.port),
        ]

        for i, (label, var) in enumerate(fields, start=1):
            ttk.Label(left, text=label, style="CardLabel.TLabel").grid(row=i, column=0, sticky="w", pady=5)
            e = tk.Entry(
                left,
                textvariable=var,
                width=30,
                font=("Segoe UI", 10),
                bg=WHITE,
                fg=TEXT,
                relief="flat",
                insertbackground=TEXT
            )
            e.grid(row=i, column=1, sticky="ew", pady=5, padx=(8, 0))

        left.columnconfigure(1, weight=1)

        ttk.Label(right, text="Noi dung hien thi", style="CardTitle.TLabel").pack(anchor="w", pady=(0, 10))

        text_entry = tk.Entry(
            right,
            textvariable=self.text_to_send,
            font=("Consolas", 26, "bold"),
            bg=WHITE,
            fg=ACCENT,
            relief="flat",
            justify="center",
            insertbackground=ACCENT
        )
        text_entry.pack(fill="x", pady=(0, 8))
        text_entry.bind("<Return>", lambda _e: self.send_text())

        ttk.Label(
            right,
            text="Nhap toi da 6 ky tu. Vi du: HELLO-, ABC123, P-0001",
            style="CardLabel.TLabel"
        ).pack(anchor="w", pady=(0, 10))

        action_row = ttk.Frame(right, style="Card.TFrame")
        action_row.pack(fill="x")
        ttk.Button(action_row, text="Gui text", style="Pink.TButton", command=self.send_text).pack(side="left", padx=(0, 8))
        ttk.Button(action_row, text="Test ket noi", style="Soft.TButton", command=lambda: self.send_raw("HELLO-")).pack(side="left")

        presets = ttk.Frame(root, style="Card.TFrame", padding=14)
        presets.pack(fill="x", pady=(0, 10))

        ttk.Label(presets, text="Mau nhanh", style="CardTitle.TLabel").pack(anchor="w", pady=(0, 10))
        preset_row = ttk.Frame(presets, style="Card.TFrame")
        preset_row.pack(fill="x")

        for txt in ["HELLO-", "ABC123", "P-0001", "123456", "------", "      "]:
            ttk.Button(
                preset_row,
                text=txt if txt.strip() else "CLEAR",
                style="Soft.TButton",
                command=lambda t=txt: self.quick_send(t)
            ).pack(side="left", padx=4, pady=2)

        status = ttk.Frame(root, style="Card.TFrame", padding=14)
        status.pack(fill="x", pady=(0, 10))
        ttk.Label(status, text="Trang thai", style="CardTitle.TLabel").pack(anchor="w")
        self.status_label = tk.Label(
            status,
            textvariable=self.status_text,
            font=("Segoe UI", 11, "bold"),
            bg=CARD,
            fg=ACCENT
        )
        self.status_label.pack(anchor="w", pady=(6, 0))

        log_card = ttk.Frame(root, style="Card.TFrame", padding=14)
        log_card.pack(fill="both", expand=True)

        ttk.Label(log_card, text="Log", style="CardTitle.TLabel").pack(anchor="w", pady=(0, 10))
        self.log = tk.Text(
            log_card,
            height=14,
            wrap="word",
            bg=WHITE,
            fg=TEXT,
            relief="flat",
            font=("Consolas", 10),
            insertbackground=TEXT
        )
        self.log.pack(fill="both", expand=True)

        self.append("San sang. Nho dam bao board dang chay TCP server o port 5000.")

    def append(self, msg):
        self.log.insert("end", msg + "\n")
        self.log.see("end")

    def set_status(self, msg):
        self.status_text.set(msg)

    def tcp_send(self, text):
        ip = self.ip.get().strip()
        port = int(self.port.get().strip())

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(5)
        s.connect((ip, port))
        s.sendall((text + "\n").encode("utf-8"))
        data = s.recv(1024).decode("utf-8", errors="replace")
        s.close()
        return data

    def send_raw(self, text):
        def worker():
            try:
                self.set_status("Dang gui...")
                self.append("> " + text)
                reply = self.tcp_send(text)
                self.append("< " + reply.strip())
                self.set_status("Thanh cong")
            except Exception as e:
                self.append("LOI: " + str(e))
                self.set_status("Loi ket noi")
                messagebox.showerror("TCP loi", str(e))
        threading.Thread(target=worker, daemon=True).start()

    def send_text(self):
        text = self.text_to_send.get()[:6]
        self.send_raw(text)

    def quick_send(self, text):
        self.text_to_send.set(text)
        self.send_text()

if __name__ == "__main__":
    App().mainloop()