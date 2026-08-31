# PrivEsc: Linux

- **SUID/SGID**: `find / -perm -4000 -type f 2>/dev/null`
- **Sudo**: `sudo -l` (Check against GTFOBins)
- **Capabilities**: `getcap -r / 2>/dev/null`
- **Cron/Timers**: Check world-writable scripts in `/etc/crontab` and `systemctl list-timers`.
