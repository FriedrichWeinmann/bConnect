function Search-bConnectJob
{
<#
	.SYNOPSIS
		Search for specified jobs.
	
	.DESCRIPTION
		Search for specified jobs.
	
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
			Type = "job"
			Term = $Term
		}
		
		Invoke-bConnectGet -Controller "Search" -Data $body | Where-Object ID -NE $false | Select-PSFObject 'ID as JobGuid', ID, Name, AdditionalInfo, 'Type to bConnectSearchResultType'
	}
}