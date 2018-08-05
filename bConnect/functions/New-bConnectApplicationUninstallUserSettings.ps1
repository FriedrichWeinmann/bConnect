Function New-bConnectApplicationUninstallUserSettings
{
<#
	.SYNOPSIS
		Creates a new UninstallUserSettings for Applications.
	
	.DESCRIPTION
		Creates a new UninstallUserSettings for Applications.
	
	.PARAMETER baramundiDeployScript
		Path to the deploy script that needs to be executed during uninstallation
	
	.PARAMETER ValidForInstallUser
		If set, script will also run for the install user
	
	.PARAMETER RunbDSVisible
		If set, bDS will run visible
	
	.PARAMETER CopyScriptToClient
		If set, script will be copied to client
#>
	[CmdletBinding()]
	Param (
		[string]
		$baramundiDeployScript,
		
		[switch]
		$ValidForInstallUser,
		
		[switch]
		$RunbDSVisible,
		
		[switch]
		$CopyScriptToClient
	)
	
	@{
		baramundiDeployScript = $baramundiDeployScript
		ValidForInstallUser   = $ValidForInstallUser
		RunbDSVisible		  = $RunbDSVisible
		CopyScriptToClient    = $CopyScriptToClient
	}
}