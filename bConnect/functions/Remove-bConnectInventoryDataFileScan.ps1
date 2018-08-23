function Remove-bConnectInventoryDataFileScan
{
<#
	.SYNOPSIS
		Remove all file scans from specified endpoint.
	
	.DESCRIPTION
		Remove all file scans from specified endpoint.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$EndpointGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			EndpointId = $EndpointGuid;
		}
		
		if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $EndpointGuid -Action 'Remove InventoryDataFileScan')
		{
			Invoke-bConnectDelete -Controller "InventoryDataFileScans" -Data $body
		}
	}
}