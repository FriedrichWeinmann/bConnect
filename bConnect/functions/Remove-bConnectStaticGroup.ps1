function Remove-bConnectStaticGroup
{
<#
	.SYNOPSIS
		Remove specified StaticGroup.
	
	.DESCRIPTION
		Remove specified StaticGroup.
	
	.PARAMETER StaticGroupGuid
		Valid GUID of a StaticGroup.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$StaticGroupGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Id = $StaticGroupGuid;
		}
		
		if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $StaticGroupGuid -Action 'Remove StaticGroup')
		{
			Invoke-bConnectDelete -Controller "StaticGroups" -Data $body
		}
	}
}