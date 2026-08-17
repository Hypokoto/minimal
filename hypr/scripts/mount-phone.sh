#!/usr/bin/env bash
# Mounts an MTP phone to ~/mnt/phone via jmtpfs. Once mounted, it's just a
# directory — open it in Yazi like any other path, no special integration exists
# or is needed. Phone must be unlocked with USB mode set to "File Transfer (MTP)".
set -euo pipefail

MOUNT_POINT="$HOME/mnt/phone"
mkdir -p "$MOUNT_POINT"

if mountpoint -q "$MOUNT_POINT"; then
  echo "Already mounted at $MOUNT_POINT"
  exit 0
fi

if ! jmtpfs "$MOUNT_POINT"; then
  echo "Mount failed. Check: phone unlocked, USB mode = File Transfer (MTP), cable is data-capable (not charge-only)." >&2
  exit 1
fi

echo "Mounted at $MOUNT_POINT"
