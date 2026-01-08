param(
    [string]$Message = "Notification from server"
)

$Token  = "YOUR_BOT_TOKEN"
$ChatID = "YOUR_CHAT_ID"

Invoke-RestMethod `
  -Uri "https://api.telegram.org/bot$Token/sendMessage" `
  -Method Post `
  -Body @{
    chat_id = $ChatID
    text    = $Message
}
