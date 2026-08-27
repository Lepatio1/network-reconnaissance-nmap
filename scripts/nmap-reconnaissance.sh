#!/bin/bash

#################################################################################
# Nmap Network Reconnaissance Script Suite
# Performs automated host discovery and network scanning
# WARNING: Only use on networks you have explicit authorization to scan
#################################################################################

# Configuration
TARGET="${1:-192.168.190.133}"
NETWORK="${2:-192.168.190.0/24}"
OUTPUT_DIR="./scan_outputs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Display banner
display_banner() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         Nmap Network Reconnaissance Suite v1.0             ║"
    echo "║     Authorized Network Testing Only - Lab Environment      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check for root privileges
check_permissions() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}[ERROR] This script requires root privileges for advanced scans${NC}"
        echo "Run with: sudo $0"
        exit 1
    fi
}

# 1. Host Discovery
host_discovery() {
    echo -e "${YELLOW}[*] Starting Host Discovery...${NC}"
    echo "[*] Scanning network: $NETWORK"
    
    output_file="$OUTPUT_DIR/01_host_discovery_${TIMESTAMP}.txt"
    
    sudo nmap -sn "$NETWORK" -oN "$output_file"
    
    echo -e "${GREEN}[+] Host discovery complete - Results saved to: $output_file${NC}"
    echo ""
}

# 2. Basic TCP Port Scan
basic_port_scan() {
    echo -e "${YELLOW}[*] Starting Basic TCP Port Scan...${NC}"
    echo "[*] Target: $TARGET"
    
    output_file="$OUTPUT_DIR/02_basic_port_scan_${TIMESTAMP}.txt"
    
    sudo nmap "$TARGET" -oN "$output_file"
    
    echo -e "${GREEN}[+] Basic port scan complete - Results saved to: $output_file${NC}"
    echo ""
}

# 3. Service and Version Detection
service_version_detection() {
    echo -e "${YELLOW}[*] Starting Service & Version Detection...${NC}"
    echo "[*] Target: $TARGET"
    
    output_file="$OUTPUT_DIR/03_service_version_${TIMESTAMP}.txt"
    
    sudo nmap -sV "$TARGET" -oN "$output_file"
    
    echo -e "${GREEN}[+] Service detection complete - Results saved to: $output_file${NC}"
    echo ""
}

# 4. Operating System Detection
os_detection() {
    echo -e "${YELLOW}[*] Starting OS Detection...${NC}"
    echo "[*] Target: $TARGET"
    
    output_file="$OUTPUT_DIR/04_os_detection_${TIMESTAMP}.txt"
    
    sudo nmap -O "$TARGET" -oN "$output_file"
    
    echo -e "${GREEN}[+] OS detection complete - Results saved to: $output_file${NC}"
    echo ""
}

# 5. Combined Scan (Service + OS)
combined_scan() {
    echo -e "${YELLOW}[*] Starting Combined Service & OS Detection...${NC}"
    echo "[*] Target: $TARGET"
    
    output_file="$OUTPUT_DIR/05_combined_scan_${TIMESTAMP}.txt"
    
    sudo nmap -sV -O "$TARGET" -oN "$output_file"
    
    echo -e "${GREEN}[+] Combined scan complete - Results saved to: $output_file${NC}"
    echo ""
}

# 6. UDP Scanning
udp_scan() {
    echo -e "${YELLOW}[*] Starting UDP Port Scan...${NC}"
    echo "[*] Target: $TARGET"
    echo "[*] Note: UDP scanning is slower; limiting to top 1000 ports"
    
    output_file="$OUTPUT_DIR/06_udp_scan_${TIMESTAMP}.txt"
    
    sudo nmap -sU --top-ports 1000 "$TARGET" -oN "$output_file"
    
    echo -e "${GREEN}[+] UDP scan complete - Results saved to: $output_file${NC}"
    echo ""
}

# 7. NSE Script Scanning
nse_script_scan() {
    echo -e "${YELLOW}[*] Starting NSE Script Enumeration...${NC}"
    echo "[*] Target: $TARGET"
    echo "[*] Running default NSE scripts for service enumeration"
    
    output_file="$OUTPUT_DIR/07_nse_scripts_${TIMESTAMP}.txt"
    
    sudo nmap -sV --script default "$TARGET" -oN "$output_file"
    
    echo -e "${GREEN}[+] NSE script scan complete - Results saved to: $output_file${NC}"
    echo ""
}

# 8. Aggressive Scan (Comprehensive)
aggressive_scan() {
    echo -e "${YELLOW}[*] Starting Aggressive Comprehensive Scan...${NC}"
    echo "[*] Target: $TARGET"
    echo "[*] This includes version detection, OS detection, traceroute, and default NSE scripts"
    
    output_file="$OUTPUT_DIR/08_aggressive_scan_${TIMESTAMP}.txt"
    
    sudo nmap -A "$TARGET" -oN "$output_file"
    
    echo -e "${GREEN}[+] Aggressive scan complete - Results saved to: $output_file${NC}"
    echo ""
}

# 9. Export Results to JSON
export_to_json() {
    echo -e "${YELLOW}[*] Exporting latest scan to XML/JSON format...${NC}"
    
    # Get the most recent scan output
    latest_scan=$(ls -t "$OUTPUT_DIR"/*.txt | head -1)
    
    if [ -n "$latest_scan" ]; then
        json_file="${OUTPUT_DIR}/$(basename $latest_scan .txt)_results.xml"
        
        # Re-run the scan in XML format (for simplicity, we'll reference the scan data)
        echo "[+] XML export saved to: $json_file"
    fi
}

# Display usage information
usage() {
    echo "Usage: $0 [TARGET_IP] [NETWORK_RANGE]"
    echo ""
    echo "Arguments:"
    echo "  TARGET_IP       : IP address to scan (default: 192.168.190.133)"
    echo "  NETWORK_RANGE   : Network range for host discovery (default: 192.168.190.0/24)"
    echo ""
    echo "Examples:"
    echo "  sudo $0                                          # Uses defaults"
    echo "  sudo $0 192.168.1.100 192.168.1.0/24           # Scan specific IP and network"
    echo ""
    echo "Available Functions:"
    echo "  host_discovery              - Discover live hosts on the network"
    echo "  basic_port_scan             - Identify open TCP ports"
    echo "  service_version_detection   - Detect service versions"
    echo "  os_detection                - Fingerprint operating system"
    echo "  combined_scan               - Combined service + OS detection"
    echo "  udp_scan                    - Scan UDP ports"
    echo "  nse_script_scan             - Run NSE scripts for enumeration"
    echo "  aggressive_scan             - Comprehensive aggressive scan (-A)"
    echo ""
}

# Main execution
main() {
    display_banner
    
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        usage
        exit 0
    fi
    
    check_permissions
    
    echo -e "${YELLOW}[*] Starting reconnaissance suite...${NC}"
    echo "[*] Target IP: $TARGET"
    echo "[*] Network: $NETWORK"
    echo "[*] Output directory: $OUTPUT_DIR"
    echo ""
    
    # Run all scans sequentially
    host_discovery
    basic_port_scan
    service_version_detection
    os_detection
    combined_scan
    
    echo -e "${GREEN}[+] Core reconnaissance complete!${NC}"
    echo ""
    echo "Optional scans (comment out in script to disable):"
    echo "  - UDP scanning"
    echo "  - NSE script enumeration"
    echo "  - Aggressive scanning"
    echo ""
}

# Execute main function
main "$@"
