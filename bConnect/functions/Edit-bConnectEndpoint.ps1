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
				$oldEndpoint = Get-bConnectEndpoint -EndpointGuid $endpointItem.Id
				$oldEndpoint = ConvertTo-Hashtable $oldEndpoint
				
				# common properties
				$newEndpoint = @{ Id = $endpointItem.Id }
				$propertyList = @(
					"DisplayName",
					"GuidOrgUnit"
				)
				$endpointItem = ConvertTo-Hashtable $endpointItem
				
				# Windows
				if ($endpointItem.Type -eq [bConnectEndpointType]::WindowsEndpoint)
				{
					$propertyList += @(
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
					$propertyList += @(
						"PrimaryUser",
						"Owner",
						"ComplianceCheckCategory"
					)
				}
				
				# OSX
				if ($endpointItem.Type -eq [bConnectEndpointType]::MacEndpoint)
				{
					$propertyList += @(
						"HostName"
					)
				}
				
				foreach ($_property in $propertyList)
				{
					if ($endpointItem[$_property] -ine $oldEndpoint[$_property])
					{
						$newEndpoint += @{ $_property = $endpointItem[$_property] }
					}
				}
				
				if ($pscmdlet.ShouldProcess($endpointItem.Id, "Edit Endpoint"))
				{
					$Result = Invoke-bConnectPatch -Controller "Endpoints" -objectGuid $endpointItem.Id -Data $newEndpoint | Select-Object  @{ Name = "EndpointGuid"; Expression = { $_.ID } }, *
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
					foreach ($k in $newEndpoint.Keys) { Write-Verbose -Message "$k : $($newEndpoint[$k])" }
				}
			}
		}
	}
}
