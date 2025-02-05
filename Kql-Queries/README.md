# KQL Queries for Azure Sentinel

This folder contains custom KQL queries used to analyze and visualize security data in Azure Sentinel. Each query file is accompanied by a brief description and usage instructions.

---

## Table of Contents
- [Failed RDP Logins](#failed-rdp-logins)
- [Successful RDP Logins](#successful-rdp-logins)
- [Custom Geolocation Map Query](#custom-geolocation-map-query)
- [Search for Username "ilyas"](#search-for-username-ilyas)
- [Other Queries](#other-queries)

---

## Failed RDP Logins

**Filename:** `failed_rdp_logins.kql`

**Description:**  
This query extracts failed RDP login attempts from the custom log (`RDP_Logs_CL`), enriches them with geolocation data, and displays key fields such as username, source IP, latitude, and longitude.

**Query:**
```kql
RDP_Logs_CL
| extend username = extract(@"username:([^,]+)", 1, RawData)
| extend sourcehost = extract(@"sourcehost:([^,]+)", 1, RawData)
| extend latitude = extract(@"latitude:([^,]+)", 1, RawData)
| extend longitude = extract(@"longitude:([^,]+)", 1, RawData)
| where RawData contains "4625"
| project TimeGenerated, username, sourcehost, latitude, longitude
| sort by TimeGenerated desc
```
---

## Successful RDP Logins

**Filename:** `successful_rdp_logins.kql`

**Description:**  
This query retrieves successful RDP login attempts (Event ID 4624) from the default Windows Security events.

**Query:**
```kql
SecurityEvent
| where EventID == 4624
| project TimeGenerated, Account, Computer, LogonType, SourceIP
| sort by TimeGenerated desc
```

---

## Custom Geolocation Map Query

**Filename:** `custom_geo_map.kql`

**Description:**  
This query aggregates events by geolocation fields (latitude and longitude) to support map visualizations in Sentinel Workbooks. It also creates a label field combining country, state, and source IP.

**Query:**
```kql
RDP_Logs_CL
| extend username = extract(@"username:([^,]+)", 1, RawData)
| extend sourcehost = extract(@"sourcehost:([^,]+)", 1, RawData)
| extend latitude = extract(@"latitude:([^,]+)", 1, RawData)
| extend longitude = extract(@"longitude:([^,]+)", 1, RawData)
| extend country = extract(@"country:([^,]+)", 1, RawData)
| extend state = extract(@"state:([^,]+)", 1, RawData)
| where sourcehost != "" and latitude != "" and longitude != ""
| summarize event_count=count() by latitude, longitude, country, state, sourcehost, username
| extend label = strcat(country, " - ", state, " (", sourcehost, ")")
```

