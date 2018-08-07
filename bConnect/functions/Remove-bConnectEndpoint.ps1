function Remove-bConnectEndpoint
{
<#
	.SYNOPSIS
		Remove specified endpoint.
	
	.DESCRIPTION
		Remove specified endpoint.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint.
	
	.PARAMETER Endpoint
		Valid Endpoint object
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess = $true, DefaultParameterSetName = 'Guid')]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Guid')]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$EndpointGuid,
		
		[Parameter(Mandatory = $true, ParameterSetName = 'Object')]
		[PsfValidateScript({ $null -ne $args[0].Id}, ErrorMessage = 'Input must have an ID property: {0}')]
		[PSCustomObject]
		$Endpoint
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		if ($EndpointGuid)
		{
			$body = @{
				Id = $EndpointGuid
			}
		}
		else
		{
			$body = @{
				Id = $Endpoint.Id
			}
		}
		
		if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $EndpointGuid -Action 'Remove endpoint')
		{
			Invoke-bConnectDelete -Controller "Endpoints" -Data $body
		}
	}
}
