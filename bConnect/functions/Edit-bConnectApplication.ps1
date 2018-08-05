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
	
	BEGIN
	{
		Assert-bConnectConnection
	}
	
	PROCESS
	{
		If (Test-Guid $Application.ApplicationGuid)
		{
			If ($Application.AUT.Count -gt 0)
			{
				$Application.EnableAUT = $true
			}
			
			$_Application = ConvertTo-Hashtable $Application
			if ($pscmdlet.ShouldProcess($_Application.Id, "Edit Application"))
			{
				$Result = Invoke-bConnectPatch -Controller "Applications" -objectGuid $_Application.ApplicationGuid -Data $_Application | Select-Object  @{ Name = "ApplicationGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ApplicationGuid')
					{
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Application'
					}
					else
					{
						$_
					}
				}
			}
			else
			{
				Write-Verbose -Message "Edit Application"
				foreach ($k in $_Application.Keys) { Write-Verbose -Message "$k : $($_Application[$k])" }
			}
		}
	}
}