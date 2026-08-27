# 🔎 Network Reconnaissance & Service Enumeration Using Nmap

![Kali Linux](https://img.shields.io/badge/Platform-Kali%20Linux-557C94?logo=kalilinux&logoColor=white)
![Nmap](https://img.shields.io/badge/Tool-Nmap-4682B4)
![Target](https://img.shields.io/badge/Target-Metasploitable%202-red)
![Environment](https://img.shields.io/badge/Environment-Authorised%20Lab-green)
![Status](https://img.shields.io/badge/Status-Completed-success)

> **A practical cybersecurity project demonstrating network reconnaissance, host discovery, port scanning, service enumeration, operating-system detection, and security analysis using Nmap in a controlled virtual lab environment.**

---

## 📌 Project Overview

Network reconnaissance is an important stage of a cybersecurity assessment. Before attempting to assess a system, security professionals need to understand what hosts are present, which ports are accessible, what services are running, and what information those services expose.

In this project, I used **Nmap from Kali Linux** to perform authorised reconnaissance against **Metasploitable 2**, an intentionally vulnerable virtual machine designed for security education and testing.

The assessment progressed from host discovery to port scanning, service/version detection, and operating-system fingerprinting. The results were then reviewed to understand the target's exposed attack surface and potential security considerations.

### Project objectives

- Identify live hosts on the controlled laboratory network
- Identify open TCP ports on the target
- Enumerate running services
- Identify service and software versions
- Attempt operating-system fingerprinting
- Analyse the exposed attack surface
- Document findings and defensive recommendations

> ⚠️ **Authorisation:** All testing documented in this repository was performed against a deliberately vulnerable VM in a controlled laboratory environment. Never scan or test systems without explicit permission.

---

# 🧪 Laboratory Environment

| Component | Details |
|---|---|
| Security Testing Machine | Kali Linux |
| Primary Tool | Nmap 7.95 |
| Target | Metasploitable 2 |
| Target IP | `192.168.190.133` |
| Network | `192.168.190.0/24` |
| Virtualisation | VMware |
| Testing Type | Authorised reconnaissance |

### Network Architecture

```text
                  Isolated Virtual Network
                         │
             ┌───────────┴───────────┐
             │                       │
       ┌─────▼─────┐           ┌─────▼──────────┐
       │   Kali    │           │ Metasploitable │
       │   Linux   │           │       2        │
       │           │           │                │
       │   Nmap    │ ────────► │    Target      │
       └───────────┘           └────────────────┘
          Scanner                   192.168.190.133
```

---

# 🔍 Assessment Methodology

The reconnaissance process followed this sequence:

```text
1. Identify the laboratory network
              ↓
2. Discover live hosts
              ↓
3. Perform a basic TCP port scan
              ↓
4. Detect services and versions
              ↓
5. Attempt OS detection
              ↓
6. Analyse the exposed attack surface
              ↓
7. Develop defensive recommendations
```

---

# 1️⃣ Host Discovery

Before focusing on the target, I performed host discovery across the laboratory subnet to identify active systems.

### Command used

```bash
sudo nmap -sn 192.168.190.133/24
```

> **Note:** `192.168.190.133/24` was accepted by Nmap and resulted in a scan of **256 IP addresses**. The canonical network notation for this `/24` subnet is `192.168.190.0/24`, which is the form I would use in future documentation.

### What does `-sn` do?

The `-sn` option performs **host discovery without a traditional port scan**. It is useful for determining which IP addresses are responding before carrying out more detailed enumeration.

### Observed result

Nmap reported:

```text
Nmap done: 256 IP addresses (5 hosts up) scanned in 1.96 seconds
```

The scan identified five responding hosts, including:

```text
192.168.190.1
192.168.190.2
192.168.190.133
192.168.190.254
```

The target selected for further enumeration was:

```text
192.168.190.133
```

### Evidence
<img width="880" height="410" alt="Screenshot 2026-08-27 145621" src="https://github.com/user-attachments/assets/c6f67c06-8929-40a4-b51a-9dd170d109f0" />

Host Discovery

---

# 2️⃣ Basic Port Scan

After identifying the target, I performed a basic Nmap scan against `192.168.190.133`.

### Command used

```bash
sudo nmap 192.168.190.133
```

### Result

Nmap reported:

```text
Not shown: 977 closed tcp ports (reset)
```

It identified **23 open TCP ports**.

### Initial Port Findings

| Port | State | Service |
|---:|:---:|---|
| 21/tcp | Open | FTP |
| 22/tcp | Open | SSH |
| 23/tcp | Open | Telnet |
| 25/tcp | Open | SMTP |
| 53/tcp | Open | domain |
| 80/tcp | Open | HTTP |
| 111/tcp | Open | rpcbind |
| 139/tcp | Open | netbios-ssn |
| 445/tcp | Open | microsoft-ds |
| 512/tcp | Open | exec |
| 513/tcp | Open | login |
| 514/tcp | Open | shell |
| 1099/tcp | Open | rmiregistry |
| 1524/tcp | Open | ingreslock |
| 2049/tcp | Open | nfs |
| 2121/tcp | Open | ccproxy-ftp |
| 3306/tcp | Open | MySQL |
| 5432/tcp | Open | PostgreSQL |
| 5900/tcp | Open | VNC |
| 6000/tcp | Open | X11 |
| 6667/tcp | Open | IRC |
| 8009/tcp | Open | AJP13 |
| 8180/tcp | Open | HTTP |

### Key observation

The target exposes a **large number of network-accessible services**. In a real production environment, this would represent a significant attack surface and would require review to determine whether each service is necessary and appropriately protected.

### Evidence

<img width="991" height="582" alt="Screenshot 2026-08-27 151707" src="https://github.com/user-attachments/assets/b03a69a5-0f74-4283-8c33-2c02f1d1b0f7" />


Basic Port Scan 

---

# 3️⃣ Service & Version Detection

The next stage was to identify the software and versions associated with the open ports.

### Command used

```bash
sudo nmap -sV 192.168.190.133
```

### What does `-sV` do?

The `-sV` option enables **service/version detection**. Instead of reporting only that a port is open, Nmap attempts to identify the application and software version running behind the service.

### Service Enumeration Results

| Port | Service | Detected version / information |
|---:|---|---|
| 21/tcp | FTP | vsftpd 2.3.4 |
| 22/tcp | SSH | OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0) |
| 23/tcp | Telnet | Linux telnetd |
| 25/tcp | SMTP | Postfix smtpd |
| 53/tcp | DNS | ISC BIND 9.4.2 |
| 80/tcp | HTTP | Apache httpd 2.2.8 ((Ubuntu) DAV/2) |
| 111/tcp | rpcbind | 2 (RPC #100000) |
| 139/tcp | NetBIOS-SSN | Samba smbd 3.X - 4.X (WORKGROUP) |
| 445/tcp | Microsoft-DS | Samba smbd 3.X - 4.X (WORKGROUP) |
| 512/tcp | exec | netkit-rsh rexecd |
| 513/tcp | login | OpenBSD or Solaris rlogind |
| 514/tcp | shell | tcpwrapped |
| 1099/tcp | Java RMI | GNU Classpath grmiregistry |
| 1524/tcp | Ingreslock | Metasploitable root shell |
| 2049/tcp | NFS | 2-4 (RPC #100003) |
| 2121/tcp | FTP | ProFTPD 1.3.1 |
| 3306/tcp | MySQL | MySQL 5.0.51a-3ubuntu5 |
| 5432/tcp | PostgreSQL | PostgreSQL DB 8.3.0 - 8.3.7 |
| 5900/tcp | VNC | VNC (protocol 3.3) |
| 6000/tcp | X11 | X11 (access denied) |
| 6667/tcp | IRC | UnrealIRCd |
| 8009/tcp | AJP13 | Apache Jserv (Protocol v1.3) |
| 8180/tcp | HTTP | Apache Tomcat/Coyote JSP engine 1.1 |

### Evidence

<img width="1211" height="657" alt="Screenshot 2026-08-27 152537" src="https://github.com/user-attachments/assets/183358c6-fe07-41d1-bae1-59515eea5feb" />

Service and Version Detection

---

# 4️⃣ Operating System Detection

I then used Nmap's operating-system detection capability to fingerprint the target.

### Command used

```bash
sudo nmap -O 192.168.190.133
```

Nmap reported:

```text
Device type: general purpose
Running: Linux 2.6.X
OS CPE: cpe:/o:linux:linux_kernel:2.6
OS details: Linux 2.6.9 - 2.6.33
Network Distance: 1 hop
```

### Interpretation

The scan identified the target as a **general-purpose Linux system** and estimated a **Linux 2.6.x kernel**, with the detailed estimate falling between Linux 2.6.9 and 2.6.33.

The result is consistent with the expected legacy Linux environment used by Metasploitable 2.

### Evidence

<img width="1071" height="770" alt="Screenshot 2026-08-27 153317" src="https://github.com/user-attachments/assets/c8aa3894-aca4-4ddb-8f75-c012e841a3f3" />

OS Detection

---

# 5️⃣ Combined Service & OS Detection

To obtain both service/version information and OS fingerprinting in a single scan, I used:

```bash
sudo nmap -sV -O 192.168.190.133
```

### Result

The combined scan reproduced the service enumeration and OS information, including:

```text
Device type: general purpose
Running: Linux 2.6.X
OS details: Linux 2.6.9 - 2.6.33
```

Nmap also identified the following host/service information:

```text
Service Info:
Hosts: metasploitable.localdomain, irc.Metasploitable.LAN
OS: Unix, Linux
CPE: cpe:/o:linux:linux_kernel
```

### Evidence

<img width="1197" height="732" alt="Screenshot 2026-08-27 153502" src="https://github.com/user-attachments/assets/4fba5387-0373-469a-95bc-2764a08400ba" />


Combined Service and OS Detection

---

# 🔬 Security Analysis

The reconnaissance phase revealed a broad attack surface on the target.

A particularly important finding was the presence of **23 open TCP ports**, including network services such as FTP, Telnet, HTTP, SMB, NFS, databases, VNC, IRC and Java-related services.

The version scan also identified several **legacy software versions**, which would require further investigation in a real security assessment.

### Examples of security considerations

| Finding | Security consideration |
|---|---|
| FTP exposed | Credentials and data may require additional protection depending on configuration |
| Telnet exposed | Telnet is an insecure remote-access protocol because traffic can be transmitted without modern encryption |
| Multiple legacy services | Older software may contain known vulnerabilities and should be assessed and patched where appropriate |
| SMB/Samba exposed | File-sharing services should be restricted to authorised hosts and properly configured |
| Database services exposed | MySQL/PostgreSQL should not be unnecessarily accessible from untrusted network segments |
| VNC exposed | Remote graphical access should be strongly authenticated and network-restricted |
| Large number of services | Unnecessary services increase the system's overall attack surface |

> **Important:** An open port or detected software version does **not by itself prove that a vulnerability exists**. Further authorised vulnerability assessment would be required.

---

---

# 6️⃣ UDP Port Scanning

While the initial reconnaissance focused on TCP ports, UDP services also represent a potential attack surface.

### Command used

```bash
sudo nmap -sU --top-ports 1000 192.168.190.133
```

### What does `-sU` do?

The `-sU` option performs **UDP port scanning**. UDP services often include DNS, DHCP, SNMP, and other critical infrastructure services that may not be evident from TCP scanning alone.

### UDP Scanning Considerations

- **Slower than TCP scanning** due to ICMP rate limiting
- **Less reliable** than TCP (UDP packets may be dropped)
- **Limited to top ports** to reduce scan time (can adjust with `--top-ports` or `-p`)
- Often reveals **DNS, DHCP, SNMP, NTP** services

### Methodology

For Metasploitable 2, key UDP services to enumerate:

```bash
# Scan specific UDP ports
sudo nmap -sU -p 53,67,68,69,123,161,162 192.168.190.133

# Scan all UDP ports (very time-consuming)
sudo nmap -sU 192.168.190.133 -p-

# Combine TCP and UDP scanning
sudo nmap -sS -sU 192.168.190.133
```

**Common UDP services:**
- Port 53: DNS
- Port 67/68: DHCP
- Port 69: TFTP
- Port 123: NTP
- Port 161/162: SNMP

---

# 7️⃣ NSE Script Enumeration

Nmap Scripting Engine (NSE) scripts automate service enumeration and vulnerability detection.

### Available Script Categories

```
auth          - Evaluate authentication mechanisms
broadcast     - Interact with network services
brute         - Brute force credentials
default       - Standard scripts run with -sV
discovery     - Enumerate network details
dos           - Denial of Service testing
exploit       - Exploit vulnerabilities
external      - Query external services
fuzzer        - Protocol fuzzing
intrusive     - Aggressive/intrusive probes
malware       - Malware detection
safe          - Non-intrusive scripts
version       - Version detection
vuln          - Vulnerability detection
```

### Commands

```bash
# Run default NSE scripts (included with -sV)
sudo nmap -sV 192.168.190.133

# Run all safe scripts
sudo nmap -sV --script safe 192.168.190.133

# Run vulnerability detection scripts
sudo nmap -sV --script vuln 192.168.190.133

# Run specific script
sudo nmap -sV --script=smb-os-discovery 192.168.190.133

# Run multiple scripts
sudo nmap -sV --script=smb-*,vuln 192.168.190.133

# List available scripts
sudo nmap --script-help

# Run with verbose output
sudo nmap -sV --script default -d 192.168.190.133
```

### Useful NSE Scripts for Metasploitable 2

| Script | Purpose | Port |
|--------|---------|------|
| smb-os-discovery | Detect SMB OS details | 445 |
| smb-enum-shares | Enumerate SMB shares | 445 |
| mysql-info | Extract MySQL version info | 3306 |
| postgresql-databases | List PostgreSQL databases | 5432 |
| ftp-anon | Check for FTP anonymous access | 21 |
| ssl-cert | Extract SSL certificate details | 443,8443 |
| http-title | Grab HTTP title | 80,8000 |
| dns-brute | Brute force DNS hostnames | 53 |

---

### 8️⃣ Aggressive Comprehensive Scanning

Based on the reconnaissance findings, the following defensive measures would help reduce the exposed attack surface in a production environment.

### 1. Reduce unnecessary services

Disable services that are not required for legitimate business operations.

### 2. Restrict network exposure

Use host-based and network firewalls to restrict access to services to authorised systems and network segments.

### 3. Replace insecure protocols

Where appropriate, replace legacy clear-text protocols such as Telnet with secure alternatives such as SSH.

### 4. Apply security updates

Maintain an effective patch-management process for operating systems and applications.

### 5. Protect database services

Restrict direct network access to database services and enforce strong authentication and access controls.

### 6. Secure remote administration

Restrict remote administration services such as SSH and VNC to trusted management networks and apply strong authentication.

### 7. Monitor network activity

Use network monitoring, logging and security controls to identify unusual connection attempts and reconnaissance activity.

### 8. Conduct regular vulnerability assessments

Regularly review exposed services and compare installed software versions against current security advisories and organisational patching requirements.

---

# 🧠 Key Learning Outcomes

This project provided practical experience with:

- Network reconnaissance
- Host discovery
- CIDR notation
- TCP port scanning
- Service enumeration
- Service/version detection
- Operating-system fingerprinting
- Linux command-line tools
- Nmap output interpretation
- Attack-surface analysis
- Security risk identification
- Defensive recommendations
- Professional security documentation

---

# 💻 Commands Demonstrated

### View network configuration

```bash
ip a
```

### Discover live hosts

```bash
sudo nmap -sn 192.168.190.0/24
```

### Basic TCP port scan

```bash
sudo nmap 192.168.190.133
```

### Service/version detection

```bash
sudo nmap -sV 192.168.190.133
```

### Operating-system detection

```bash
sudo nmap -O 192.168.190.133
```

### Combined service and OS detection

```bash
sudo nmap -sV -O 192.168.190.133
```

---

# 📁 Repository Structure

```text
network-reconnaissance-nmap/
│
├── README.md                          # This file
├── LICENSE                            # Project license
│
├── screenshots/                       # Scan evidence and results
│   ├── 01-host-discovery.png
│   ├── 02-basic-port-scan.png
│   ├── 03-service-version-detection.png
│   ├── 04-os-detection.png
│   └── 05-service-and-os-detection.png
│
├── data/                              # Structured scan data and analysis
│   ├── scan-results.json              # Complete scan results in JSON format
│   ├── ports-and-services.csv         # Port mapping with attack surface assessment
│   ├── vulnerabilities-cve-mapping.json  # CVE database with severity ratings
│   └── README.md                      # Data format documentation
│
└── scripts/                           # Automated reconnaissance and analysis tools
    ├── nmap-reconnaissance.sh         # Automated host discovery and scanning
    ├── analyze-scan-results.sh        # Parse and analyze scan output
    ├── validate-scan-results.py       # Validate reproducibility and correctness
    └── README.md                      # Script usage documentation
```

---

# 📸 Evidence Summary

The repository contains screenshots documenting each major stage of the reconnaissance process:

| Screenshot | Demonstrates |
|---|---|
| `screenshots/01-host-discovery.png` | Discovery of active hosts on the lab network |
| `screenshots/02-basic-port-scan.png` | Identification of open TCP ports |
| `screenshots/03-service-version-detection.png` | Enumeration of services and software versions |
| `screenshots/04-os-detection.png` | Operating-system fingerprinting |
| `screenshots/05-service-and-os-detection.png` | Combined service and OS detection |

---

# 🤖 Automated Tools & Scripts

The repository includes automated scripts for performing reconnaissance and analyzing results.

## Reconnaissance Automation

**File:** `scripts/nmap-reconnaissance.sh`

Automated Bash script that performs the complete reconnaissance sequence:

```bash
# Basic usage (uses default target and network)
sudo scripts/nmap-reconnaissance.sh

# Specify target and network
sudo scripts/nmap-reconnaissance.sh 192.168.190.133 192.168.190.0/24
```

**Included scanning functions:**
- Host discovery (`-sn`)
- Basic TCP port scanning
- Service/version detection (`-sV`)
- Operating-system detection (`-O`)
- Combined service and OS detection
- UDP port scanning
- NSE script enumeration
- Aggressive scanning (`-A`)

**Output:** All scan results are automatically saved to `scan_outputs/` directory with timestamps.

## Results Analysis

**File:** `scripts/analyze-scan-results.sh`

Parses Nmap text output and generates structured reports:

```bash
# Analyze a specific scan file
bash scripts/analyze-scan-results.sh scan_outputs/02_basic_port_scan_*.txt
```

**Generates:**
- CSV file of identified ports and services
- Vulnerability assessment report
- Statistical analysis of scan findings

## Validation & Reproducibility

**File:** `scripts/validate-scan-results.py`

Python script to validate scan results against expected data and check reproducibility:

```bash
# Run validation checks
python3 scripts/validate-scan-results.py

# Specify custom data file
python3 scripts/validate-scan-results.py --data-file data/scan-results.json

# Verbose output
python3 scripts/validate-scan-results.py --verbose
```

**Validation checks:**
- Port count verification
- Service detection validation
- OS detection consistency
- CVE database integrity
- Data format validation (JSON/CSV)

---

# 📊 Structured Data Files

All scan findings are exported to structured formats for reproducibility and automation.

## scan-results.json

Complete scan results in JSON format with metadata:

```json
{
  "scan_metadata": { ... },
  "host_discovery": { ... },
  "open_ports_tcp": [ ... ],
  "os_detection": { ... },
  "hostname_info": { ... }
}
```

**Use cases:**
- Programmatic analysis
- Integration with security tools
- Historical comparison
- Automated reporting

## ports-and-services.csv

Port-level details with attack surface assessment:

| Column | Description |
|--------|-------------|
| port | TCP/UDP port number |
| protocol | Protocol (tcp/udp) |
| state | Port state (open/closed/filtered) |
| service | Detected service name |
| detected_version | Software version if identified |
| cpe | Common Platform Enumeration string |
| attack_surface_risk | Risk assessment and mitigation advice |

**Import into:** Spreadsheets, databases, Python/R analysis tools

## vulnerabilities-cve-mapping.json

Vulnerability database mapping detected software to known CVEs:

```json
{
  "vulnerabilities": [
    {
      "software": "vsftpd 2.3.4",
      "port": 21,
      "vulnerabilities": [
        {
          "cve": "CVE-2011-2523",
          "description": "...",
          "severity": "Critical",
          "cvss_score": 9.8,
          "mitigation": "..."
        }
      ]
    }
  ],
  "summary": {
    "critical_vulnerabilities": 5,
    "high_severity_vulnerabilities": 10
  }
}
```

**Reference for:**
- Risk prioritization
- Remediation planning
- Compliance reporting
- Security training

---

# 🛠️ Using the Tools

## Quick Start: Complete Reconnaissance

```bash
# Run full automated reconnaissance
sudo bash scripts/nmap-reconnaissance.sh 192.168.190.133 192.168.190.0/24

# Analyze the results
bash scripts/analyze-scan-results.sh scan_outputs/02_basic_port_scan_*.txt

# Validate reproducibility
python3 scripts/validate-scan-results.py
```

## Individual Scans

Run specific scans manually:

```bash
# Host discovery only
sudo nmap -sn 192.168.190.0/24

# TCP port scan with service detection
sudo nmap -sV 192.168.190.133

# OS detection
sudo nmap -O 192.168.190.133

# UDP scanning
sudo nmap -sU --top-ports 1000 192.168.190.133

# NSE scripts for enumeration
sudo nmap -sV --script default 192.168.190.133

# Comprehensive aggressive scan
sudo nmap -A 192.168.190.133
```

## Export to Formats

Convert Nmap results to structured formats:

```bash
# Export to XML (easier to parse)
sudo nmap -sV 192.168.190.133 -oX scan_output.xml

# Export to Grepable format
sudo nmap -sV 192.168.190.133 -oG scan_output.gnmap

# Export to all formats
sudo nmap -sV 192.168.190.133 -oA scan_output
```

---

# 🚀 Future Improvements

This project can be expanded with additional authorised laboratory work, including:

- ✅ **UDP scanning** - Documented with examples
- ✅ **Nmap NSE scripts** - Script examples and enumeration techniques included
- ✅ **Structured data exports** - JSON, CSV formats for reproducibility
- ✅ **Vulnerability cross-reference** - CVE mapping for detected software
- ✅ **Automated validation** - Python validation suite for reproducibility
- **Metasploit integration** - Automated exploitation testing
- **Web application scanning** - Tools like Burp Suite or OWASP ZAP
- **Vulnerability assessment automation** - Integration with tools like OpenVAS
- **Compliance mapping** - Cross-reference findings to CIS, OWASP, NIST controls
- **Report generation** - Professional PDF/HTML penetration testing reports
- **Diff analysis** - Track changes over time with historical scanning
- **Threat modeling** - Map findings to MITRE ATT&CK framework
- **Defensive control testing** - Verify IDS/IPS detection capabilities

---

# ⚖️ Ethical & Legal Disclaimer

This project was conducted exclusively within an **authorised and controlled virtual laboratory environment** using Metasploitable 2 as the target.

The techniques demonstrated in this repository are intended for:

- Cybersecurity education
- Security research
- Defensive security
- Authorised penetration testing
- Controlled laboratory environments

**Do not scan, enumerate, or test systems without explicit authorisation from the system owner.**

Unauthorised security testing may violate organisational policies and applicable laws.

---

# 👨🏾‍💻 Author

## Longtio Borel Lepatio

**MSc Cyber Security with Professional Placement**

United Kingdom

---

### ⭐ Project Focus

**Reconnaissance → Enumeration → Analysis → Defensive Recommendations**

> This project demonstrates practical application of network reconnaissance techniques using Nmap within a controlled cybersecurity laboratory.
