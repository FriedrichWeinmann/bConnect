function Get-bConnectEndpointOption
{
    <#
	.SYNOPSIS
		Get the Endpoints Options of an Endpoint

	.DESCRIPTION
		Get the Endpoints Options of an Endpoint.
		This operation is only supported against windows endpoints.

	.PARAMETER EndpointGuid
		Guid of the endpoint to retrieve the option for.

	.PARAMETER EnableException
        Replaces user friendly yellow warnings with bloody red exceptions of doom!
        Use this if you want the function to throw terminating errors you want to catch.

	.OUTPUTS
		bConnect.EndpointOptions
#>
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        [Alias('EndpointIds')]
        [string[]]
        $EndpointGuid,

        [switch]
        $EnableException
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
            if ($endpoint.Type -ne 1)
            {
                Stop-PSFFunction -Message "Only windows endpoints supported! $([bConnectEndpointType]$endpoint.Type) was detected instead!" -Continue -EnableException $EnableException.ToBool() -Target $endpoint
            }
            if ($endpoint.Options -lt [int32]::MaxValue)
            {

                [EndpointOptions]$Options = $endpoint.Options

                $UserJobOptions = [bConnectEndpointUserJobOptions].GetEnumValues() | Where-Object { $($options.ToString() -Split ", ") -contains $_ }; ;
                If ([String]::IsNullOrEmpty($UserJobOptions))
                {
                    $UserJobOptions = "AlwaysExecuteUserJobs"
                }

                $PrimaryUserUpdateOption = [bConnectEndpointPrimaryUserUpdateOption].GetEnumValues() | Where-Object { $($options.ToString() -Split ", ") -contains $_ };
                If ([String]::IsNullOrEmpty($PrimaryUserUpdateOption))
                {
                    $PrimaryUserUpdateOption = "UpdatePrimaryUserOnNextLogon"
                }

                [PSCustomObject]@{
                    'PSTypeName'              = 'bConnect.EndpointOptions'
                    'EndpointGuid'            = $endpoint.EndpointGuid;
                    'GuidOrgUnit'             = $endpoint.GuidGroup;
                    'DisplayName'             = $endpoint.DisplayName;
                    'AllowOSInstall'          = $Options.HasFlag([EndpointOptions]::AllowOSInstall);
                    'AllowAutoInstall'        = $Options.HasFlag([EndpointOptions]::AllowAutoInstall);
                    'PrimaryUserUpdateOption' = $PrimaryUserUpdateOption;
                    'UserJobOptions'          = $UserJobOptions;
                    'AutomaticUsageTracking'  = $Options.HasFlag([EndpointOptions]::AutomaticUsageTracking);
                    'EnergyManagement'        = $Options.HasFlag([EndpointOptions]::EnergyManagement);
                }
            }
            else
            {
                Stop-PSFFunction -Message "Client has been deactivated!" -EnableException $EnableException.ToBool() -Target $endpoint -Continue
            }
        }

    }
}