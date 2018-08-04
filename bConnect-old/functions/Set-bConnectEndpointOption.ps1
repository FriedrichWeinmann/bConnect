function Set-bConnectEndpointOption {
	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
			 ValueFromPipelineByPropertyName = $true)]
		[Alias('EndpointIds')]
		[string[]]$EndpointGuid,
		[Parameter(Mandatory = $false)]
		[switch]$AllowOSInstall,
		[Parameter(Mandatory = $false)]
		[switch]$InheritAutoInstallation,
		[Parameter(Mandatory = $false)]
		[switch]$ActivateUsageTracking,
		[Parameter(Mandatory = $false)]
		[switch]$ActivateEnergyManagement,
		[bConnectEndpointprimaryUserUpdateOption]$PrimaryUserUpdateOptions,
		[bConnectEndpointUserJobOptions]$UserJobOptions
	)
	
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
	}
	
	process {
		
		foreach ($_Endpoint in $EndpointGuid) {

			$Endpoint = Get-bConnectEndpoint -EndpointGuid $_Endpoint
			#[EndPointOptions]$OldOptions = $Endpoint.Options
			
			
			If ($Endpoint.Type -eq [bConnectEndpointType]::WindowsEndpoint) {
				If ($Endpoint.Options -lt [int32]::MaxValue) {
					$EndpointOption = Get-bConnectEndpointOption -EndpointGuid $Endpoint.EndpointGuid
					
					if ($PSBoundParameters.ContainsKey('AllowOSInstall')) {
						Write-Verbose "Aktiviere OS Install"
						[bool]$EndpointOption.AllowOSInstall = $AllowOSInstall
					}
					if ($PSBoundParameters.ContainsKey('$InheritAutoInstallation')) {
						Write-Verbose "Aktiviere AutoInstallation"
						[bool]$EndpointOption.AllowAutoInstall = $AllowAutoInstall
					}
					if ($PSBoundParameters.ContainsKey('ActivateUsageTracking')) {
						Write-Verbose "Aktiviere ActivateUsageTracking"
						[bool]$EndpointOption.ActivateUsageTracking = $ActivateUsageTracking
					}
					if ($PSBoundParameters.ContainsKey('ActivateEnergyManagement')) {
						Write-Verbose "Aktiviere ActivateEnergyManagement"
						[bool]$EndpointOption.ActivateEnergyManagement = $ActivateEnergyManagement
					}
					
					# Erzeuge Bitwert
					[string]$NewOptions = ""
					# Durchlaufe alle boolean Werte
					$NewOptions = $($EndpointOption.PSObject.Properties | Where-Object { $_.TypeNameOfValue -eq "System.Boolean" -and $_.Value -eq $true }).Name -join ","
					# Auslesen der Einstellungen für UserJob und UserUpdate
					$NewOptions = "$NewOptions, $($($EndpointOption.PSObject.Properties | Where-Object { $_.TypeNameOfValue -eq "bConnectEndpointPrimaryUserUpdateOption" -or $_.TypeNameOfValue -eq "bConnectEndpointUserJobOptions" }).Value -join ",")"
					# Konvertieren in BitArray
					[EndPointOptions]$NewOptions = $NewOptions
					
					$Endpoint.Options = $NewOptions.Value__;
					
					if ($pscmdlet.ShouldProcess($Endpoint.EndpointGuid, "Set Endpoint Option")) {
						Edit-bConnectEndpoint -Endpoint $Endpoint
					}
					Else {
						Write-Verbose "Old Option Value: $OldOptions"
						Write-Verbose "New Option Value: $NewOptions"
					}
					
				}
				Else {
					Write-Warning -Message "Client ist deaktivert und wird übersprungen: $($Endpoint.EndpointGuid)"
				}
			}
			Else {
				Write-Warning -Message "Es wurde kein gültiger Windows Endpunkt gefunden"
				return $false
			}
		}
	}
}