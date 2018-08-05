Function New-bConnectApplicationUninstallOptions
{
<#
	.SYNOPSIS
		Creates a new UninstallApplicationOption for Applications.
		Empty or filled with given information.
	
	.DESCRIPTION
		Creates a new UninstallApplicationOption for Applications.
		Empty or filled with given information.
	
	.PARAMETER RebootBehaviour
		Reboot behaviour after installation
	
	.PARAMETER RemoveUnknownSoftware
		If set, removal of not installed software will be started
	
	.PARAMETER UseBbt
		If set, bBT is supported
	
	.PARAMETER VisibleExecution
		Shows in which cases the execution of this software is visible
	
	.PARAMETER CopyLocally
		If set, installation files should be copied to local filesystem
	
	.PARAMETER DisableInputDevices
		If set, no input devices will be available during installation
#>
	[CmdletBinding()]
	Param (
		[ValidateSet("NoReboot", "Reboot", "AppReboot", "DeferrableReboot")]
		[string]
		$RebootBehaviour = "NoReboot",
		
		[switch]
		$RemoveUnknownSoftware,
		
		[switch]
		$UsebBT,
		
		[ValidateSet("Silent", "NeedsDesktop", "VisibleWhenUserLoggedOn")]
		[string]
		$VisibleExecution = "Silent",
		
		[switch]
		$CopyLocally,
		
		[switch]
		$DisableInputDevices
	)
	
	@{
		RebootBehaviour	      = $RebootBehaviour
		RemoveUnknownSoftware = $RemoveUnknownSoftware
		UsebBT			      = $UsebBT
		VisibleExecution	  = $VisibleExecution
		CopyLocally		      = $CopyLocally
		DisableInputDevices   = $DisableInputDevices
	}
}