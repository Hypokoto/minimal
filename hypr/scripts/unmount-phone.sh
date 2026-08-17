#!/usr/bin/env bash
set -euo pipefail
MOUNT_POINT="$HOME/mnt/phone"
if mountpoint -q "$MOUNT_POINT"; then
  fusermount -u "$MOUNT_POINT"
  echo "Unmounted $MOUNT_POINT"
else
  echo "Not mounted."
fi
