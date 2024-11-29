Rule 'user.enabled' -if {$TargetObject.type -eq 'user'} {
  $Assert.HasFieldValue($TargetObject, 'enabled', $true)
}