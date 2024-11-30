
Export-PSRuleConvention 'userResolver.init' -Initialize {
  $PSRule.AddService('userResolver', [userResolver]::new())
}

Export-PSRuleConvention 'userResolver.resolve' -if {$TargetObject.userType -eq 'Member'} -Begin {
  $userResolver = $PSRule.GetService('userResolver')
  $userResolver.AddUser($TargetObject)
  Write-Host "Found user: $($TargetObject.userPrincipalName)"
}

class userResolver {
  [hashtable]$data = @{}
  [void] AddUser([psobject] $user) {
    $this.data[$user.userPrincipalName] = $user
  }
  [psobject] GetUser([string] $upn) {
    return $this.data[$upn]
  }
  [bool] ContainsUser([string] $upn) {
    return $this.data.ContainsKey($upn)
  }
}