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

$ruleFile = Join-Path -Path $PSScriptRoot -ChildPath 'rules' -AdditionalChildPath '06-fileWithRules-conventions.Rule.ps1' -Resolve

$ruleOptions = New-PSRuleOption -TargetName id -Convention 'convention.init','convention.begin','convention.process','convention.end'
$assesmentResult = $dataToAsses | Invoke-PSRule -Path $ruleFile -Option $ruleOptions -WarningAction SilentlyContinue
$assesmentResult | Select-Object -Property * | Out-GridView -Title "Assessment result using ruleFile: $(Split-Path -Path $ruleFile -LeafBase)"