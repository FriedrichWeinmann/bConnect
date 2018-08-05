function ConvertTo-Hashtable
{
<#
	.SYNOPSIS
		Converts objects to hashtables
	
	.DESCRIPTION
		Converts objects to hashtables
	
	.PARAMETER Object
		The object(s) to convert to a hashtable
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[PSObject[]]
		$Object
	)
	process
	{
		foreach ($objectItem in $Object)
		{
			$hashtable = [ordered]@{ }
			$objectItem | Get-Member -MemberType *Property | ForEach-Object {
				$hashtable[$_.Name] = $_.Value
			}
			$hashtable
		}
	}
}
