function New-bConnectOrgUnitExtension
{
<#
	.Synopsis
		Creates a new Extension for OrgUnits.
		Empty or filled with given information.
	
	.DESCRIPTION
		Creates a new Extension for OrgUnits.
		Empty or filled with given information.
	
	.Parameter DIP
		Valid DIP or list of DIPs (separated by ";").
	
	.Parameter Domain
		Valid Windows Domain Name.
	
	.Parameter LocalAdminPassword
		Local admin password for OU (set during OS-Install)
		Must be encrypted with baramundi Cryptor
	
	.Parameter AutoInstallJobs
		Array of valid Job-GUIDs
	
	.Parameter HardwareProfiles
		Array of valid HardwareProfile-GUIDs
	
	.Parameter InheritAutoInstallJobs
		Array of valid inherited Job-GUIDs
	
	.Parameter RequestableJobs
		Array of valid Job-GUIDs
#>
	[CmdletBinding()]
	param (
		[string]
		$DIP = "",
		
		[string]
		$Domain = "",
		
		[string]
		$LocalAdminPassword = "",
		
		[switch]
		$EnableDHCP = $true,
		
		[string]
		$SubnetMask = "",
		
		[string]
		$DefaultGateway = "",
		
		[string]
		$DnsServer = "",
		
		[string]
		$DnsServer2 = "",
		
		[string]
		$DnsDomain = "",
		
		[string]
		$WinsServer = "",
		
		[string]
		$WinsServer2 = "",
		
		[string[]]
		$AutoInstallJobs = @(),
		
		[string[]]
		$HardwareProfiles = @(),
		
		[switch]
		$InheritAutoInstallJobs = $true,
		
		[string[]]
		$RequestableJobs = @()
	)
	
	$_autoInstallJobs = @()
	foreach ($aiJob in $AutoInstallJobs)
	{
		if (Test-Guid -Guid $aiJob)
		{
			$_autoInstallJobs += $aiJob
		}
		else
		{
			$_autoInstallJobs += (Search-bConnectJob -Term $aiJob).Id
		}
	}
	
	$_requestableJobs = @()
	foreach ($rJob in $RequestableJobs)
	{
		if (Test-Guid -Guid $rJob)
		{
			$_requestableJobs += $rJob
		}
		else
		{
			$_requestableJobs += (Search-bConnectJob -Term $rJob).Id
		}
	}
	
	@{
		DIP				       = $DIP
		Domain				   = $Domain
		LocalAdminPassword	   = $LocalAdminPassword
		EnableDHCP			   = $EnableDHCP.ToBool()
		SubnetMask			   = $SubnetMask
		DefaultGateway		   = $DefaultGateway
		DnsServer			   = $DnsServer
		DnsServer2			   = $DnsServer2
		DnsDomain			   = $DnsDomain
		WinsServer			   = $WinsServer
		WinsServer2		       = $WinsServer2
		AutoInstallJobs	       = $_autoInstallJobs
		HardwareProfiles	   = $HardwareProfiles
		InheritAutoInstallJobs = $InheritAutoInstallJobs.ToBool()
		RequestableJobs	       = $_requestableJobs
	}
}