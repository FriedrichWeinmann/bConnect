Function Get-bConnectImages
{
    <#
	.SYNOPSIS
		Get all the Image Object stored in the BMS. Image object are supported on Jobs

	.DESCRIPTION
		Get all the Image Object stored in the BMS. Image object are supported on Jobs

	.PARAMETER ImageID
		Valid GUID of an

	.OUTPUTS
		Array of Images (see bConnect documentation for more details)
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
        [string]
        $IconID,
        $ExportPath
    )
    begin
    {
        Assert-bConnectConnection
    }
    process
    {
        $body = @{ }
        if ($IconID) { $body['Id'] = $IconID }

        Invoke-bConnectGet -Controller "Images" -Data $body | Select-PSFObject  "ID as IconID", * | Add-ObjectDetail -TypeName 'bConnect.Image' -WithID |Tee-Object -Variable "Result"

        If (!([System.String]::IsNullOrEmpty($ExportPath)) -and (Test-Path -path $ExportPath))
        {
            $FileName = "$($Result.IconID).$($Result.MimeType.Split("/")[1])"
            $FilePath = Join-Path -Path $ExportPath -ChildPath $FileName
            $Bytes = [Convert]::FromBase64String($Result.Data)
            Write-Host $FilePath
            [IO.File]::WriteAllBytes($FilePath, $bytes)
        }
    }
}