function Export-MyPSRData
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$OutFolder,

        [Parameter(Mandatory)]
        [string]$TenantId,

        [Parameter(Mandatory)]
        [string]$SubscriptionId
    )

    #Create azureExportFolder folder
    $azureExportFolder = Join-Path -Path $OutFolder -ChildPath 'azure'
    if (-not (Test-Path -Path $azureExportFolder))
    {
        $null = New-Item -Path $azureExportFolder -ItemType Directory
    }

    #Export Azure Resource Data
    $null = Export-AzRuleData -OutputPath $azureExportFolder -Subscription $SubscriptionId -Tenant $TenantID

    #Create entraExportFolder folder
    $entraExportFolder = Join-Path -Path $OutFolder -ChildPath 'entraid'
    if (-not (Test-Path -Path $entraExportFolder))
    {
        $null = New-Item -Path $entraExportFolder -ItemType Directory
    }

    #Export EntraId Data
    $token = Get-AzAccessToken -ResourceTypeName MSGraph -WarningAction SilentlyContinue
    Connect-MgGraph -AccessToken ($token.Token | ConvertTo-SecureString -AsPlainText) -NoWelcome
    $null = Export-Entra -Path $exportFolder -Type Users
}

function Get-MyPSRExport
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$OutFolder
    )

    $dataToAssess = [System.Collections.Generic.List[hashtable]]::new()
    Get-ChildItem -Path $OutFolder -Recurse -Filter '*.json' | ForEach-Object -Process {
        Get-Content -Path $_.FullName -raw | ConvertFrom-Json -Depth 20 -AsHashtable | ForEach-Object {
            $dataToAssess.Add($_)
        }
    }
    $dataToAssess
}