dism /Online /Get-ProvisionedAppxPackages | Select-String PackageName `
                                          | Select-String microsoftteams | ForEach-Object {$_.Line.Split(':')[1].Trim()} `
                                          | ForEach-Object { dism /Online /Remove-ProvisionedAppxPackage /PackageName:$_}
                                          