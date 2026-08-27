# 🤖 Nmap Reconnaissance Scripts

This directory contains automated Bash and Python scripts for network reconnaissance, analysis, and validation.

## Scripts Overview

### 1. nmap-reconnaissance.sh

Automated reconnaissance script that performs the complete Nmap scanning sequence.

**Usage:**
```bash
sudo bash nmap-reconnaissance.sh [TARGET_IP] [NETWORK_RANGE]
```

**Examples:**
```bash
# Use defaults (192.168.190.133 and 192.168.190.0/24)
sudo bash nmap-reconnaissance.sh

# Specify custom target and network
sudo bash nmap-reconnaissance.sh 10.0.0.50 10.0.0.0/24
```

**What it does:**
1. Performs host discovery on the network
2. Runs basic TCP port scan on target
3. Detects service versions
4. Fingerprints operating system
5. Runs combined service + OS detection
6. Saves all output to `scan_outputs/` directory

**Output format:**
- Text files with timestamps: `01_host_discovery_YYYYMMDD_HHMMSS.txt`
- Organized by scan type

**Requirements:**
- sudo/root privileges
- Nmap installed and in PATH
- Bash shell

---

### 2. analyze-scan-results.sh

Parses Nmap text output and generates analysis reports.

**Usage:**
```bash
bash analyze-scan-results.sh <NMAP_OUTPUT_FILE>
```

**Example:**
```bash
bash analyze-scan-results.sh scan_outputs/02_basic_port_scan_20260827_172347.txt
```

**What it does:**
1. Extracts port and service information
2. Generates CSV of open ports with services
3. Creates vulnerability assessment report
4. Produces statistical analysis

**Output files (saved to `analysis/` directory):**
- `open_ports_YYYYMMDD_HHMMSS.csv` - Structured port data
- `vulnerability_assessment_YYYYMMDD_HHMMSS.txt` - Risk assessment
- `scan_statistics_YYYYMMDD_HHMMSS.txt` - Statistical analysis

**CSV columns:**
- port, protocol, state, service, version

---

### 3. validate-scan-results.py

Python script to validate scan reproducibility and check data integrity.

**Usage:**
```bash
python3 validate-scan-results.py [OPTIONS]
```

**Options:**
- `--data-file FILE` - Path to expected data file (default: data/scan-results.json)
- `--results-file FILE` - Path to actual scan results (optional)
- `--verbose, -v` - Enable verbose output

**Examples:**
```bash
# Basic validation
python3 validate-scan-results.py

# Verbose mode
python3 validate-scan-results.py --verbose

# Custom data file
python3 validate-scan-results.py --data-file custom_scan_data.json
```

**What it checks:**
1. **Port Count Validation** - Verifies expected number of open ports
2. **Service Detection** - Confirms critical services are found (SSH, FTP, MySQL, etc.)
3. **OS Detection** - Validates operating system identification
4. **CVE Database** - Checks vulnerability database integrity
5. **Data Format** - Verifies JSON/CSV file validity

**Exit codes:**
- 0 = All checks passed
- 1 = One or more checks failed

**Requirements:**
- Python 3.6+
- No external dependencies

---

## Typical Workflow

### Step 1: Run Reconnaissance
```bash
sudo bash nmap-reconnaissance.sh 192.168.190.133 192.168.190.0/24
```

### Step 2: Analyze Results
```bash
bash analyze-scan-results.sh scan_outputs/02_basic_port_scan_*.txt
```

### Step 3: Validate Reproducibility
```bash
python3 validate-scan-results.py --verbose
```

### Step 4: Review Output
- Check `scan_outputs/` for raw Nmap results
- Review `analysis/` for parsed CSV and reports
- Compare with `../data/scan-results.json` for expected findings

---

## Advanced Usage

### Custom Port Ranges

Modify `nmap-reconnaissance.sh` to add custom scanning:

```bash
# Scan specific ports
sudo nmap -p 22,80,443,3306 192.168.190.133

# Scan port ranges
sudo nmap -p 1-1000,5000,8000-9000 192.168.190.133

# Scan all 65535 ports
sudo nmap -p- 192.168.190.133
```

### NSE Script Testing

```bash
# Run vulnerability detection scripts
sudo nmap -sV --script vuln 192.168.190.133

# Run specific NSE script
sudo nmap --script smb-os-discovery 192.168.190.133

# List available scripts
nmap --script-help
```

### Output Formats

```bash
# XML output (for parsing)
sudo nmap -sV 192.168.190.133 -oX output.xml

# Grepable format
sudo nmap -sV 192.168.190.133 -oG output.gnmap

# Normal + XML + Grepable
sudo nmap -sV 192.168.190.133 -oA output
```

---

## Troubleshooting

**"Permission denied" error**
- Run scripts with `sudo`: `sudo bash nmap-reconnaissance.sh`
- Ensure user is in sudoers file

**"nmap: command not found"**
- Install Nmap: `sudo apt install nmap` (Debian/Ubuntu)
- Verify installation: `which nmap`

**Slow UDP scanning**
- Limit ports: `--top-ports 1000` or `-p 53,67,68,123`
- Increase timeout: `--host-timeout 60m`

**Script permission issues**
- Make executable: `chmod +x *.sh *.py`
- Verify Bash: `which bash`

---

## Security Notes

⚠️ **IMPORTANT:**
- Only scan networks you own or have explicit written authorization to test
- Unauthorized network scanning may violate laws and regulations
- These scripts should only be used in controlled lab environments
- Always follow responsible disclosure practices

---

## Contributing

To add new scripts:
1. Follow the naming convention: `lowercase-with-hyphens.sh/py`
2. Include comprehensive help text
3. Add error handling and validation
4. Document in this README

---

## License

These scripts are provided as educational tools for authorized security testing in lab environments only.
