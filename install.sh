#!/bin/bash
echo "===================================="
echo "   Raspberry Pi NAS Mount Installer"
echo "===================================="
echo ""

# 1. Prüfen, ob Skripte vorhanden sind
if [ ! -f mount-hdd.sh ] || [ ! -f umount-hdd.sh ] || [ ! -f nas-hdd.service ] || [ ! -f 99-nas-hdd.rules ]; then
    echo "[ERROR] Not all required files are present!"
    echo "Missing one of: mount-hdd.sh, umount-hdd.sh, nas-hdd.service, 99-nas-hdd.rules"
    exit 1
fi

echo "[+] Installing dependencies..."
sudo apt update
sudo apt install -y ntfs-3g

echo "[+] Copying mount scripts to /usr/local/bin..."
sudo cp mount-hdd.sh /usr/local/bin/mount-hdd.sh
sudo cp umount-hdd.sh /usr/local/bin/umount-hdd.sh
sudo chmod +x /usr/local/bin/mount-hdd.sh
sudo chmod +x /usr/local/bin/umount-hdd.sh

echo "[+] Installing systemd service..."
sudo cp nas-hdd.service /etc/systemd/system/nas-hdd.service
sudo systemctl daemon-reload
sudo systemctl enable nas-hdd.service

echo "[+] Installing udev rule..."
sudo cp 99-nas-hdd.rules /etc/udev/rules.d/99-nas-hdd.rules
sudo udevadm control --reload-rules

echo "[+] Creating mount directory..."
sudo mkdir -p /mnt/hdd
sudo chown pi:pi /mnt/hdd

echo ""
echo "===================================="
echo "[✓] Installation complete!"
echo "===================================="
echo ""
echo "IMPORTANT:"
echo "- Unplug your HDD"
echo "- Wait 2 seconds"
echo "- Plug HDD back in"
echo "Then run:"
echo "    journalctl -f"
echo "to verify auto-mount events."
echo ""
