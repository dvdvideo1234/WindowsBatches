Function Format-FileSize() {
    Param ([int64]$size)
    If     ($size -gt 1TB) {[string]::Format("{0:0.00} TB", $size / 1TB)}
    ElseIf ($size -gt 1GB) {[string]::Format("{0:0.00} GB", $size / 1GB)}
    ElseIf ($size -gt 1MB) {[string]::Format("{0:0.00} MB", $size / 1MB)}
    ElseIf ($size -gt 1KB) {[string]::Format("{0:0.00} kB", $size / 1KB)}
    ElseIf ($size -gt 0)   {[string]::Format("{0:0.00} B", $size)}
    Else                   {""}
}

Get-ChildItem -Recurse -Force -ErrorAction Continue 2>&1 | %{
  if($_ -is [System.Management.Automation.ErrorRecord]){
    # if this is an error, print the exception message directly to the screen
    Write-Host $_.Exception.Message -ForegroundColor Red
  }
  else {
    # otherwise, just output the input object as-is
    $_
  }
} |
  sort -descending -property length |
  Select-Object @{Name="Size";Expression={Format-FileSize($_.Length)}}, FullName |
  select -first 50
