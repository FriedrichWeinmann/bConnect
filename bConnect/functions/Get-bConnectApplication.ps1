Function Get-bConnectApplication
{
<#
	.SYNOPSIS
		Get specified application, all applications in given OrgUnit or all applications on an specific endpoint.
	
	.DESCRIPTION
		Get specified application, all applications in given OrgUnit or all applications on an specific endpoint.
	
	.PARAMETER ApplicationGuid
		Valid GUID of a application.
	
	.PARAMETER OrgUnitGuid
		Valid GUID of a Orgunit.
	
	.PARAMETER EndpointGuid
		Valid GUID of an endpoint.
	
	.OUTPUTS
		bConnect.Application
#>
	
	Param (
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Faild to parse input as guid: {0}')]
		[string]
		$ApplicationGuid,
		
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
		if ($ApplicationGuid) { $body['Id'] = $ApplicationGuid }
		
		Invoke-bConnectGet -Controller "Applications" -Data $body | Select-PSFObject  "ID as ApplicationGuid", * | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'Id')
			{
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Application'
			}
			else
			{
				$_
			}
		}
	}
}