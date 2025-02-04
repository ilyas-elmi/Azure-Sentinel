# Get API key from here: https://ipgeolocation.io/
$API_KEY      = "887a9652756d41febd1d75a9787f56e6"
$LOGFILE_NAME = "failed_rdp.log"
$LOGFILE_PATH = "C:\ProgramData\$($LOGFILE_NAME)"

# XML Filter for failed RDP login events from Windows Event Viewer
$XMLFilter = @'
<QueryList>
    <Query Id="0" Path="Security">
        <Select Path="Security">
            *[System[(EventID=4625)]]
        </Select>
    </Query>
</QueryList>
'@

# Convert the XML string into a valid XML object
$xmlFilterObj = [xml]$XMLFilter

# Function to create sample log data (helps train Log Analytics)
Function Write-Sample-Log {
    $sampleData = @"
latitude:47.91542,longitude:-120.60306,destinationhost:samplehost,username:fakeuser,sourcehost:24.16.97.222,state:Washington,country:United States,label:United States - 24.16.97.222,timestamp:2021-10-26 03:28:29
latitude:-22.90906,longitude:-47.06455,destinationhost:samplehost,username:lnwbaq,sourcehost:20.195.228.49,state:Sao Paulo,country:Brazil,label:Brazil - 20.195.228.49,timestamp:2021-10-26 05:46:20
"@
    $sampleData | Out-File $LOGFILE_PATH -Append -Encoding utf8
}

# Create the log file if it does not exist
if (-Not (Test-Path $LOGFILE_PATH)) {
    New-Item -ItemType File -Path $LOGFILE_PATH
    Write-Sample-Log
}

# Infinite loop to monitor Event Viewer for failed RDP logins
while ($true) {
    Start-Sleep -Seconds 1
    $events = Get-WinEvent -FilterXml $xmlFilterObj -ErrorAction SilentlyContinue

    foreach ($event in $events) {
        if ($event.properties[19].Value.Length -ge 5) {
            # Extract relevant fields from the event
            $timestamp = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
            $destinationHost = $event.MachineName
            $username = $event.properties[5].Value
            $sourceIp = $event.properties[19].Value

            # Prevent duplicate log entries
            $log_contents = Get-Content -Path $LOGFILE_PATH
            if (-Not ($log_contents -match "$($timestamp)")) {
                # Call geolocation API
                $API_ENDPOINT = "https://api.ipgeolocation.io/ipgeo?apiKey=$($API_KEY)&ip=$($sourceIp)"
                $response = Invoke-WebRequest -UseBasicParsing -Uri $API_ENDPOINT
                $responseData = $response.Content | ConvertFrom-Json

                # Extract geolocation data
                $latitude = $responseData.latitude
                $longitude = $responseData.longitude
                $state_prov = if ($responseData.state_prov -eq "") { "null" } else { $responseData.state_prov }
                $country = if ($responseData.country_name -eq "") { "null" } else { $responseData.country_name }
                $label = "$country - $sourceIp"

                # Write log entry
                $logEntry = "latitude:$latitude,longitude:$longitude,destinationhost:$destinationHost,username:$username,sourcehost:$sourceIp,state:$state_prov,country:$country,label:$label,timestamp:$timestamp"
                $logEntry | Out-File $LOGFILE_PATH -Append -Encoding utf8

                # Display output
                Write-Host -ForegroundColor Magenta $logEntry
            }
        }
    }
}