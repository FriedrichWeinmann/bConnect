function Remove-bConnectJobInstance
{
<#
	.SYNOPSIS
		Remove specified jobinstance.
	
	.DESCRIPTION
		Remove specified jobinstance.
	
	.PARAMETER JobInstanceGuid
		Valid GUID of a jobinstance.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$JobInstanceGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Id = $JobInstanceGuid;
		}
		
		if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $JobInstanceGuid -Action 'Remove JobInstance')
		{
			Invoke-bConnectDelete -Controller "JobInstances" -Data $body
		}
	}
}