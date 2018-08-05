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
				
				if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $endpointItem.Id -Action 'Edit Endpoint')
				{
					Invoke-bConnectPatch -Controller "Endpoints" -objectGuid $endpointItem.Id -Data $newEndpoint |
					Select-PSFObject 'ID as EndpointGuid', * |
					Add-ObjectDetail -TypeName 'bConnect.Endpoint' -WithID
				}
				else
				{
					Write-PSFMessage -Level Verbose -Message "Edit Endpoint"
					foreach ($k in $newEndpoint.Keys) { Write-PSFMessage -Level SomewhatVerbose -Message "$k : $($newEndpoint[$k])" }
				}
			}
		}
	}
}
