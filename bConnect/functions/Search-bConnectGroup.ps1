<#
	.Synopsis
		Search for specified group.
	
	.DESCRIPTION
		A detailed description of the Search-bConnectGroup function.
	
	.Parameter Term
		Searchterm for the search. Wildcards allowed.
	
	.Outputs
		Array of SearchResult (see bConnect documentation for more details)
	
	.NOTES
		Additional information about the function.
#>
function Search-bConnectGroup {
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$Term
	)
	
	begin {
		$Test = Test-bConnect
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
	}
	
	process {
		$_body = @{
			Type = "group";
			Term = $Term
		}	
		$Result = Invoke-bConnectGet -Controller "Search" -Data $_body | Where-Object { [string]::IsNullOrEmpty($_.ID) -eq $false } | Select-Object  @{ Name = "OrgUnit"; Expression = { $_.ID } }, ID, Name, AdditionalInfo, @{ Name = "Type"; Expression = { [bConnectSearchResultType]$_.Type } }
		$Result
	}
}