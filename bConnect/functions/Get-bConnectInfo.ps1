function Get-bConnectInfo
{
<#
	.SYNOPSIS
		Gets service information from bConnect.
	
	.DESCRIPTION
		Gets service information from bConnect.
#>
	[CmdletBinding()]
	param ()
	
	If (-not $script:_bConnectInfo) {
        $script:_bConnectInfo = Invoke-bConnectGet -Controller "info" -NoVersion
	}
	
	$script:_bConnectInfo
}