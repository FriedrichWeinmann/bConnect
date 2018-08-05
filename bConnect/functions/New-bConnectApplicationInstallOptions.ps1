Function New-bConnectApplicationInstallOptions()
{
<#
	.SYNOPSIS
		Creates a new InstallApplicationOption for Applications.
		Empty or filled with given information.
	
	.DESCRIPTION
		Creates a new InstallApplicationOption for Applications.
		Empty or filled with given information.
	
	.PARAMETER RebootBehaviour
		Reboot behaviour after installation
	
	.PARAMETER AllowReinstall
		If set, reinstallation is allowed
	
	.PARAMETER UseBbt
		If set, bBT is supported
	
	.PARAMETER VisibleExecution
		Shows in which cases the execution of this software is visible
	
	.PARAMETER CopyLocally
		If set, installation files should be copied to local filesystem
	
	.PARAMETER DisableInputDevices
		If set, no input devices will be available during installation
	
	.PARAMETER DontSetAsInstalled
		If set, this application shouldn't be shown as installed, after installation
	
	.PARAMETER Target
		Target path variable
#>
	[CmdletBinding()]
	Param (
		[ValidateSet("NoReboot", "Reboot", "AppReboot", "DeferrableReboot")]
		[string]
		$RebootBehaviour = "NoReboot",
		
		[switch]
		$AllowReinstall = $true,
		
		[switch]
		$UsebBT,
		
		[ValidateSet("Silent", "NeedsDesktop", "VisibleWhenUserLoggedOn")]
		[string]
		$VisibleExecution = "Silent",
		
		[switch]
		$CopyLocally,
		
		[switch]
		$DisableInputDevices,
		
		[switch]
		$DontSetAsInstalled,
		
		[string]
		$Target
	)
	
	@{
		RebootBehaviour	    = $RebootBehaviour
		AllowReinstall	    = $AllowReinstall
		UsebBT			    = $UsebBT
		VisibleExecution    = $VisibleExecution
		CopyLocally		    = $CopyLocally
		DisableInputDevices = $DisableInputDevices
		DontSetAsInstalled  = $DontSetAsInstalled
		MapShare		    = $false
		Target			    = $Target
	}
}
