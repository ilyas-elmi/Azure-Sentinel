# 🚨 Security Analytics: Geolocation Mapping of Threats in Azure Sentinel:

## Overview
This project showcases **real-world threat detection** using an **Azure-hosted honeypot** to log and analyze **failed RDP login attempts**. By exposing a virtual machine to the internet and integrating it with **Microsoft Sentinel**, the project simulates cyber attacks and provides insights into **attacker behavior, geolocation, and frequency**.

## Technologies Used
- **Azure Virtual Machines (VM)**
- **Microsoft Sentinel (SIEM)**
- **Log Analytics Workspace**
- **Defender for Cloud**
- **PowerShell** (Log enrichment)
- **Kusto Query Language (KQL)**

## How It Works
- A **public-facing Windows VM** acts as a honeypot to attract malicious RDP login attempts.
- **Failed logins (Event ID 4625)** are captured and ingested into **Log Analytics**.
- A **custom PowerShell script** enriches the logs with **geolocation data**.
- **Microsoft Sentinel dashboards** visualize attack trends, locations, and sources.

## Key Findings
✔️ Identified **failed login attempts** from multiple global locations.  
✔️ Extracted attacker metadata: **IP address, geolocation, usernames**.  
✔️ Built a **Sentinel workbook** for real-time threat intelligence.

## Skills Demonstrated
✅ **Cloud Security** – Deploying a honeypot in **Azure** to simulate cyber threats.  
✅ **SIEM & Log Analysis** – Using **Microsoft Sentinel** and **Log Analytics**.  
✅ **Threat Intelligence** – Enriching security logs with **IP geolocation data**.  
✅ **KQL & Data Visualization** – Building **custom queries & dashboards**.

## Future Enhancements
- **Automated alerts** for high-volume attacks.
- **SSH honeypot** expansion for wider threat coverage.
- **Integration with Azure Logic Apps** for automated threat responses.

