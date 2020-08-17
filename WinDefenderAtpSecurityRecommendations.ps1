<#
# Start Logging
#>
$LogPrefix = "Log-WinDefenderAtpSecurityRecommendations-$Env:Computername-"
$LogDate = Get-Date -Format dd-MM-yyyy-HH-mm
$LogName = $LogPrefix + $LogDate + ".txt"
Start-Transcript -Path "C:\Windows\Temp\$LogName"

<#
# You can use the Test-Path cmdlet to check for a key, but not for specific values within a key
# Using the below function we can see if Get-ItemProperty contains the value or not, then also take different actions for data within the value
# If the value doesn't exist we will return $False, which later calls New-ItemProperty
# If the value already exists (by checking 0 or greater) we will return $True, which later calls Set-ItemProperty
#>
function Test-RegistryValue {

    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Path,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Name
    )

    try {
        $ItemProperty = Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Name -ErrorAction Stop
        if ($ItemProperty -ge "0") {
            return $true
        }
        else {
            return $false
        }
    }

    catch {
        return $false
    }
}

<#
# Using the below function we can create a new value (when $False) or update an existing value to 1 (when $True)
# Set-ItemProperty doesn't support -PropertyType parameter therefore can't handle both scenarios
#>
function Update-RegistryValue {

    param (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Path,

        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]$Name,

        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]$Exists
    )

    try {
        if ($Exists -eq $False) {
            New-ItemProperty -Path $Path -Name $Name -Value "1" -PropertyType "DWord" -ErrorAction Stop
            Write-Host "$Path\$Name has been created"
        }
        else {
            Set-ItemProperty -Path $Path -Name $Name -Value "1" -ErrorAction Stop
            Write-Host "$Path\$Name has been updated"
        }
        return $true
    }

    catch {
        return $false
    }
}

<#
# Title
## Enable 'Local Security Authority (LSA) protection'
# Description
## Forces LSA to run as Protected Process Light (PPL).
# Potential Risk
## If LSA isn't running as a protected process, attackers could easily abuse the low process integrity for attacks (such as Pass-the-Hash).
# CCE
## N/A
#>

$RunAsPPLKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$RunAsPPLName = "RunAsPPL"
$RunAsPPLExists = Test-RegistryValue -Path $RunAsPPLKey -Name $RunAsPPLName
Update-RegistryValue -Exists $RunAsPPLExists -Path $RunAsPPLKey -Name $RunAsPPLName

<#
# Title
## Enable 'Require domain users to elevate when setting a network's location'
# Description
## Determines whether to require domain users to elevate when setting a network's location.
# Potential Risk
## Selecting an incorrect network location may allow greater exposure of a system
# CCE
## CCE-35554-5
#>

$NC_StdDomainUserSetLocationKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$NC_StdDomainUserSetLocationName = "NC_StdDomainUserSetLocation"
$NC_StdDomainUserSetLocationExists = Test-RegistryValue -Path $NC_StdDomainUserSetLocationKey -Name $NC_StdDomainUserSetLocationName
Update-RegistryValue -Exists $NC_StdDomainUserSetLocationExists -Path $NC_StdDomainUserSetLocationKey -Name $NC_StdDomainUserSetLocationName

<#
# Title
## Disable the local storage of passwords and credentials
# Description
## Determines whether Credential Manager saves passwords or credentials locally for later use when it gains domain authentication.
# Potential Risk
## Locally cached passwords or credentials can be accessed by malicious code or unauthorized users.
# CCE
## N/A
#>

$DisableDomainCredsKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$DisableDomainCredsName = "DisableDomainCreds"
$DisableDomainCredsExists = Test-RegistryValue -Path $DisableDomainCredsKey -Name $DisableDomainCredsName
Update-RegistryValue -Exists $DisableDomainCredsExists -Path $DisableDomainCredsKey -Name $DisableDomainCredsName

<#
# Stop Logging
#>
Stop-Transcript