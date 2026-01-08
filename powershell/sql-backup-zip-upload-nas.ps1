# ================= CONFIG =================
$BackupDir = "C:\Backups\SQL"
$ZipDir    = "C:\Backups\ZIP"
$NASPath   = "\\NAS01\sql_backups"
$LogDir    = "C:\Backups\logs"
$Date      = Get-Date -Format "yyyyMMdd_HHmm"

$TelegramToken = "YOUR_BOT_TOKEN"
$ChatID = "YOUR_CHAT_ID"
# ==========================================

New-Item -ItemType Directory -Force -Path $BackupDir, $ZipDir, $LogDir | Out-Null

$LogFile = "$LogDir\backup-$Date.log"

function Send-Telegram {
    param($Message)
    $Url = "https://api.telegram.org/bot$TelegramToken/sendMessage"
    Invoke-RestMethod -Uri $Url -Method Post -Body @{
        chat_id = $ChatID
        text    = $Message
    }
}

try {
    Write-Output "Starting SQL backup..." | Tee-Object -FilePath $LogFile

    sqlcmd -Q "BACKUP DATABASE MyDatabase TO DISK='$BackupDir\db_$Date.bak'"

    Compress-Archive -Path "$BackupDir\db_$Date.bak" `
                     -DestinationPath "$ZipDir\db_$Date.zip"

    Copy-Item "$ZipDir\db_$Date.zip" $NASPath -Force

    Remove-Item "$BackupDir\db_$Date.bak"

    Send-Telegram "✅ SQL Backup completed successfully ($Date)"
}
catch {
    Send-Telegram "❌ SQL Backup FAILED: $_"
}
