# Logs and Visualizations

This folder contains screenshots captured during the honeypot project that demonstrate the log ingestion and enrichment process as well as the mapping of attacker data in Microsoft Sentinel.

## Screenshots of Logs

### Logs-1
![Logs-1](./Logs-1.png)
**Description:**  
This screenshot shows the initial view of failed RDP login events in Log Analytics. It demonstrates that our system is correctly capturing Event ID 4625 (failed logins).

### Logs-2
![Logs-2](./Logs-2.png)
**Description:**  
This image displays detailed log entries, including the enriched data (such as geolocation information) that our PowerShell script appends to the logs.

## Map Visualizations

### Map-1
![Map-1](./Map-1.png)
**Description:**  
This map visualization in Microsoft Sentinel displays the geographic distribution of failed RDP logins. It aggregates events by latitude and longitude to show where the attacks are originating.

### Map-2
![Map-2](./Map-2.png)
**Description:**  
This refined map view includes labels with country and state information along with the attacker’s IP, making it easier to quickly identify the regions from which attacks originate.

## Interpretation and Analysis

- **Logs-1:**  
  Demonstrates that the basic log ingestion process is working, as failed RDP login attempts are being captured in Log Analytics.
  
- **Logs-2:**  
  Confirms that the PowerShell script successfully enriches these logs with additional metadata, such as geolocation (latitude, longitude, state, and country).

- **Map-1 & Map-2:**  
  These visualizations in Sentinel help in understanding the geographic distribution of the attacks, providing valuable insights into where the threat is coming from. This information is crucial for threat analysis and incident response.

