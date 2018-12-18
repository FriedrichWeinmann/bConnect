Import-Module .\bConnect\bConnect.psd1 -Force
Initialize-bConnect -Server b1shba-bmd -Credentials "s2041@b1shba.intern" -AcceptSelfSignedCertificate
Get-bConnectEndpoint -OrgUnitGuid 50846361-52DB-4ACA-958D-A93DB8A72FD2