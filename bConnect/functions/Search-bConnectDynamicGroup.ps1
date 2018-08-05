function Search-bConnectDynamicGroup
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
			Type = "group";
			Term = $Term
		}
		
		Invoke-bConnectGet -Controller "Search" -Data $body |
		Where-Object Type -eq ([bConnectSearchResultType]::DynamicGroup) |
		Select-PSFObject  'ID as DynamicGroupGuid', ID, Name, AdditionalInfo, 'Type to bConnectSearchResultType'
	}
}