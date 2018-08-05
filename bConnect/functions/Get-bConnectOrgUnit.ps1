Function Get-bConnectOrgUnit
{
<#
    .SYNOPSIS
        Get specified OrgUnit.
	
	.DESCRIPTION
		Get specified OrgUnit.
	
    .PARAMETER OrgUnit
        Name (wildcards supported) or GUID of the OrgUnit.
	
    .PARAMETER SubGroups
        List subgroups of given OrgUnit.
        Only used if parameter "name" is a valid GUID.
	
    .OUTPUTS
        bConnect.OrgUnit
#>
	[CmdletBinding()]
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[string]
		$OrgUnit,
		
		[switch]
		$SubGroups
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		#region Guid was offered
		if (Test-Guid $OrgUnit)
		{
			$body = @{ }
			if ($SubGroups) { $body['OrgUnit'] = $OrgUnit }
			else { $body['Id'] = $OrgUnit }
			
			Invoke-bConnectGet -Controller "OrgUnits" -Data $body |
			Select-PSFObject  "ID as OrgUnitGuid", * |
			Add-ObjectDetail -TypeName 'bConnect.OrgUnit' -WithID
		}
		#endregion Guid was offered
		
		#region Search for it
		else
		{
			# fetching orgunits with name is not supported; therefore we need a workaround for getting the specified orgunit...
			If ((Get-bConnectVersion -bMSVersion).Major -ge 16)
			{
				# Search available since bMS 2016R1
				Search-bConnectOrgUnit -Term $OrgUnit |
				Select-PSFObject "ID as OrgUnitGuid", * |
				Add-ObjectDetail -TypeName 'bConnect.OrgUnit' -WithID
			}
			else
			{
				Invoke-bConnectGet -Controller "OrgUnits" |
				Where-Object Name -Match $OrgUnit |
				Select-PSFObject "ID as OrgUnitGuid", * |
				Add-ObjectDetail -TypeName 'bConnect.OrgUnit' -WithID
			}
		}
		#endregion Search for it
	}
}