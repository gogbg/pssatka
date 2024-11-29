
Export-PSRuleConvention 'userResolver.init' -Initialize {
  $PSRule.AddService('userResolver', [userResolver]::new())
}

Export-PSRuleConvention 'userResolver.resolve' -if {$TargetObject.type -eq 'user'} -Begin {
  $userResolver = $PSRule.GetService('userResolver')
  $userResolver.AddUser($TargetObject)
}

class userResolver {
  [hashtable]$data = @{}
  [void] AddUser([psobject] $user) {
    $this.data[$user.id] = $user
  }
  [psobject] GetUser([int] $id) {
    return $this.data[$id]
  }
  [bool] ContainsUser([int] $id) {
    return $this.data.ContainsKey($id)
  }
}