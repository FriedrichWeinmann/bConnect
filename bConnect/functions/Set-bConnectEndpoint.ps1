Function Set-bConnectEndpoint
{
    <#
     .SYNOPSIS
         Updates an existing endpoint.

     .DESCRIPTION
         With Set-bConnectEndpoint you can modify an Endpoint directly without the need of an existing Object.
         You can just pass an Endpoint Guid and then modify the endpoint with the individual parameters

     .Parameter EndpointGuid
         Valid GUID of a endpoint

     .PARAMETER DisplayName
         The new Displayname of the Endpoint

     .PARAMETER GuidOrgUnit
         The new parent GuidOrgUnit of the Endpoint

     .PARAMETER HostName
         The new HostName of the Endpoint. Windows and MAC Endpoint only.

     .PARAMETER PrimaryMAC
         The new PrimaryMAC of the Endpoint. Windows Endpoint only,

     .PARAMETER Domain
         The new Domain of the Endpoint. Windows Endpoint only,

     .PARAMETER GuidBootEnvironment
         The new GuidBootEnvironment of the Endpoint. Windows Endpoint only,

     .PARAMETER PublicKey
         The new PublicKey of the Endpoint. Windows Endpoint only,

     .PARAMETER Comments
         The new Comment of the Endpoint. Windows Endpoint only,

     .PARAMETER PrimaryUser
         The new PrimaryUser of the Endpoint. Is currently only Working for Mobile and MAC Endpoints.

     .PARAMETER Owner
         The new Owner of the Device. Is currently only Working for Mobile and MAC Endpoints

     .PARAMETER ComplianceCheckCategory
         The new ComplianceCheckCategory of the Device. Is currently only Working for Mobile and MAC Endpoints

     .OUTPUTS
         Endpoint

     .NOTES
         Additional information about the function.
 #>
    [CmdletBinding(DefaultParameterSetName = 'WindowsEndpoint',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Test-PSFShouldProcess is used instead of ShouldProcess.")]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        $EndpointGuid,
        $DisplayName,
        $GuidOrgUnit,
        [Parameter(ParameterSetName = 'MacEndpoint')]
        [Parameter(ParameterSetName = 'WindowsEndpoint')]
        $HostName,
        [Parameter(ParameterSetName = 'WindowsEndpoint')]
        $PrimaryMAC,
        [Parameter(ParameterSetName = 'WindowsEndpoint')]
        $Domain,
        [Parameter(ParameterSetName = 'WindowsEndpoint')]
        $GuidBootEnvironment,
        [Parameter(ParameterSetName = 'WindowsEndpoint')]
        $PublicKey,
        [Parameter(ParameterSetName = 'WindowsEndpoint')]
        $Comments,
        $PrimaryUser,
        [Parameter(ParameterSetName = 'MobileEndpoint')]
        [Parameter(ParameterSetName = 'MacEndpoint')]
        $Owner,
        [Parameter(ParameterSetName = 'MobileEndpoint')]
        [Parameter(ParameterSetName = 'MacEndpoint')]
        $ComplianceCheckCategory
    )

    Begin
    {
        Assert-bConnectConnection
    }
    Process
    {
        ForEach ($endpointItem In $EndpointGuid)
        {
            # bms2016r1
            # We can not send the whole object because of not editable fields.
            # So we need to create a new one with editable fields only...
            # And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
            # Dirty workaround: reload the object and compare new vs. old
            $oldEndpoint = Get-bConnectEndpoint -EndpointGuid $EndpointGuid
            $oldEndpoint = ConvertTo-Hashtable $oldEndpoint

            # common properties
            $newEndpoint = @{ Id = $EndpointGuid }

            ForEach ($_property In $PSBoundParameters.Keys)
            {
                If ($PSBoundParameters[$_property] -ine $oldEndpoint[$_property])
                {
                    $newEndpoint += @{ $_property = $PSBoundParameters[$_property] }
                }
            }

            If (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $newEndpoint.Id -Action 'Edit Endpoint')
            {
                Invoke-bConnectPatch -Controller "Endpoints" -objectGuid $newEndpoint.Id -Data $newEndpoint |
                    Select-PSFObject 'ID as EndpointGuid', * |
                    Add-ObjectDetail -TypeName 'bConnect.Endpoint' -WithID
            }
            Else
            {
                Write-PSFMessage -Level Verbose -Message "Edit Endpoint"
                ForEach ($k In $newEndpoint.Keys) { Write-PSFMessage -Level SomewhatVerbose -Message "$k : $($newEndpoint[$k])" }
            }
        }
    }
}
