#!/bin/bash

#################################################################################
# Nmap Results Parser and Analyzer
# Parses Nmap scan output and generates structured analysis reports
#################################################################################

SCAN_FILE="${1:-.}"
OUTPUT_DIR="./analysis"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Parse and extract ports
extract_ports() {
    local scan_file=$1
    local output_file="$OUTPUT_DIR/open_ports_${TIMESTAMP}.csv"
    
    echo -e "${YELLOW}[*] Extracting port information...${NC}"
    
    echo "port,protocol,state,service,version" > "$output_file"
    
    grep "^\S\+/tcp\|^\S\+/udp" "$scan_file" | while read line; do
        port=$(echo "$line" | awk '{print $1}' | cut -d'/' -f1)
        protocol=$(echo "$line" | awk '{print $1}' | cut -d'/' -f2)
        state=$(echo "$line" | awk '{print $2}')
        service=$(echo "$line" | awk '{print $3}')
        version=$(echo "$line" | cut -d' ' -f4-)
        
        echo "$port,$protocol,$state,$service,$version" >> "$output_file"
    done
    
    echo -e "${GREEN}[+] Ports exported to: $output_file${NC}"
}

# Generate vulnerability assessment
generate_assessment() {
    local scan_file=$1
    local output_file="$OUTPUT_DIR/vulnerability_assessment_${TIMESTAMP}.txt"
    
    echo -e "${YELLOW}[*] Generating vulnerability assessment...${NC}"
    
    {
        echo "═══════════════════════════════════════════════════════════"
        echo "        VULNERABILITY ASSESSMENT REPORT"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "Generated: $(date)"
        echo "Scan File: $scan_file"
        echo ""
        
        # Extract service information
        echo "SERVICES DETECTED:"
        echo "───────────────────────────────────────────────────────────"
        grep -E "^\S+/(tcp|udp)" "$scan_file" | grep "open" | wc -l | awk '{print "Total Open Ports: " $1}'
        
        echo ""
        echo "HIGH RISK SERVICES:"
        echo "───────────────────────────────────────────────────────────"
        grep -E "(telnet|ftp|http|vnc|rsh|rlogin)" "$scan_file" | grep "open" && echo "" || echo "None detected"
        
        echo ""
        echo "DATABASE SERVICES:"
        echo "───────────────────────────────────────────────────────────"
        grep -E "(mysql|postgresql|oracle)" "$scan_file" | grep "open" && echo "" || echo "None detected"
        
        echo ""
        echo "RECOMMENDATION SUMMARY:"
        echo "───────────────────────────────────────────────────────────"
        echo "1. Review all open ports for business necessity"
        echo "2. Disable unnecessary services"
        echo "3. Implement network segmentation"
        echo "4. Apply security patches for detected software versions"
        echo "5. Restrict remote access services to authorized hosts"
        echo "6. Monitor network activity for suspicious connections"
        
    } > "$output_file"
    
    echo -e "${GREEN}[+] Assessment exported to: $output_file${NC}"
}

# Generate statistics
generate_statistics() {
    local scan_file=$1
    local output_file="$OUTPUT_DIR/scan_statistics_${TIMESTAMP}.txt"
    
    echo -e "${YELLOW}[*] Generating scan statistics...${NC}"
    
    {
        echo "═══════════════════════════════════════════════════════════"
        echo "           SCAN STATISTICS AND ANALYSIS"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        
        echo "OPEN PORTS:"
        grep "^[0-9]" "$scan_file" | grep "open" | wc -l | awk '{print "  Total: " $1}'
        
        echo ""
        echo "CLOSED PORTS:"
        grep "closed" "$scan_file" | wc -l | awk '{print "  Total: " $1}'
        
        echo ""
        echo "FILTERED PORTS:"
        grep "filtered" "$scan_file" | wc -l | awk '{print "  Total: " $1}'
        
        echo ""
        echo "SERVICE DISTRIBUTION:"
        grep "^[0-9]" "$scan_file" | grep "open" | awk '{print $3}' | sort | uniq -c | sort -rn
        
    } > "$output_file"
    
    echo -e "${GREEN}[+] Statistics exported to: $output_file${NC}"
}

# Display help
usage() {
    echo "Usage: $0 [NMAP_SCAN_FILE]"
    echo ""
    echo "Arguments:"
    echo "  NMAP_SCAN_FILE  : Path to Nmap output file in text format"
    echo ""
    echo "This script analyzes Nmap scan results and generates:"
    echo "  - Structured CSV port listings"
    echo "  - Vulnerability assessment reports"
    echo "  - Statistical analysis"
    echo ""
}

# Main
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [ ! -f "$SCAN_FILE" ]; then
    usage
    exit 1
fi

echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           Nmap Results Analysis Tool v1.0                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

extract_ports "$SCAN_FILE"
generate_assessment "$SCAN_FILE"
generate_statistics "$SCAN_FILE"

echo ""
echo -e "${GREEN}[+] Analysis complete! Results in: $OUTPUT_DIR${NC}"
