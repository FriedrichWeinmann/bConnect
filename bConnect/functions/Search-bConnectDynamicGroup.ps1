Function Search-bConnectDynamicGroup() {
    <#
        .Synopsis
            Search for specified static group.
        .Parameter Term
            Searchterm for the search. Wildcards allowed.
        .Outputs
            Array of SearchResult (see bConnect documentation for more details)
    #>
	
	Param (
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
		
		$Result = Invoke-bConnectGet -Controller "Search" -Data $_body | Where-Object { $_.Type -eq [bConnectSearchResultType]::DynamicGroup } | Select-Object  @{ Name = "DynamicGroupGuid"; Expression = { $_.ID } }, ID, Name, AdditionalInfo, @{ Name = "Type"; Expression = { [bConnectSearchResultType]$_.Type } }
		$Result
	}
}