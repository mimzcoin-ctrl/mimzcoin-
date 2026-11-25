#!/data/data/com.termux/files/usr/bin/sh
# MimzChain on Android (Termux): installs what is missing, starts the node, opens a public HTTPS link.
# Put this file next to mimzchain.py and wallet.html, then run:  sh termux-start.sh
set -e
cd "$(dirname "$0")"

for f in mimzchain.py wallet.html; do
  [ -f "$f" ] || { echo "Missing $f next to this script."; exit 1; }
done

need() { command -v "$1" >/dev/null 2>&1; }
need python || pkg install -y python
need cloudflared || pkg install -y cloudflared
python -c "import ecdsa" 2>/dev/null || pip install ecdsa

export MIMZ_DATA="$PWD/chain.json"
if [ ! -f "$MIMZ_DATA" ]; then
  python mimzchain.py init
  if [ -d "$HOME/storage/downloads" ]; then
    cp founder-wallet.json "$HOME/storage/downloads/founder-wallet.json"
    echo "Copied founder-wallet.json to your phone's Downloads folder (import it in the wallet, then delete that copy)."
  fi
fi

pkill -f "mimzchain.py serve" 2>/dev/null || true
nohup python mimzchain.py serve > node.log 2>&1 &
echo $! > node.pid
sleep 2
command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock

echo
echo "Node is running. Starting the public link, look for the https://...trycloudflare.com line below."
echo "Keep this screen open. Press Ctrl+C to stop the link (the node keeps running; stop it with: kill \$(cat node.pid))."
echo
exec cloudflared tunnel --url http://localhost:8545
