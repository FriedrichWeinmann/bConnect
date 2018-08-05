function New-bConnectOrgUnit
{
<#
	.SYNOPSIS
		Create a new OrgUnit.
	
	.DESCRIPTION
		Create a new OrgUnit.
	
	.PARAMETER Name
		Name of the OrgUnit.
	
	.PARAMETER ParentGuid
		Valid GUID of the parent OrgUnit in hierarchy (default: "Logical Group").
	
	.PARAMETER Comment
		Comment for the OrgUnit.
	
	.PARAMETER Extension
		Hashtable Extension (see bConnect documentation for more details).
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name,
		
		[string]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		$ParentGuid = "C1A25EC3-4207-4538-B372-8D250C5D7908",
		
		[string]
		$Comment,
		
		[PSCustomObject]
		$Extension
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Name	 = $Name;
			ParentId = $ParentGuid;
		}
		
		if ($Comment) { $body['Comment'] = $Comment }
		if ($Extension) { $body['Extension'] = $Extension }
		
		return Invoke-bConnectPost -Controller "OrgUnits" -Data $body
	}
}