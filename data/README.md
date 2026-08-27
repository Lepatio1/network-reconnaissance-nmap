# 📊 Scan Data and Analysis Files

This directory contains structured scan results and vulnerability databases in machine-readable formats.

## Files Overview

### scan-results.json

**Complete reconnaissance scan results in JSON format.**

**Purpose:**
- Programmatic access to all scan findings
- Integration with automation tools
- Historical comparison and trending
- Reproducibility validation

**Structure:**
```json
{
  "scan_metadata": {
    "target": "192.168.190.133",
    "network": "192.168.190.0/24",
    "scanning_tool": "Nmap 7.95",
    "environment": "Authorised Lab - VMware",
    "scan_date": "2026-08-27"
  },
  "host_discovery": {
    "command": "sudo nmap -sn 192.168.190.0/24",
    "total_ips_scanned": 256,
    "hosts_up": 5,
    "active_hosts": ["192.168.190.1", ...]
  },
  "open_ports_tcp": [
    {
      "port": 21,
      "protocol": "tcp",
      "state": "open",
      "service": "ftp",
      "version": "vsftpd 2.3.4",
      "cpe": "cpe:/a:vsftpd:vsftpd:2.3.4"
    },
    ...
  ],
  "os_detection": {
    "device_type": "general purpose",
    "os_running": "Linux 2.6.X",
    "os_details": "Linux 2.6.9 - 2.6.33"
  }
}
```

**Use Cases:**
- Automated vulnerability scanning pipelines
- Machine learning on scan data
- Comparison with future scans
- Compliance reporting automation
- Custom analysis scripts

**Example Python usage:**
```python
import json

with open('scan-results.json', 'r') as f:
    data = json.load(f)

# Access specific findings
for port in data['open_ports_tcp']:
    print(f"Port {port['port']}: {port['service']} ({port['version']})")

# Count open ports
open_count = len(data['open_ports_tcp'])
print(f"Total open ports: {open_count}")
```

---

### ports-and-services.csv

**Comma-separated values file with port-level security assessment.**

**Purpose:**
- Import into spreadsheets (Excel, Google Sheets)
- Load into databases for analysis
- Quick reference for port information
- Risk prioritization

**Columns:**
| Column | Description | Example |
|--------|-------------|---------|
| port | Port number | 21 |
| protocol | Protocol type | tcp |
| state | Port state | open |
| service | Service name | ftp |
| detected_version | Software version | vsftpd 2.3.4 |
| cpe | Common Platform Enumeration | cpe:/a:vsftpd:vsftpd:2.3.4 |
| attack_surface_risk | Risk assessment | High - Known vulnerabilities in vsftpd 2.3.4 |

**Sample rows:**
```csv
port,protocol,state,service,detected_version,cpe,attack_surface_risk
21,tcp,open,ftp,vsftpd 2.3.4,cpe:/a:vsftpd:vsftpd:2.3.4,"High - Known vulnerabilities in vsftpd 2.3.4"
22,tcp,open,ssh,OpenSSH 4.7p1 Debian 8ubuntu1,cpe:/a:openbsd:openssh:4.7p1,"High - Outdated SSH version"
23,tcp,open,telnet,Linux telnetd,,"Critical - Unencrypted clear-text protocol"
```

**Use Cases:**
- Risk scoring and prioritization
- Spreadsheet-based reporting
- Database imports
- Automated filtering (critical services)

**Example SQL import:**
```sql
LOAD DATA INFILE 'ports-and-services.csv'
INTO TABLE scan_results
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(port, protocol, state, service, detected_version, cpe, attack_surface_risk);
```

**Example Python with pandas:**
```python
import pandas as pd

df = pd.read_csv('ports-and-services.csv')

# Filter for high-risk services
high_risk = df[df['attack_surface_risk'].str.contains('Critical')]
print(high_risk)

# Group by service
by_service = df.groupby('service').size()
print(by_service)
```

---

### vulnerabilities-cve-mapping.json

**Comprehensive vulnerability database mapping detected software to known CVEs.**

**Purpose:**
- Cross-reference detected versions with known vulnerabilities
- Prioritize remediation based on severity
- Track historical vulnerabilities
- Compliance and security reporting

**Structure:**
```json
{
  "vulnerabilities": [
    {
      "software": "vsftpd 2.3.4",
      "port": 21,
      "cpe": "cpe:/a:vsftpd:vsftpd:2.3.4",
      "vulnerabilities": [
        {
          "cve": "CVE-2011-2523",
          "description": "Backdoor in vsftpd 2.3.4 - remote code execution via smiley face",
          "severity": "Critical",
          "cvss_score": 9.8,
          "affected_versions": ["2.3.4"],
          "mitigation": "Upgrade to patched version or disable vsftpd"
        }
      ]
    }
  ],
  "summary": {
    "total_products_with_cves": 10,
    "critical_vulnerabilities": 5,
    "high_severity_vulnerabilities": 10,
    "remediation_priority": "Immediate - Multiple critical vulnerabilities present"
  }
}
```

