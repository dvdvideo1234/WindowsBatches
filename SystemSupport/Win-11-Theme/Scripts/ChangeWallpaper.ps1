#-------------------------------------------------------------------#
# ScriptName : SetWall.ps1                                          #
# Description : Force a Desktop wallpaper Refresh                   #
# Credits  : Unknown (if you know original creator, let us know)    #
#                                                                   #
# Date : 01 July 2020                                               #
#-------------------------------------------------------------------#

#Modify Path to the picture accordingly to reflect your infrastructure
$imgPath=$args[0]
$imgDefo="wallpaper"
$imgExtn=(".jpg", ".jpeg", ".png", ".bnp")
$imgDefp=$(Get-Location)

if(!$imgPath)
{
  Write-Output "Empty [?]: $($imgDefo)"
  
  for ($i = 0; $i -lt $imgExtn.Length; $i++)
  {
    $imgPath = "$($imgDefp)\$($imgDefo)$($imgExtn[$i])"
    
    if(Test-Path $imgPath)
    {
      Write-Output "Empty [V]: $($imgPath)"
      break
    }
    else
    {
      Write-Output "Empty [X]: $($imgPath)"
    }
  }
}
else
{
  $imgTemp = $([System.IO.Path]::GetExtension($imgPath))
  
  if(!$imgTemp)
  {
    Write-Output "Name [?]: $($imgPath)"
    
    for ($i = 0; $i -lt $imgExtn.Length; $i++)
    {
      $imgTemp = "$($imgPath)$($imgExtn[$i])"
      
      if(Test-Path $imgTemp)
      {
        $imgPath = "$($imgTemp)"
        Write-Output "Name [V]: $($imgTemp)"
        break
      }
      else
      {
        Write-Output "Name [X]: $($imgTemp)"
      }
    }
  }
}

if(!$imgPath)
{
  Write-Output "Wallpaper is empty!"
  exit 0
}

if(Test-Path $imgPath)
{
  $imgPath = Resolve-Path $imgPath
  
  Write-Output "Wallpaper [V]: $($imgPath)"
}
else
{
  Write-Output "Wallpaper [X]: $($imgPath)"
  exit 0
}

$code = @'
using System.Runtime.InteropServices;

namespace Win32{
  public class Wallpaper
  {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]

    static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni);

    public static void SetWallpaper(string thePath)
    {
      SystemParametersInfo(20, 0, thePath, 3);
    }
  }
}
'@

add-type $code

#Apply the Change on the system
[Win32.Wallpaper]::SetWallpaper($imgPath)
