# https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Variables/#psrule

Rule 'User.enabled' -if {$TargetObject.type -eq 'user'} {
  Recommend 'Users should be enabled'
  $Assert.HasFieldValue($TargetObject, 'enabled', $true)
} 

Rule 'Group.NotEmpty' -if {$TargetObject.type -eq 'group'} {
  Recommend 'Groups should have members'
  $Assert.GreaterOrEqual($TargetObject,'members',0)
}

Export-PSRuleConvention 'userResolver.init' -Initialize {
  $PSRule.AddService('userResolver', [userResolver]::new())
}

Export-PSRuleConvention 'userResolver.resolve' -if {$TargetObject.type -eq 'user'} -Begin {
  $userResolver = $PSRule.GetService('userResolver')
  $userResolver.AddUser($TargetObject)
  Write-Host "userResolver found user with id: $($TargetObject.id)"
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

Rule 'Group.ShouldHaveValidUsers' -if {$TargetObject.type -eq 'group'} {
  Recommend 'Groups should have valid users'
  $userResolver = $PSRule.GetService('userResolver')
  if ($TargetObject.members.count -gt 0)
  {
    $invalidUsers = $TargetObject.members.where{-not $userResolver.ContainsUser($_)}

    if ($invalidUsers) {
      reason "Users with id: '$($invalidUsers -join ',')' are not valid"
      $false
    }
    else
    {
      $true
    }
  }
  else
  {
    $true
  }
}