function Edit-bConnectApplication
{
<#
	.SYNOPSIS
		Create a new application.
	
	.DESCRIPTION
		A detailed description of the Edit-bConnectApplication function.
	
	.PARAMETER Application
		Application object (hashtable).
	
	.Outputs
		NewEndpoint (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
	[CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		$Application
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	
	process
	{
		If (Test-Guid $Application.ApplicationGuid)
		{
			If ($Application.AUT.Count -gt 0)
			{
				$Application.EnableAUT = $true
			}
			
			$applicationItem = ConvertTo-Hashtable $Application
			
			if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $applicationItem.Id -Action 'Edit Application')
			{
				Invoke-bConnectPatch -Controller "Applications" -objectGuid $applicationItem.ApplicationGuid -Data $applicationItem |
				Select-PSFObject 'ID as ApplicationGuid', * |
				Add-ObjectDetail -TypeName 'bConnect.Application' -WithID
			}
			else
			{
				Write-PSFMessage -Level Verbose -Message "Edit Application"
				foreach ($k in $applicationItem.Keys) { Write-PSFMessage -Level SomewhatVerbose -Message "$k : $($applicationItem[$k])" }
			}
		}
	}
}