Function New-bConnectDynamicGroup
{
<#
	.SYNOPSIS
		Create a new DynamicGroup.
	
	.DESCRIPTION
		A detailed description of the New-bConnectDynamicGroup function.
	
	.PARAMETER Name
		Name of the DynamicGroup.
	
	.PARAMETER ParentGuid
		Valid GUID of the parent OrgUnit in hierarchy (default: "Dynamic Groups").
	
	.PARAMETER Statement
		Valid SQL Statement ("SELECT * FROM machine " will be automatically added).
	
	.PARAMETER Comment
		Comment for the DynamicGroup.
#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name,
		
		[string]
		$ParentGuid = "BDE918DC-89C0-458A-92F7-0BB9147A2706",
		
		[Parameter(Mandatory = $true)]
		[PsfValidatePattern('WHERE', ErrorMessage = 'Must contain a SQL Statement with a WHERE condition in it: {0}')]
		[string]
		$Statement,
		
		[string]
		$Comment
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Name	 = $Name
			ParentId = $ParentGuid
		}
		if ($Statement) { $body['Statement'] = $Statement }
		if ($Comment) { $body['Comment'] = $Comment }
		
		Invoke-bConnectPost -Controller "DynamicGroups" -Data $body
	}
}