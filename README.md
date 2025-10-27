# Block hostile subnets

Blocks hostile subnets which are scanning for nefarious reasons.

# Dependencies

- git
- bash
- cron
- iptables & ip6tables & ipset

# Usage

1. Clone to `/opt`
2. Add to crontab:
```crontab
0 3 * * * /opt/block-hostile-subnets/apply.sh
```
3. Optional: run script once as root.