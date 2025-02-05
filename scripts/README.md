# 📜 Custom Logs & PowerShell Scripts

## Overview
This section explains the purpose behind our custom log ingestion (resulting in the `RDP_Logs_CL` table) and the PowerShell script that enriches our Azure security logs with geolocation data.

## Why Create a Custom Log (`RDP_Logs_CL`)?
### The Problem: Default Logs Didn’t Capture Enough Data
Azure Windows Security Events (for example, Event ID 4625 for failed RDP logins) are useful for detecting login failures but:
- They **do not include enriched metadata** such as geolocation (latitude, longitude, country, state).
- They are **not structured** for advanced filtering or mapping.
- They lack the **custom fields required for effective dashboard visualization** (like world maps in Microsoft Sentinel).

### The Solution: Custom Log (`RDP_Logs_CL`)
To overcome these limitations, we created a custom log:
- A **PowerShell script** collects failed login attempts (Event ID 4625) from the Windows Event Viewer.
- The script **extracts key details** (e.g., username, source IP, timestamp) and calls an **IP geolocation API** to add location data.
- The enriched logs are written to a local file:  
  `C:\ProgramData\failed_rdp.log`
- This file is then ingested into our Log Analytics Workspace as a **Custom Log** named `RDP_Logs_CL`.
- Once ingested, the data becomes **queryable via KQL** and is used in Sentinel for threat detection, alerts, and visualization (such as mapping attacker locations).

## How It Works
### 1. PowerShell Script Captures RDP Login Attempts
- The script monitors the Windows Event Viewer for **failed RDP login attempts** (Event ID 4625).
- It extracts details like **username, source IP, and timestamp**.
- It then uses an **IP Geolocation API** (with your API key) to enrich the logs with:
  - Latitude and Longitude
  - State and Country
- Each enriched log entry is formatted and appended to:
  ```
  C:\ProgramData\failed_rdp.log
  ```

### 2. Log Analytics Custom Log (`RDP_Logs_CL`)
- The Log Analytics Workspace is configured to monitor the file at the path:
  ```
  C:\ProgramData\failed_rdp.log
  ```
- When new data is added, the custom log (`RDP_Logs_CL`) is updated.
- This table is then used by Sentinel for queries and visualizations.

### 3. Microsoft Sentinel Uses the Data
- Sentinel’s Data Connectors pull logs from the Log Analytics Workspace.
- KQL queries extract fields from `RDP_Logs_CL` for mapping and alerting.
- Sentinel Workbooks visualize the data (e.g., on a world map, showing attacker locations).

## Key Benefits
- **Enriched Data:** By adding geolocation details, you can see exactly where failed login attempts originate.
- **Custom Querying:** Structured data allows for powerful KQL queries, filtering by IP, username, region, etc.
- **Enhanced Visualization:** With fields like latitude and longitude, you can plot data on a map in Sentinel Workbooks, aiding in threat analysis and response.
- **Actionable Intelligence:** The enriched data helps trigger alerts and build analytic rules within Sentinel for better incident response.

## Related Files
- **PowerShell Script:** [`failed_rdp_logger.ps1`](./failed_rdp_logger.ps1)

## Next Steps
- Ensure the **PowerShell script is running on the VM** so that `C:\ProgramData\failed_rdp.log` updates continuously.
- Confirm that **Log Analytics is correctly ingesting the log file** as the custom log `RDP_Logs_CL`.
- Use the provided **KQL queries** to visualize and analyze the data in Sentinel.
- Monitor the enriched logs to detect and respond to malicious RDP login attempts.

This setup ensures your Sentinel dashboard has enriched, actionable security data for effective threat analysis and incident response.

---

*End of Scripts README*