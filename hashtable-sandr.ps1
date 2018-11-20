################################################################################
# WAYTTA: 
# Another team manages a script/module which defines "Get-PAMLocalUser" among 
# other things. I need to dot-source their file and pass along a list of hosts
# to generate detailed host output for various security reporting requirements.
#
# In order to schedule/automate the periodic scans and provide one-off requests,
# I plan to wrap this up as a source controlled Jenkins button.
#
# . ./parentScript.ps1
# "host1.company.tld", "host2.company.tld", "host3.company.pvt" | Get-PAMLocalUser
#
# This generates a set of CSVs that get off-loaded elsewhere for other processing.
#

# Our list of services and their hosts
$request = "http://www.openspeak.net/downloads/service-hosts.json"

# Suck in our service/host list as a JSON object
$json = Invoke-RestMethod -Uri $request
$json = $json | ConvertTo-Json -Depth 3 | ConvertFrom-Json

# Dot source to setup our environment
. ".\runAppServerLogins.ps1"

# Enumerate first level JSON; services
foreach ($item in $json) {  

  $cmdLine = ""
  $zipList = ""  
  
  # Enumerate second level JSON; hosts
  foreach ($property in $item.psobject.Properties) {
      
    #$zipList = $zipList + " " + $($property.Value).split('.')[0]
    $zipList = $($property.Value) -replace '$', '-IALocalUserAudit.csv'
        
    $cmdLine = '"'+"$($property.Value)"+'"' -replace ' ', '", "'
    $cmdLine = $cmdLine + " | Get-PAMLocalUser"
    iex $cmdLine # Do the scan
    
    #Powershell v3 is lacking in archive management; thank you GNUwin32
    $zipLine = ".\zip.exe " + $filedate + "-" + $property.name + ".zip " + $zipList
    iex $zipLine

    #CleanUp
    Remove-Item *.csv
  }
    
}
