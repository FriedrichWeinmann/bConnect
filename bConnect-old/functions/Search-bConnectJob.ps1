Function Search-bConnectJob() {
    <#
        .Synopsis
            Search for specified jobs.
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
			Type = "job";
			Term = $Term
		}
		
		$Result = Invoke-bConnectGet -Controller "Search" -Data $_body | Where-Object { [string]::IsNullOrEmpty($_.ID) -eq $false } | Select-Object  @{ Name = "JobGuid"; Expression = { $_.ID } }, ID, Name, AdditionalInfo, @{ Name = "Type"; Expression = { [bConnectSearchResultType]$_.Type } }
		$Result
	}
}