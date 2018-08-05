Function New-bConnectApplicationInstallUserSettings
{
<#
	.SYNOPSIS
		Creates a new InstallUserSettings for Applications.
	
	.DESCRIPTION
		Creates a new InstallUserSettings for Applications.
	
	.PARAMETER baramundiDeployScript
		Path to the deploy script that needs to be executed during installation
	
	.PARAMETER ValidForInstallUser
		If set, script will also run for the install user
	
	.PARAMETER RunbDSVisible
		If set, bDS will run visible
	
	.PARAMETER CopyScriptToClient
		If set, script will be copied to client
	
	.PARAMETER ExecuteAtEveryLogin
		If set, script will run on every login
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
		$CopyScriptToClient,
		
		[switch]
		$ExecuteAtEveryLogin
	)
	
	@{
		baramundiDeployScript = $baramundiDeployScript
		ValidForInstallUser   = $ValidForInstallUser
		RunbDSVisible		  = $RunbDSVisible
		CopyScriptToClient    = $CopyScriptToClient
		ExecuteAtEveryLogin   = $ExecuteAtEveryLogin
	}
}