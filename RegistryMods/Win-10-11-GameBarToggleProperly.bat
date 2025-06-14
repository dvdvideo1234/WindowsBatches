@(echo off% <#%) &title ToggleGamebar - properly [updated 2022.08.16]
set "0=%~f0"&set 1=%*&powershell -nop -win 1 -c iex ([io.file]::ReadAllText($env:0)) &exit /b ||#>)[1]
## wrap script
sp 'HKCU:\Volatile Environment' 'ToggleGamebar' @'

## status for GamebarPresenceWriter
$key='HKLM:\SOFTWARE\Microsoft\WindowsRuntime\Server\Windows.Gaming.GameBar.Internal.PresenceWriterServer'
if ((gp $key ExePath -ea 0).ExePath -like "*systray.exe*") {$Y=6;$N=7;$A='Enable';$S='OFF'}else{$Y=7;$N=6;$A='Disable';$S='ON'}
## dialog prompt with Yes, No, Cancel (6,7,2)
if ($env:1 -ne 6 -and $env:1 -ne 7) {
  $choice=(new-object -ComObject Wscript.Shell).Popup($A + ' Gamebar?', 0, 'Gamebar is: ' + $S, 0x1033)
  if ($choice -eq 2) {break} elseif ($choice -eq 6) {$env:1=$Y} else {$env:1=$N}
}

## toggle Gamebar
sp 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' AppCaptureEnabled ($env:1-6) -Type Dword -Force -ea 0

## relaunch as Admin passing cmdline args
$script='-nop -c & {$env:1='+$env:1+';iex((gp Registry::HKEY_Users\S-1-5-21*\Volatile* ToggleGamebar -ea 0)[0].ToggleGamebar)}'
$null=fltmc;if($LASTEXITCODE -gt 0){start powershell -args $script -verb runas -win 1; break}

function reg_own { param ( $key, $recurse='', $user='S-1-5-32-544', $owner='', $acc='Allow', $perm='FullControl', [switch]$list )
  $D1=[uri].module.gettype('System.Diagnostics.Process')."GetM`ember"('SetPrivilege',42)[0]; $u=$user; $o=$owner; $p=524288
  'SeSecurityPrivilege','SeTakeOwnershipPrivilege','SeBackupPrivilege','SeRestorePrivilege' |% {$D1.Invoke($null, @("$_",2))}
  $reg=$key-split':?\\',2; $key=$reg-join'\'; $HK=gi -lit Registry::$($reg[0]) -force; $re=$recurse; $in=(1,0)[$re-eq'Inherit']
  $own=$o-eq''; if($own){$o=$u}; $sid=[Security.Principal.SecurityIdentifier]; $w='S-1-1-0',$u,$o |% {new-object $sid($_)}
  $r=($w[0],$p,1,0,0),($w[1],$perm,1,0,$acc) |% {new-object Security.AccessControl.RegistryAccessRule($_)}; function _own($k,$l) {
  $t=$HK.OpenSubKey($k,2,'TakeOwnership'); if($t) { try {$n=$t.GetAccessControl(4)} catch {$n=$HK.GetAccessControl(4)}
  $u=$n.GetOwner($sid); if($own-and $u) {$w[2]=$u}; $n.SetOwner($w[0]); $t.SetAccessControl($n); $d=$HK.GetAccessControl(2)
  $c=$HK.OpenSubKey($k,2,'ChangePermissions'); $b=$c.GetAccessControl(2); $d.RemoveAccessRuleAll($r[1]); $d.ResetAccessRule($r[0])
  $c.SetAccessControl($d); if($re-ne'') {$sk=$HK.OpenSubKey($k).GetSubKeyNames(); foreach($i in $sk) {_own "$k\$i" $false}}
  if($re-ne'') {$b.SetAccessRuleProtection($in,1)}; $b.ResetAccessRule($r[1]); if($re-eq'Delete') {$b.RemoveAccessRuleAll($r[1])}
  $c.SetAccessControl($b); $b,$n |% {$_.SetOwner($w[2])}; $t.SetAccessControl($n)}; if($l) {return $b|fl} }; _own $reg[1] $list
} # :reg_own: lean & mean snippet by AveYo

$GameBarPresenceWriter=("$env:systemroot\System32\GameBarPresenceWriter.exe","$env:systemroot\System32\systray.exe")[$env:1 -gt 6]
$key='HKLM:\SOFTWARE\Microsoft\WindowsRuntime\Server\Windows.Gaming.GameBar.Internal.PresenceWriterServer'
if (test-path $key) {
  reg_own $key -user S-1-1-0
  sp $key ExePath $GameBarPresenceWriter -Force -ea 0
  reg_own $key -user S-1-1-0 -recurse Delete
}

$GameBarFTServer=('GameBarFTServer.exe','systray.exe')[$env:1 -gt 6]
$app=(dir 'HKLM:\SOFTWARE\Classes\PackagedCom\ClassIndex\{FD06603A-2BDF-4BB1-B7DF-5DC68F353601}').PSChildName
$key="HKLM:\SOFTWARE\Classes\PackagedCom\Package\$app\Server\0"
if (test-path $key) {
  reg_own $key -user S-1-1-0
  sp $key Executable $GameBarFTServer -Force -ea 0
  reg_own $key -user S-1-1-0 -recurse Delete
}

## stop processes
'GameBar','GamebarPresenceWriter','GameBarFTServer' |foreach {kill -Force -Name $_ -ea 0}

## execute script
'@ -Force -ea 0; iex((gp Registry::HKEY_Users\S-1-5-21*\Volatile* ToggleGamebar -ea 0)[0].ToggleGamebar)
#-_-# hybrid script, can be pasted directly into powershell console
