# Input bindings are passed in via param block.
param($Timer)

Write-Host "Entering function ProcessData. TIME: $currentUTCtime"

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "Timer is running late!"
}

Write-Host "Processing request..."

$Resource = "https://vault.azure.net"
$TenantId = ""
$AppObjectId = "7f37c1de-08f7-4e61-98b1-65ae1a5fb628"
$Password = "cdabf7b1-a97c-476c-aa13-79b6daf70024"

$body = @{Resource = $Resource; client_id = $AppObjectId; grant_type = "client_credentials"; client_secret = $Password} 

$url = "https://login.microsoftonline.com/$TenantId/oauth2/token" 

$result = Invoke-WebRequest -Uri $url -Method Post -Body $body  

Write-Host "Authenticating..."

$token = (ConvertFrom-Json $result.Content).access_token 

Write-Host "Authentication complete $token"

Write-Host "Processing complete."

# Write an information log with the current time.
Write-Host "Exiting function ProcessData. TIME: $currentUTCtime"