**Severity Levels:**
- **Critical** (CVSS 9.0-10.0) - Immediate patching required
- **High** (CVSS 7.0-8.9) - Urgent patching needed
- **Medium** (CVSS 4.0-6.9) - Plan patching in next cycle
- **Low** (CVSS 0.1-3.9) - Monitor for patterns

**CVSS Scores:**
- 0.0: No impact
- 1.0-3.9: Low severity
- 4.0-6.9: Medium severity
- 7.0-8.9: High severity
- 9.0-10.0: Critical severity

**Use Cases:**
- Risk assessment and scoring
- Vulnerability patch planning
- Compliance mapping (NIST, CIS)
- Security metrics and KPIs
- Board-level reporting

**Example Python analysis:**
```python
import json

with open('vulnerabilities-cve-mapping.json', 'r') as f:
    cves = json.load(f)

# Find critical vulnerabilities
critical = []
for product in cves['vulnerabilities']:
    for vuln in product['vulnerabilities']:
        if vuln['severity'] == 'Critical':
            critical.append({
                'cve': vuln['cve'],
                'software': product['software'],
                'port': product['port'],
                'cvss': vuln['cvss_score']
            })

# Sort by CVSS score
critical.sort(key=lambda x: x['cvss'], reverse=True)

for item in critical:
    print(f"{item['cve']}: {item['software']} ({item['cvss']})")
```

**Example: Prioritize remediation**
```python
# Get remediation priorities
priorities = cves['summary']
print(f"Critical CVEs: {priorities['critical_vulnerabilities']}")
print(f"High CVEs: {priorities['high_severity_vulnerabilities']}")
print(f"Recommendation: {priorities['remediation_priority']}")
```

---

## Data Format Selection Guide

| Use Case | Format | Tool |
|----------|--------|------|
| Version control and versioning | JSON | Git, GitHub |
| Spreadsheet analysis | CSV | Excel, Google Sheets |
| Database import | CSV | MySQL, PostgreSQL |
| Web dashboards | JSON | JavaScript, Python Flask |
| Report generation | JSON | Python, LaTeX |
| Quick manual review | CSV | Any text editor |
| API endpoints | JSON | REST APIs |
| Data validation | JSON | JSON Schema |

---

## Integration Examples

### Python - Analyze all data together
```python
import json
import csv

# Load JSON
with open('scan-results.json') as f:
    scans = json.load(f)

# Load CVE data
with open('vulnerabilities-cve-mapping.json') as f:
    cves = json.load(f)

# Load port data
ports = []
with open('ports-and-services.csv') as f:
    reader = csv.DictReader(f)
    ports = list(reader)

# Combine data
for port_data in ports:
    if port_data['attack_surface_risk'].startswith('Critical'):
        print(f"CRITICAL: {port_data['service']} on port {port_data['port']}")
```

### SQL - Create reporting database
```sql
CREATE TABLE scan_metadata (
    scan_id INT PRIMARY KEY,
    target VARCHAR(255),
    scan_date DATETIME,
    total_open_ports INT
);

CREATE TABLE open_ports (
    scan_id INT,
    port INT,
    protocol VARCHAR(10),
    service VARCHAR(255),
    version VARCHAR(255),
    cpe VARCHAR(255),
    FOREIGN KEY (scan_id) REFERENCES scan_metadata(scan_id)
);

CREATE TABLE vulnerabilities (
    port_id INT,
    cve VARCHAR(20),
    severity VARCHAR(20),
    cvss_score FLOAT,
    FOREIGN KEY (port_id) REFERENCES open_ports(id)
);
```

---

## Data Validation

Validate data integrity before use:

```bash
# Validate JSON format
python3 -m json.tool scan-results.json > /dev/null && echo "Valid JSON"

# Validate CSV format
python3 -c "import csv; csv.reader(open('ports-and-services.csv')); print('Valid CSV')"

# Or use the validation script
python3 ../scripts/validate-scan-results.py
```

---

## Security and Privacy

⚠️ **Important considerations:**
- Store scan data securely (restrict file permissions)
- Do not share detailed scan results publicly
- Protect CVE mappings (contains attack surface info)
- Comply with data retention policies
- Encrypt sensitive data in transit and at rest

---

## Version History

When updating scan data:
1. Keep previous versions (e.g., `scan-results-2026-08-27.json`)
2. Document changes in commit messages
3. Track differences between scans
4. Archive historical findings

Example naming convention:
```
scan-results.json              (current/latest)
scan-results-2026-08-27.json   (archive)
scan-results-2026-08-20.json   (archive)
```

---

## References

- **CVSS Calculator:** https://www.first.org/cvss/calculator/3.1
- **CPE Lookup:** https://nvd.nist.gov/products/cpe
- **CVE Details:** https://www.cvedetails.com
- **JSON Schema:** https://json-schema.org

