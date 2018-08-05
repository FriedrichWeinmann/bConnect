Function New-bConnectApplicationLicense
{
<#
	.SYNOPSIS
		Creates a new ApplicationLicense for Applications.
	
	.DESCRIPTION
		Creates a new ApplicationLicense for Applications.
	
	.PARAMETER LicenseKey
		License key
	
	.PARAMETER Count
		License count
	
	.PARAMETER Offline
		Amount of offline licenses
#>
	
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$LicenseKey,
		
		[int]
		$Count = 0,
		
		[int]
		$Offline = 0
	)
	
	@{
		Count	   = $Count
		LicenseKey = $LicenseKey
		Offline    = $Offline
	}
}