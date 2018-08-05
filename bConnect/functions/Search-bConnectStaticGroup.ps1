function Search-bConnectStaticGroup
{
<#
	.SYNOPSIS
		Search for specified static group.
	
	.DESCRIPTION
		Search for specified static group.
	
	.PARAMETER Term
		Searchterm for the search. Wildcards allowed.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Term
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	
	process
	{
		$body = @{
			Type = "group"
			Term = $Term
		}
		
		Invoke-bConnectGet -Controller "Search" -Data $body | Where-Object ID -NE $null | Select-PSFObject  'ID as StaticGroupGuid', ID, Name, AdditionalInfo, 'Type to bConnectSearchResultType'
	}
}