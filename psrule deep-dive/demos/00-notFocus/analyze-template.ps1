#requires -module Bicep

$templateName = 'app'
$templateFolder = Join-Path -Path $PSScriptRoot -ChildPath template
$templateFilePath = Join-Path -Path $templateFolder -ChildPath "$templateName.bicep"
$templateParamFilePath = Join-Path -Path $templateFolder -ChildPath "$templateName.bicepparam"

$templateDataFolder = Join-Path -Path $PSScriptRoot -ChildPath 'templateExport'
if (-not (Test-Path -Path $templateDataFolder))
{
    New-Item -Path $templateDataFolder -ItemType Directory
}

try {
  Build-Bicep -Path $templateFilePath
  Build-BicepParam -Path $templateParamFilePath
  Export-AzRuleTemplateData -TemplateFile "$templateFolder\$templateName.json" -ParameterFile "$templateFolder\$templateName.parameters.json" -OutputPath $templateDataFolder
} finally {
  Remove-Item -Path "$templateFolder\$templateName.json"
  Remove-Item -Path "$templateFolder\$templateName.parameters.json"
}

# #Asses template using WAF
$assesmentResult = Invoke-PSRule -InputPath "$templateDataFolder\*" -Module PSRule.Rules.Azure
$assesmentResult | Select-Object -Property * | Out-GridView -Title "Assessment result using PSRule.Rules.Azure on template export"
Clear-Host