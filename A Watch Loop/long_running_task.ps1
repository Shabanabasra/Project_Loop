Start-Sleep -Seconds 180
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"done $($timestamp)" | Out-File -FilePath DONE.txt -Encoding utf8
