function Compare-ObjectProperty
{
<#
	.SYNOPSIS
		Generates a list of properties that do not have equal value between two objects.
	
	.DESCRIPTION
		Generates a list of properties that do not have equal value between two objects.
	
	.PARAMETER ReferenceObject
		The first object to compare the properties of.
	
	.PARAMETER DifferenceObject
		The second object to compare the properties of.
	
	.EXAMPLE
		PS C:\> Compare-ObjectProperty $item1 $item2
	
		Generates a list of all properties that do not have the same value between $item1^and $item2
#>
	[CmdletBinding()]
	param (
		$ReferenceObject,
		
		$DifferenceObject
	)
	$objprops = $ReferenceObject | Get-Member -MemberType Property, NoteProperty - | ForEach-Object Name -WhatIf:$False
	$objprops += $DifferenceObject | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name -WhatIf:$False
	$objprops = $objprops | Sort-Object | Select-Object -Unique
	$diffs = @()
	foreach ($objprop in $objprops)
	{
		$diff = Compare-Object $ReferenceObject $DifferenceObject -Property $objprop
		if ($diff)
		{
			[pscustomobject]@{
				PropertyName = $objprop
				RefValue	 = ($diff | Where-Object SideIndicator -eq '<=' | ForEach-Object $($objprop) -WhatIf:$False)
				DiffValue    = ($diff | Where-Object SideIndicator -eq '=>' | ForEach-Object $($objprop) -WhatIf:$False)
			}
		}
	}
}