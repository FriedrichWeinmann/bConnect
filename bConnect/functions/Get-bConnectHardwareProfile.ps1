Function Get-bConnectHardwareProfile
{
<#
    .SYNOPSIS
        Get specified HardwareProfile or a list of all hardware profiles

	.DESCRIPTION
		Get specified HardwareProfile or a list of all hardware profiles

    .PARAMETER HardwareProfileGuid
        Valid GUID of a hardware profile
#>
	[CmdletBinding()]
	Param (
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$HardwareProfileGuid
	)
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{ }
		if ($HardwareProfileGuid) { $body['Id'] = $HardwareProfileGuid }
		
		return Invoke-bConnectGet -Controller "HardwareProfiles" -Data $body
	}
}