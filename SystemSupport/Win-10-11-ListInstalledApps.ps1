Function Get-InstalledApps
{
  [CmdletBinding()]
  param (
    [Switch]$Credential,
    [parameter(ValueFromPipeline=$true)]
    [String[]]$ComputerName = $env:COMPUTERNAME
  )
  begin {$key = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"}
  process
  {
    $ComputerName | Foreach {
    $Comp = $_
    if (!$Credential)
    {
      $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('Localmachine',$Comp)
      $regkey=$reg.OpenSubKey([regex]::Escape($key))
      $SubKeys=$regkey.GetSubKeyNames()
      Foreach ($i in $SubKeys)
      {
        $NewSubKey=[regex]::Escape($key)+""+$i
        $ReadUninstall=$reg.OpenSubKey($NewSubKey)
        $DisplayName=$ReadUninstall.GetValue("DisplayName")
        $Date=$ReadUninstall.GetValue("InstallDate")
        $Publ=$ReadUninstall.GetValue("Publisher")
        New-Object PsObject -Property @{
          "Name"     =$DisplayName;
          "Date"     =$Date;
          "Publisher"=$Publ;
          "Computer" =$Comp} | Where {$_.Name}
      }
    }
    else
    {
      $Cred = Get-Credential
      $connect = New-Object System.Management.ConnectionOptions
      $connect.UserName = $Cred.GetNetworkCredential().UserName
      $connect.Password = $Cred.GetNetworkCredential().Password
      $scope = New-Object System.Management.ManagementScope("$Comprootdefault", $connect)
      $path = New-Object System.Management.ManagementPath("StdRegProv")
      $reg = New-Object System.Management.ManagementClass($scope,$path,$null)
      $inputParams = $reg.GetMethodParameters("EnumKey")
      $inputParams.sSubKeyName = $key
      $outputParams = $reg.InvokeMethod("EnumKey", $inputParams, $null)
      foreach ($i in $outputParams.sNames)
      {
        $inputParams = $reg.GetMethodParameters("GetStringValue")
        $inputParams.sSubKeyName = $key + $i
        $temp = "DisplayName","InstallDate","Publisher" | Foreach
        {
          $inputParams.sValueName = $_
          $outputParams = $reg.InvokeMethod("GetStringValue", $inputParams, $null)
          $outputParams.sValue
        }
        New-Object PsObject -Property @{
          "Name"     =$temp[0];
          "Date"     =$temp[1];
          "Publisher"=$temp[2];
          "Computer" =$Comp} | Where {$_.Name}
        }
      }
    }
  }
}

Get-InstalledApps