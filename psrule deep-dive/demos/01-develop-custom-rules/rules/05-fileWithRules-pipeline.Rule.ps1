# https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Assert/

Rule 'User.enabled' -If {

  Write-Host "Selecting $($TargetObject.id) with User.enabled"
  $TargetObject.type -eq 'user'

  } -Body {

  Recommend 'Users should be enabled'
  $Assert.HasFieldValue($TargetObject, 'enabled', $true) # auto setting the reason, if condition is not met
  Write-Host "Processing $($TargetObject.id) with User.enabled"

}

Rule 'Group.NotEmpty' -If {

  Write-Host "Selecting $($TargetObject.id) with Group.NotEmpty"
  $TargetObject.type -eq 'group'

  } -Body {

  Recommend 'Groups should have members'
  $Assert.GreaterOrEqual($TargetObject,'members',0) # auto setting the reason, if condition is not met
  Write-Host "Processing $($TargetObject.id) with Group.NotEmpty"

}
