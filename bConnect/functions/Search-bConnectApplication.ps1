<#
	.Synopsis
		Search for specified applications and apps.
	
	.DESCRIPTION
		A detailed description of the Search-bConnectApplication function.
	
	.Parameter Term
		Searchterm for the search. Wildcards allowed.
	
	.PARAMETER OnlySoftware
		A description of the OnlySoftware parameter.
	
	.PARAMETER OnlyApps
		A description of the OnlyApps parameter.
	
	.Outputs
		Array of SearchResult (see bConnect documentation for more details)
	
	.NOTES
		Additional information about the function.
#>
function Search-bConnectApplication {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$Term,
		[Parameter(ParameterSetName = 'SearchApps',
				   Mandatory = $false)]
		[Switch]$OnlySoftware,
		[Parameter(ParameterSetName = 'SearchSoftware')]
		[switch]$OnlyApps
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
			Type = "software";
			Term = $Term
		}
		
		$WhereArray = @()
		$WhereArray += '[string]::IsNullOrEmpty($_.ID) -eq $false'
		if ($OnlySoftware) {
			$WhereArray += '$_.Type -eq [bConnectSearchResultType]::Application'
		}
		if ($OnlyApps) {
			$WhereArray += '$_.Type -eq [bConnectSearchResultType]::App'
		}
		$WhereString = $WhereArray -Join " -and "
		$WhereBlock = [scriptblock]::Create($WhereString)
			
		$Result = Invoke-bConnectGet -Controller "Search" -Data $_body | Where-Object -FilterScript $WhereBlock | Select-Object  @{ Name = "ApplicationGuid"; Expression = { $_.ID } }, ID, Name, AdditionalInfo, @{ Name = "Type"; Expression = { [bConnectSearchResultType]$_.Type } }
		$Result
	}
}