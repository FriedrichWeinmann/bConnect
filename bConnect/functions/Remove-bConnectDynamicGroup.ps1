function Remove-bConnectDynamicGroup
{
<#
	.SYNOPSIS
		Remove specified DynamicGroup.
	
	.DESCRIPTION
		Remove specified DynamicGroup.
	
	.PARAMETER DynamicGroupGuid
		Valid GUID of a DynamicGroup.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$DynamicGroupGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Id = $DynamicGroupGuid
		}
		
		if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $DynamicGroupGuid -Action 'Remove dynamic group')
		{
			Invoke-bConnectDelete -Controller "DynamicGroups" -Data $body
		}
	}
}