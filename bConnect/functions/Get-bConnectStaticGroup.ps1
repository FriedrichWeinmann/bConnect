function Get-bConnectStaticGroup
{
<#
	.SYNOPSIS
		Get specified Static Group.
	
	.DESCRIPTION
		Get specified Static Group.
	
	.PARAMETER StaticGroup
		Name (wildcards supported) or GUID of the Static Group.
	
	.PARAMETER OrgUnitGuid
		Valid GUID of a OrgUnit with Static Groups
	
	.OUTPUTS
		bConnect.StaticGroup
#>
	[CmdletBinding(DefaultParameterSetName = 'GroupName')]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'GroupName')]
		[Alias('StaticGroupGuid')]
		[string]
		$StaticGroup,
		
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'OrgName')]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$OrgUnitGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		#region Search by Group
		if ($StaticGroup)
		{
			If (Test-Guid $StaticGroup)
			{
				Invoke-bConnectGet -Controller "StaticGroups" -Data @{ Id = $StaticGroup } |
				Select-PSFObject "ID as StaticGroupGuid", * |
				Add-ObjectDetail -TypeName 'bConnect.StaticGroup' -WithID
			}
			else
			{
				# fetching static groups with name is not supported; therefore we need a workaround for getting the specified static group...
				if ((Get-bConnectVersion -bMSVersion).Major -ge 16)
				{
					# Search available since bMS 2016R1
					Foreach ($group in (Search-bConnectStaticGroup -Term $StaticGroup))
					{
						Get-bConnectStaticGroup -StaticGroup $group.StaticGroupGuid
					}
				}
				else
				{
					Invoke-bConnectGet -Controller "StaticGroups" |
					Where-Object Name -Match $StaticGroup |
					Select-PSFObject "ID as StaticGroupGuid", * |
					Add-ObjectDetail -TypeName 'bConnect.StaticGroup' -WithID
				}
			}
		}
		#endregion Search by Group
		
		#region Search by organization
		elseif ($OrgUnitGuid)
		{
			Invoke-bConnectGet -Controller "StaticGroups" -Data @{ OrgUnitGuid = $OrgUnitGuid } |
			Select-PSFObject "ID as StaticGroupGuid", * |
			Add-ObjectDetail -TypeName 'bConnect.StaticGroup' -WithID
		}
		#endregion Search by organization
		
		#region List all
		else
		{
			Invoke-bConnectGet -Controller "StaticGroups" |
			Select-PSFObject "ID as StaticGroupGuid", * |
			Add-ObjectDetail -TypeName 'bConnect.StaticGroup' -WithID
		}
		#endregion List all
	}
}