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

$request = "http://www.openspeak.net/downloads/service-hosts.json"

$json = Invoke-WebRequest $request | ConvertFrom-Json

$hastable = @{}
foreach( $property in $json.psobject.Properties.name ) {
  $hastable[$property] = $json.$property
}

foreach ($h in $hastable.GetEnumerator()) {

  Write-Host "Begin scan of service $($h.Name) ... "
  #Write-Host "$($h.Value) | Get-PAMLocalUser"
#
# Begin ghetto silliness; how do I perform this better? I tried editing the 
# source JSON to not include the '"'s with no luck.
#
  $FrustratedTears = '"'+"$($h.Value) | Get-PAMLocalUser"
  $FrustratedTears = $bob.Replace('.pvt ','.pvt", ')
  $FrustratedTears = $bob.Replace('.com ','.com", ')
  $FrustratedTears = $bob.Replace('.org ','.org", ')
  $FrustratedTears = $bob.Replace(', ',', "')
  $FrustratedTears = $bob.Replace(', "| ', ' | ')
  $FrustratedTears
  
}
