<#
	.Synopsis
		Search for specified endpoints in BMS.
	
	.DESCRIPTION
		Search for specified endpoints in BMS.
	
	.PARAMETER Term
		Searchterm for the search. Wildcards allowed.
	
	.PARAMETER Type
		Defines the Type of Endpoint returned
	
	.PARAMETER OnlyActiveClients
		Filter the Result to get only Active Clients
	
	.PARAMETER Filter
		Filter the Result via Query. You can pass a Filterblock like
		{$_.Hostname -like 'MyPC'} and will get a exact result.
		It's slower than searching with Term, but you've more flexibility. Because you can filter every endpoint property.
	
	.EXAMPLE
		PS C:\> Search-bConnectEndpoint -Term 'PC1'
		Searches for a Client with the Name PC1
	
	.EXAMPLE
		PS C:\> Search-bConnectEndpoint -Type WindowsEndpoint -OnlyActiveClients
		Searches for all active Windows Clients

	.EXAMPLE
		PS C:\> Search-bConnectEndpoint -Filter '$_.Hostname -like "MyPC"'
		Searches for a Client with the Hostname MyPC

	.EXAMPLE
		PS C:\> Search-bConnectEndpoint -Filter {$_.Hostname -like "Server*"}
		Searches for Clients starting with Hostname Server

	.EXAMPLE
		PS C:\> Search-bConnectEndpoint -Filter '$_.OperatingSystem -like "Windows Server*"' | New-bConnectStaticGroup -Name "Windows Server Clients" -Comment "A Group Full of Windows Server Clients"
		Searches for Clients with Windows Server Operating System and Adds them to a new StaticGroup

	.EXAMPLE
		PS C:\> $Name = "Server*"
		PS C:\> Search-bConnectEndpoint -Filter '$_.Hostname -like $Name'
		You can do the same when the value is passed as a variable
	
	.Outputs
		Array of SearchResult (see bConnect documentation for more details)
	
	.NOTES
		Additional information about the function.
#>
function Search-bConnectEndpoint
{
	param
	(
		[Parameter(ParameterSetName = 'Search', Mandatory = $true, Position = 1)]
		[string]
		$Term,
		
		[Parameter(Position = 2)]
		[bConnectEndpointType]
		$Type,
		
		[Parameter(ParameterSetName = 'Search', Position = 3)]
		[switch]
		$OnlyActiveClients,
		
		[Parameter(ParameterSetName = 'Filter', Mandatory = $true, Position = 4)]
		[String]
		$Filter
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		
		$WhereArray = @()
		$WhereArray += '[string]::IsNullOrEmpty($_.ID) -eq $false'
		if ($Type)
		{
			$WhereArray += '$_.Type -eq $Type'
		}
		if ($OnlyActiveClients -and $PSCmdlet.ParameterSetName -eq "Search")
		{
			$WhereArray += '$_.Deactivated -eq $false'
		}
		if ($Filter)
		{
			$WhereArray += $Filter
		}
		$WhereString = $WhereArray -Join " -and "
		try
		{
			$WhereBlock = [scriptblock]::Create($WhereString)
		}
		catch
		{
			$ErrorObject = New-Object System.Exception "Error with the Filter $($Filter.ToString()) . Please Check Syntax. $_"
			throw $ErrorObject
		}
		
		
		switch ($PSCmdlet.ParameterSetName)
		{
			"Search" {
				$_body = @{
					Type = "endpoint";
					Term = $Term
				}
				
				$Result = Invoke-bConnectGet -Controller "Search" -Data $_body | Where-Object -FilterScript $WhereBlock | Select-PSFObject "ID as EndpointGuid", ID, Name, AdditionalInfo, "Type to bConnectSearchResultType", Deactivated
			}
			"Filter" {
				try
				{
					$Result = Get-bConnectEndpoint | Where-Object -FilterScript $WhereBlock -ErrorAction Stop | Select-PSFObject  EndpointGuid, ID, "DisplayName as Name", "Comments as AdditionalInfo", "Type to bConnectSearchResultType", Deactivated
				}
				catch
				{
					$ErrorObject = New-Object System.Exception "Error with the Filter $($Filter.ToString()) . Please Check Syntax. $_"
					throw $ErrorObject
				}
				
			}
		}
		$Result
	}
}