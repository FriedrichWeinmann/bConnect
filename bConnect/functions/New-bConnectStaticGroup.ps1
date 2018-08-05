function New-bConnectStaticGroup
{
<#
	.SYNOPSIS
		Create a new StaticGroup.
	
	.DESCRIPTION
		Create a new StaticGroup.
	
	.PARAMETER Name
		Name of the StaticGroup.
	
	.PARAMETER ParentGuid
		Valid GUID of the parent OrgUnit in hierarchy (default: "Static Groups").
	
	.PARAMETER Endpoints
		Array of Endpoints.
	
	.PARAMETER Comment
		Comment for the StaticGroup.
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]
		$Name,
		
		[string]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		$ParentGuid = "5020494B-04D3-4654-A256-80731E953746",
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('EndpointGuid')]
		[string[]]
		$Endpoints,
		
		[string]
		$Comment
	)
	
	begin
	{
		Assert-bConnectConnection
		
		$body = @{
			Name	 = $Name;
			ParentId = $ParentGuid;
		}
		if ($Comment) { $body['Comment'] = $Comment }
		$endpointList = @()
	}
	
	process
	{
		foreach ($endpointItem in $Endpoints)
		{
			$endpointList += $endpointItem
		}
	}
	
	end
	{
		$body['EndPointIds'] = $endpointList
		Invoke-bConnectPost -Controller "StaticGroups" -Data $body
	}
}