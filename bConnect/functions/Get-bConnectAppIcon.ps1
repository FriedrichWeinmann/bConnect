function Get-bConnectAppIcon
{
<#
	.SYNOPSIS
		Get the icon for specified app or all apps within a scope.
	
	.DESCRIPTION
		Get the icon for specified app or all apps within a scope.
	
	.PARAMETER AppGuid
		Valid GUID of a app.
	
	.PARAMETER Scope
		Valid scope (App/Inventory).
	
	.OUTPUTS
		bConnect.AppIcon
#>
	param
	(
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$AppGuid,
		
		[ValidateSet('App', 'Inventory')]
		[string]
		$Scope
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	
	process
	{
		$body = @{ }
		if ($Scope) { $body['Scope'] = $Scope }
		if ($AppGuid) { $body['AppId'] = $AppGuid }
		
		Invoke-bConnectGet -Controller "Icons" -Data $body | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'AppId')
			{
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.AppIcon'
			}
			else
			{
				$_
			}
		}
	}
}