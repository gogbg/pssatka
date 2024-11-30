Rule 'group.NotEmpty' -if {$TargetObject.type -eq 'group'} {
  $Assert.GreaterOrEqual($TargetObject,'members',0)
}


Rule 'group.ShouldHaveValidUsers' -if {$TargetObject.type -eq 'group'} {
  $userResolver = $PSRule.GetService('userResolver')
  if ($TargetObject.members.count -gt 0)
  {
    $invalidUsers = $TargetObject.members.where{-not $userResolver.ContainsUser($_)}

    if ($invalidUsers) {
      reason "Users with id: '$($invalidUsers -join ',')' are not valid"
      $PSRule.Data['invalidMemberIds'] = $invalidUsers #this will append the data to the assessment result
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