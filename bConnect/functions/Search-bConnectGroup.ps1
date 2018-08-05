function Search-bConnectGroup
{
<#
	.SYNOPSIS
		Search for specified group.
	
	.DESCRIPTION
		Search for specified group.
	
	.PARAMETER Term
		Searchterm for the search. Wildcards allowed.
#>
	[CmdletBinding()]
	param
	(
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
		Invoke-bConnectGet -Controller "Search" -Data $body | Where-Object ID -ne $null | Select-PSFObject 'ID as OrgUnit', ID, Name, AdditionalInfo, 'Type to bConnectSearchResultType'
	}
}