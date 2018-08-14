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
			foreach ($property in $objectItem)
			{
				$hashtable[$property.Name] = $property.Value
			}
			$hashtable
		}
	}
}
