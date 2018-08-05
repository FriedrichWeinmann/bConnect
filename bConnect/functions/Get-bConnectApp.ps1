Function Get-bConnectApp
{
<#
    .Synopsis
        Get specified app, all apps in given OrgUnit or all apps on an specific endpoint.

	.DESCRIPTION
		Get specified app, all apps in given OrgUnit or all apps on an specific endpoint.

    .PARAMETER AppGuid
        Valid GUID of a app.
	
    .PARAMETER OrgUnitGuid
        Valid GUID of a Orgunit.
	
    .PARAMETER EndpointGuid
        Valid GUID of an endpoint.
	
    .OUTPUTS
        bConnect.App
#>
	
	Param (
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Faild to parse input as guid: {0}')]
		[string]
		$AppGuid,
		
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Faild to parse input as guid: {0}')]
		[string]
		$OrgUnitGuid,
		
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Faild to parse input as guid: {0}')]
		[string]
		$EndpointGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = { }
		if ($EndpointGuid) { $body['EndpointId'] = $EndpointGuid }
		if ($OrgUnitGuid) { $body['OrgUnit'] = $OrgUnitGuid }
		if ($AppGuid) { $body['Id'] = $AppGuid }
		
		Invoke-bConnectGet -Controller "Apps" -Data $body | Select-PSFObject  "ID as AppGuid", * | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'Id')
			{
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.App'
			}
			else
			{
				$_
			}
		}
	}
}