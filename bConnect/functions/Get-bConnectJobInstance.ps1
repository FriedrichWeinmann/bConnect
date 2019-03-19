function Get-bConnectJobInstance
{
    <#
	.SYNOPSIS
		Get specified jobinstance by GUID, all jobinstances of a job or all jobinstances on a endpoint.

	.DESCRIPTION
		Get specified jobinstance by GUID, all jobinstances of a job or all jobinstances on a endpoint.

	.PARAMETER JobInstanceGuid
		Valid GUID of a jobinstance.

	.PARAMETER JobGuid
        Valid GUID of a job. Accepts Pipeline Input for example from Get-bConnectJob

    .PARAMETER EndpointGuid
        Valid GUID of a endpoint. Accepts Pipeline Input for example from Get-bConnectEndpoint

    .PARAMETER RegisteredUser
        Can only be used in combination with EndpointGuid. Show all Job Instances
        from the specified registered user who where maybe startet via the new Kiosk.

        The job instance will also displayed when the job is available via kiosk to the user
        but was assigned to the endpoint via BMC

        Acceppts only User Principal Names. For example: mike.miller@contoso.org

	.PARAMETER FailedJobsOnly
        Filters the JobInstances to return only failed Job Instances

    .PARAMETER SortFailedBy
        Additional Parameter so customize the Output of the failed Job Instances.
        You can Sort the Output by Endpointname or JobDefinitionName
#>
    [CmdletBinding(DefaultParametersetName = 'None')]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        [string]
        $JobInstanceGuid,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        [string]
        $JobGuid,

        [Parameter(ParameterSetName = 'JobsForUser', ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        [string]
        $EndpointGuid,

        [Parameter(ParameterSetName = 'JobsForUser')]
        [string]
        $RegisteredUser,

        [Parameter(ParameterSetName = 'FailedJobs', Mandatory = $true)]
        [switch]
        $FailedJobsOnly,

        [Parameter(ParameterSetName = 'FailedJobs')]
        [ValidateSet('EndpointName', 'JobDefinitionName')]
        [System.String]$SortFailedBy = "EndpointName"
    )

    begin
    {
        Assert-bConnectConnection
        $FailedJobStates = @(3, 6)
    }
    process
    {
        $body = @{ }
        if ($JobGuid) { $body['JobId'] = $JobGuid }
        if ($EndpointGuid) { $body['EndpointId'] = $EndpointGuid }
        if ($JobInstanceGuid) { $body['Id'] = $JobInstanceGuid }
        if ($RegisteredUser) { $body['User'] += $RegisteredUser }

        $result = Invoke-bConnectGet -Controller "JobInstances" -Data $body

        if ($FailedJobsOnly)
        {
            $result | Where-Object {@("3", "6") -contains $_.BmsNetState} | Sort-Object $SortFailedBy | Add-ObjectDetail -TypeName 'bConnect.JobInstanceFailed' -WithID
        }
        else
        {
            $result
        }
    }
}