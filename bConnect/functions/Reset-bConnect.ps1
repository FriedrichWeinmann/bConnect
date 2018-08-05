function Reset-bConnect
{
<#
	.SYNOPSIS
		Resets bConnect to uninitialized.
	
	.DESCRIPTION
		Disconnects from the existing server, restoring the uninitialized state.
		Generally not needed, except for debugging purposes.
	
	.EXAMPLE
		PS C:\> Reset-bConnect
	
		Disconnects from the existing server, restoring the uninitialized state.
#>
	
	[CmdletBinding()]
	param ()
	
	if ($script:_defaultCertPolicy)
	{
		# Reset certicate validation
		[System.Net.ServicePointManager]::CertificatePolicy = $script:_defaultCertPolicy
	}
	
	$script:_bConnectInfo = $null
	$script:_connectUri = $null
	$script:_connectCredentials = $null
	$script:_connectInitialized = $false
}