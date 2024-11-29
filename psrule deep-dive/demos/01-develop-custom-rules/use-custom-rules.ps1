$dataToAsses = @(
    @{
        type      = 'user'
        id        = 1
        firstName = 'John'
        lastName  = 'Doe'
        age       = 19
        enabled   = $true
    },
    @{
        type      = 'user'
        id        = 2
        firstName = 'Andy'
        lastName  = 'Park'
        age       = 22
        enabled   = $false
    },
    @{
        type    = 'workloadIdentity'
        id      = 3
        name    = 'devops'
        enabled = $true
    },
    @{
        type    = 'workloadIdentity'
        id      = 4
        name    = 'app01'
        enabled = $false
    },
    @{
        type    = 'group'
        id      = 5
        name    = 'app01-admins'
        members = @(
            1, 3
        )
        enabled = $false
    },
    @{
        type    = 'group'
        id      = 5
        name    = 'app02-admins'
        members = @()
        enabled = $false
    }
)

$ruleFolder = Join-Path -Path $PSScriptRoot -ChildPath 'rules'
$ruleFiles = Get-ChildItem -Path $ruleFolder -File
foreach ($ruleFile in $ruleFiles )
{
    Write-Warning "Using ruleFile: $($ruleFile.BaseName)"
    $assesmentResult = $dataToAsses | Invoke-PSRule -Path $ruleFile.FullName -WarningAction SilentlyContinue
    $assesmentResult | Select-Object -Property * | Out-GridView -Title "Assessment result using ruleFile: $($ruleFile.BaseName)"
    
    #put breakpoint here
    Clear-Host
}
