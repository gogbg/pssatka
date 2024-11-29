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

$modulePath = Join-Path -Path $PSScriptRoot -ChildPath 'MyModule' -Resolve

Import-Module -Name $modulePath

$assesmentResult = $dataToAsses | Invoke-PSRule -Module MyModule -WarningAction SilentlyContinue
$assesmentResult | Select-Object -Property * | Out-GridView -Title "Assessment result using MyModule"