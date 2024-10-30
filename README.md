# ERX-Wireshark

Remote Packet Capture Script for Ubiquity EdgeRouter X.
A robust remote packet capture script leveraging SSH, tcpdump, and Wireshark for real-time network monitoring. Originally inspired by Jerico Thomas, with enhancements.

## Features
- Secure packet capturing over SSH
- Real-time analysis with Wireshark
- Optional filtering with tcpdump

## Requirements
- SSH access to the target server
- Dependencies: `ssh`, `tcpdump`, and `wireshark`

## Usage
```
./remotecapture.sh -u <USER> -s <SERVER> -p <PORT> -i <INTERFACE> [-f <FILTER>]
```
- **USER**: SSH username
- **SERVER**: SSH server IP/hostname
- **PORT**: SSH port (default 22)
- **INTERFACE**: Network interface to monitor
- **FILTER**: Optional tcpdump filter (e.g., `port 80`)

## License
This project is licensed under the GNU GPLv3. See `LICENSE` for more details.
