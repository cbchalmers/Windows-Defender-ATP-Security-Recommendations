# Project Title

Remediate security recommendations discovered by Windows Defender ATP.

## Description

From [Microsoft Defender Security Center](https://securitycenter.windows.com/machines), there are a small number of recommendations which aren't yet able to be resolved with [Security Baselines](https://docs.microsoft.com/en-us/mem/intune/protect/security-baselines) or [Configuration Profiles](https://docs.microsoft.com/en-us/mem/intune/configuration/device-profile-create). This script is intended to be a short term solution for applying the recommendations until either of the alternatives have been incorporated by Microsoft.

#### Recommendations Addressed

* Enable 'Local Security Authority (LSA) protection'
* Enable 'Require domain users to elevate when setting a network's location'
* Disable the local storage of passwords and credentials
* Account lockout threshold

### Prerequisites

None

### Installing Locally

Simply run from a PowerShell session as Administrator.

### Installing with Intune

* [Microsoft Endpoint Manager Admin Center](https://devicemanagement.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/DevicesMenu/powershell)
* Add > Windows 10
* Run this script using the logged on credentials = No
* Enforce script signature check = No
* Run script in 64 bit PowerShell Host = No

## Built With

* PowerShell

## References

None

## Authors

Chris Chalmers - [LinkedIn](https://uk.linkedin.com/in/chris-chalmers), [Azure DevOps](https://dev.azure.com/cbchalmers/Personal%20Development), [GitHub](https://github.com/cbchalmers)