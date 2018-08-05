
function Edit-bConnectEndpoint
{
<#
	.SYNOPSIS
		Updates a existing endpoint.
	
	.DESCRIPTION
		A detailed description of the Edit-bConnectEndpoint function.
	
	.PARAMERER Endpoint
		Valid modified endpoint
	
	.OUTPUTS
		Endpoint
#>
	[CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		$Endpoint
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		foreach ($endpointItem in $Endpoint)
		{
			if (Test-Guid $endpointItem.EndpointGuid)
			{
				# bms2016r1
				# We can not send the whole object because of not editable fields.
				# So we need to create a new one with editable fields only...
				# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
				# Dirty workaround: reload the object and compare new vs. old
				$_old_endpoint = Get-bConnectEndpoint -EndpointGuid $endpointItem.Id
				$_old_endpoint = ConvertTo-Hashtable $_old_endpoint
				
				# common properties
				$_new_endpoint = @{ Id = $endpointItem.Id }
				$_propertyList = @(
					"DisplayName",
					"GuidOrgUnit"
				)
				$endpointItem = ConvertTo-Hashtable $endpointItem
				
				# Windows
				if ($endpointItem.Type -eq [bConnectEndpointType]::WindowsEndpoint)
				{
					$_propertyList += @(
						"HostName",
						"Options",
						"PrimaryMAC",
						"Domain",
						"GuidBootEnvironment",
						"GuidHardwareProfile",
						"PublicKey",
						"Comments"
					)
				}
				
				# BmsNet = Android, iOS, WP, OSX
				if (($endpointItem.Type -eq [bConnectEndpointType]::AndroidEndpoint) -or
					($endpointItem.Type -eq [bConnectEndpointType]::iOSEndpoint) -or
					($endpointItem.Type -eq [bConnectEndpointType]::WindowsPhoneEndpoint) -or
					($endpointItem.Type -eq [bConnectEndpointType]::MacEndpoint))
				{
					$_propertyList += @(
						"PrimaryUser",
						"Owner",
						"ComplianceCheckCategory"
					)
				}
				
				# OSX
				if ($endpointItem.Type -eq [bConnectEndpointType]::MacEndpoint)
				{
					$_propertyList += @(
						"HostName"
					)
				}
				
				foreach ($_property in $_propertyList)
				{
					if ($endpointItem[$_property] -ine $_old_endpoint[$_property])
					{
						$_new_endpoint += @{ $_property = $endpointItem[$_property] }
					}
				}
				
				if ($pscmdlet.ShouldProcess($endpointItem.Id, "Edit Endpoint"))
				{
					$Result = Invoke-bConnectPatch -Controller "Endpoints" -objectGuid $endpointItem.Id -Data $_new_endpoint | Select-Object  @{ Name = "EndpointGuid"; Expression = { $_.ID } }, *
					$Result | ForEach-Object {
						if ($_.PSObject.Properties.Name -contains 'ID')
						{
							Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Endpoint'
						}
						else
						{
							$_
						}
					}
				}
				else
				{
					Write-Verbose -Message "Edit Endpoint"
					foreach ($k in $_new_endpoint.Keys) { Write-Verbose -Message "$k : $($_new_endpoint[$k])" }
				}
			}
		}
	}
}
