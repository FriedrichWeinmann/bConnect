function Remove-bConnectOrgUnit
{
<#
	.SYNOPSIS
		Remove specified OrgUnit.
	
	.DESCRIPTION
		Remove specified OrgUnit.
	
	.PARAMETER OrgUnitGuid
		Valid GUID of a OrgUnit.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$OrgUnitGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Id = $OrgUnitGuid;
		}
		
		if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $OrgUnitGuid -Action 'Remove OrgUnit')
		{
			Invoke-bConnectDelete -Controller "OrgUnits" -Data $body
		}
	}
}