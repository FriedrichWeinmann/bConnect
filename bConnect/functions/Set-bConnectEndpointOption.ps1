function Set-bConnectEndpointOption
{
    <#
	.SYNOPSIS
		Sets the options on an endpoint.

	.DESCRIPTION
		Sets the options on an endpoint.
#>
    [CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('EndpointIds')]
        [string[]]
        $EndpointGuid,

        [switch]
        $AllowOSInstall,

        [switch]
        $InheritAutoInstallation,

        [switch]
        $ActivateUsageTracking,

        [switch]
        $ActivateEnergyManagement,

        [bConnectEndpointprimaryUserUpdateOption]
        $PrimaryUserUpdateOptions,

        [bConnectEndpointUserJobOptions]
        $UserJobOptions
    )

    begin
    {
        Assert-bConnectConnection
    }

    process
    {
        foreach ($endpointGuidItem in $EndpointGuid)
        {
            $endpoint = Get-bConnectEndpoint -EndpointGuid $endpointGuidItem

            if ($endpoint.Type -ne [bConnectEndpointType]::WindowsEndpoint)
            {
                Stop-PSFFunction -Message "Es wurde kein gültiger Windows Endpunkt gefunden" -Continue -Target $endpoint
            }
            if ($endpoint.Options -ge [int32]::MaxValue)
            {
                Stop-PSFFunction -Message "Client ist deaktivert und wird übersprungen: $($endpoint.EndpointGuid)" -Continue -Target $endpoint
            }

            $endpointOption = Get-bConnectEndpointOption -EndpointGuid $endpoint.EndpointGuid

            if (Test-PSFParameterBinding -ParameterName 'AllowOSInstall')
            {
                Write-PSFMessage -Level Verbose -Message "Activating OS Install: $AllowOSInstall" -Target $endpoint
                $endpointOption.AllowOSInstall = $AllowOSInstall.ToBool()
            }
            if (Test-PSFParameterBinding -ParameterName '$InheritAutoInstallation')
            {
                Write-PSFMessage -Level Verbose -Message "Activating AutoInstallation: $AllowAutoInstall" -Target $endpoint
                $endpointOption.AllowAutoInstall = $AllowAutoInstall.ToBool()
            }
            if (Test-PSFParameterBinding -ParameterName 'ActivateUsageTracking')
            {
                Write-PSFMessage -Level Verbose -Message "Activating ActivateUsageTracking: $ActivateUsageTracking" -Target $endpoint
                $endpointOption.ActivateUsageTracking = $ActivateUsageTracking.ToBool()
            }
            if (Test-PSFParameterBinding -ParameterName 'ActivateEnergyManagement')
            {
                Write-PSFMessage -Level Verbose -Message "Activating ActivateEnergyManagement: $ActivateEnergyManagement" -Target $endpoint
                $endpointOption.ActivateEnergyManagement = $ActivateEnergyManagement
            }
            if (Test-PSFParameterBinding -ParameterName 'PrimaryUserUpdateOptions')
            {
                Write-PSFMessage -Level Verbose -Message "Set PrimaryUserUpdateOptions: $PrimaryUserUpdateOptions" -Target $endpoint
                $endpointOption.PrimaryUserUpdateOption = $PrimaryUserUpdateOptions
            }
            if (Test-PSFParameterBinding -ParameterName 'UserJobOptions')
            {
                Write-PSFMessage -Level Verbose -Message "Set UserJobOptions: $UserJobOptions" -Target $endpoint
                $endpointOption.UserJobOptions = $UserJobOptions
            }


            [string]$newOptions = ""

            $newOptions = $($endpointOption.PSObject.Properties | Where-Object { $_.TypeNameOfValue -eq "System.Boolean" -and $_.Value -eq $true }).Name -join ","
            $newOptions = "$newOptions, $($($endpointOption.PSObject.Properties | Where-Object { $_.TypeNameOfValue -eq "bConnect.Endpoints.PrimaryUserUpdateOption" -or $_.TypeNameOfValue -eq "bConnect.Endpoints.UserJobOptions"}).Value -join ",")"
            [EndPointOptions]$newOptions = $newOptions
            [EndPointOptions]$oldOptions = $endpoint.Options

            $endpoint.Options = $newOptions.Value__

            Write-PSFMessage -Level Verbose -Message "Changing options from '$oldOptions' to '$newOptions'" -Target $endpoint
            if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $endpoint.EndpointGuid -Action 'Set Endpoint Option')
            {
                Edit-bConnectEndpoint -Endpoint $endpoint
            }
        }
    }
}