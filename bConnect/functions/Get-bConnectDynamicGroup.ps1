function Get-bConnectDynamicGroup
{
<#
	.SYNOPSIS
		Get specified Dynamic Group.
	
	.DESCRIPTION
		Get specified Dynamic Group.
	
	.PARAMETER DynamicGroup
		Name (wildcards supported) or GUID of the Dynamic Group.
	
	.PARAMETER OrgUnit
		Valid GUID of a OrgUnit with Dynamic Groups
	
	.OUTPUTS
		'bConnect.DynamicGroup'
#>
	[CmdletBinding(DefaultParameterSetName = 'Groupname')]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, ParameterSetName = 'Groupname')]
		[SupportsWildcards()]
		[string]
		$DynamicGroup,
		
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[Parameter(Position = 0, ParameterSetName = 'OrgName')]
		[string]
		$OrgUnit
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		#region Scan by DynamicGroup parameter
		if ($DynamicGroup)
		{
			if (Test-Guid $DynamicGroup)
			{
				Invoke-bConnectGet -Controller "DynamicGroups" -Data @{ Id = $DynamicGroup } |
				Select-PSFObject "ID as DynamicGroupGuid", * |
				Add-ObjectDetail -TypeName 'bConnect.DynamicGroup' -WithID
			}
			else
			{
				# fetching dynamic groups with name is not supported; therefore we need a workaround for getting the specified dyn group...
				if ((Get-bConnectVersion -bMSVersion).Major -ge 16)
				{
					# Search available since bMS 2016R1
					Foreach ($group in (Search-bConnectDynamicGroup -Term $DynamicGroup))
					{
						Get-bConnectDynamicGroup -DynamicGroup $group.DynamicGroupGuid
					}
				}
				else
				{
					Stop-PSFFunction -Message "Filtering dynamic groups by name is not supported before bMS 2016 R1! Specify a Guid instead" -EnableException $true
				}
			}
		}
		#endregion Scan by DynamicGroup parameter
		
		#region Scan by Org ID
		elseif ($OrgUnit)
		{
			Invoke-bConnectGet -Controller "DynamicGroups" -Data @{ OrgUnit = $OrgUnit } |
			Select-PSFObject "ID as DynamicGroupGuid", * |
			Add-ObjectDetail -TypeName 'bConnect.DynamicGroup' -WithID
		}
		#endregion Scan by Org ID
		
		#region List all
		else
		{
			Invoke-bConnectGet -Controller "DynamicGroups" |
			Select-PSFObject "ID as DynamicGroupGuid", * |
			Add-ObjectDetail -TypeName 'bConnect.DynamicGroup' -WithID
		}
		#endregion List all
	}
}