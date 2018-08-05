Function Get-bConnectSoftwareScanRule
{
<#
	.SYNOPSIS
		Get all software scan rules.
	
	.DESCRIPTION
		Get all software scan rules.
#>
	[CmdletBinding()]
	param ()
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		Invoke-bConnectGet -Controller "SoftwareScanRules"
	}
}