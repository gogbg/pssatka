$modulePath = Join-Path -Path $PSScriptRoot -ChildPath modules -AdditionalChildPath 'MyPSRModule'
$outFolder = Join-Path -Path $PSScriptRoot -ChildPath 'export'

Import-Module -Name $modulePath -Force

Export-MyPSRData -OutFolder $outFolder -TenantId '098ebab6-0ca3-4735-973c-7e8b14e101ac' -SubscriptionId '88e64586-f51c-4e13-9307-c97f28464675'

$dataToAssess = Get-MyPSRExport -OutFolder $outFolder

$assesmentResult = $dataToAssess | Invoke-PSRule -Module MyPSRModule -WarningAction SilentlyContinue
$assesmentResult | Select-Object -Property * | Out-GridView -Title "Assessment result using MyPSRModule"