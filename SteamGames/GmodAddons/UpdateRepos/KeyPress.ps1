param (
  [string]$Window = "",
  [string]$Press = "~",
  [int]   $SleepSt = 0,
  [int]   $SleepEn = 0,
  [switch]$Verbose = $false
)

# Wait 2 seconds before doing anything
Start-Sleep -Seconds $SleepSt

$wshell = New-Object -ComObject wscript.shell;

if($Verbose)
{
  Write-Host "Sent '$Press' to '$Window'"
}

# Attempt to focus the window
if ($wshell.AppActivate($Window)) {
  # Brief pause to allow window focus to complete
  Start-Sleep -Milliseconds 800
  
  # Send the key passed from CMD
  $wshell.SendKeys($Press)
} else {
    Write-Error "Could not find window: $Window"
}

# Optional: Wait so you can see the result before the close
Start-Sleep -Seconds $SleepEn

exit 0
