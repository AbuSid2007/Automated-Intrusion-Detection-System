
A shell-based Intrusion Detection System (IDS) that analyzes Linux authentication logs, detects brute-force attacks, and generates firewall rules to block malicious IP addresses.

---

## Features

* Log sanitization and formatting
* Detection of brute-force login attempts
* Whitelist-aware IP filtering
* Automatic firewall rule generation
* Port usage analysis
* Hourly attack timeline

---

## Repository Structure

```
.
├── auth.log
├── whitelist.txt
├── sanitize.sh
├── detect.sh
├── report.sh
├── timeline.sh
└── README.md
```

---

## Requirements

* Linux/Unix environment
* Bash shell
* Standard tools: `grep`, `awk`, `sed`

---

## Usage

### 1. Clone the repository

```bash
git clone <link>
cd Automated-Intrusion-Detection-System
```

### 2. Give execution permissions

```bash
chmod +x sanitize.sh detect.sh report.sh timeline.sh
```

### 3. Run the pipeline

#### Step 1: Sanitize logs

```bash
./sanitize.sh auth.log
```

Output: `clean_log.csv`

---

#### Step 2: Detect attackers

```bash
./detect.sh clean_log.csv whitelist.txt firewall_rules.sh
```

Output: `firewall_rules.sh`

---

#### Step 3: Port analysis

```bash
./report.sh clean_log.csv
```

Example output:

```
Target Port Analysis
--------------------
Port 22 : XX attempts
Port 8080 : XX attempts
```

---

#### Step 4: Attack timeline

```bash
./timeline.sh clean_log.csv
```

Example output:

```
Hour 09: XX failed attempts
Hour 10: XX failed attempts
```

---

## Script Overview

**sanitize.sh**

* Removes corrupted lines (`[CORRUPT-DATA]`)
* Replaces `user=root` and `user=admin` with `user=SYS_ADMIN`
* Converts `|` to `,`

**detect.sh**

* Counts failed login attempts per IP
* Flags IPs with more than 10 failures
* Manually checks against whitelist
* Generates `iptables` rules

**report.sh**

* Aggregates failed attempts by port
* Displays formatted summary

**timeline.sh**

* Extracts hour from timestamps
* Counts failures per hour (00–23)

---

## Notes

* Whitelisted IPs are never blocked
* Only IPs with strictly more than 10 failed attempts are considered attackers
* Run `sanitize.sh` before other scripts

---

## Author

Abubakar


