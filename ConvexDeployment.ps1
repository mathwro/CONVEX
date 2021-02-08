#Script created by: Mathias Wrobel // Innofactor
#Verify installed modules
#Required modules Azure, AzureAD, Az

$wd = Get-Location
$modules = $wd.ToString() + "\Utils\functions"
Import-Module -Name $modules 

#Check for module "Azure"
if (-not(Get-InstalledModule).Name -Match "Azure") {
    Write-Host "Module: 'Azure', is missing, quitting"
    exit
}
<# #Check for module "AzureAD"
if (-not(Get-InstalledModule).Name -Match "AzureAD") {
    Write-Host "Module: 'AzureAD', is missing, quitting"
    Write-Host "If using PS7, module should be imported used the following command: 'Import-Module AzureAD -UseWindowsPowerShell'"
    exit
} #>
#Check for module "Az"
if (-not(Get-InstalledModule).Name -Match "Az") {
    Write-Host "Module: 'Az', is missing, quitting"
    exit
}

if (-not(az --version)) {
    Write-Host "Program: 'Az CLI', is missing, quitting"
    exit
}


Write-Host "Importing config file"
$conf = Get-Content $PSScriptRoot/config.json | ConvertFrom-Json
Write-Host $conf
if (-not(Read-Host "Is the above config correct?" = "yes")) {
    Write-Host "Please correct the config and rerun"
    exit
}

Write-Host "Changing contexts"
(Get-AzSubscription -TenantId $conf.TenantId -SubscriptionId $conf.SubOne | Set-AzContext)
az account set --subscription $conf.SubOne

# Decide if we are creating or deleting modules
$cOrT =@()
$cOrT += "create"
$cOrT += "teardown"
do {
    $decision = Read-Host -Prompt 'Do you want to create or teardown modules?'
    $d1 = $cOrT.Contains($decision)
    if (-Not $d1) {Write-Host "Not a valid input"}
} until ($d1)

# Either create or teardown each module
$dirs = Get-ChildItem . -Directory | Where-Object Name -CLike Module* | Sort-Object Name
foreach ($mod in $dirs.Name) {

    # Create or delete
    Set-Location .\$mod
    if ($decision -eq "create") {
        .\create.ps1 -SubOne $conf.SubOne -SubTwo $conf.SubTwo -usernum $conf.userNum -domainname $conf.domainname
    } else {
        .\teardown -SubOne $SubOne -SubTwo $SubTwo
    }
    Set-Location ..
}