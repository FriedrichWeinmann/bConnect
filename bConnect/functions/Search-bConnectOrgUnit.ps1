function Search-bConnectOrgUnit
{
<#
	.SYNOPSIS
		Search for specified OrgUnit.
	
	.DESCRIPTION
		Search for specified OrgUnit.
	
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
			Type = "orgunit"
			Term = $Term
		}
		
		Invoke-bConnectGet -Controller "Search" -Data $body | Where-Object ID -NE $null | Select-PSFObject  'ID as OrgUnit', ID, Name, AdditionalInfo, 'Type to bConnectSearchResultType'
	}
}