# Block hostile subnets

Blocks hostile subnets which are scanning for nefarious reasons.

# Dependencies

- git
- bash
- cron
- iptables & ip6tables & ipset
- python3, pip, python-venv

# Usage

1. Clone to `/opt` using `git clone --recurse-submodules`.
2. Add to crontab:
```crontab
0 3 * * * bash /opt/block-hostile-subnets/apply.sh
```
3. Optional: run script once as root.