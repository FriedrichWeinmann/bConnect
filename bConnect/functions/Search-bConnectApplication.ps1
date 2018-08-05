function Search-bConnectApplication
{
<#
	.SYNOPSIS
		Search for specified applications and apps.
	
	.DESCRIPTION
		Search for specified applications and apps.
	
	.PARAMETER Term
		Searchterm for the search. Wildcards allowed.
#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]
		$Term,
		
		[Parameter(ParameterSetName = 'SearchApps')]
		[Switch]
		$OnlySoftware,
		
		[Parameter(ParameterSetName = 'SearchSoftware')]
		[switch]
		$OnlyApps
	)
	
	begin
	{
		Assert-bConnectConnection
		
		#region Filter
		$applicationFilter = {
			if (-not $_.ID) { return $false }
			if ($OnlySoftware)
			{
				if (-not ($_.Type -eq [bConnectSearchResultType]::Application))
				{
					return $false
				}
			}
			if ($OnlyApps)
			{
				if (-not ($_.Type -eq [bConnectSearchResultType]::App))
				{
					return $false
				}
			}
			
			$true
		}
		#endregion Filter
	}
	process
	{
		$body = @{
			Type = "software"
			Term = $Term
		}
		
		Invoke-bConnectGet -Controller "Search" -Data $body |
		Where-Object -FilterScript $applicationFilter |
		Select-PSFObject 'ID as ApplicationGuid', ID, Name, AdditionalInfo, 'Type to bConnectSearchResultType'
	}
}