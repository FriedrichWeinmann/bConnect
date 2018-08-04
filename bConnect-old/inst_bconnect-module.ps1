If(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    
    #$moduleList = @("bConnect.psd1","bConnect.psm1")
    $fileList = Get-ChildItem $PSScriptRoot -Recurse -File
    foreach($_file in $fileList){
    $_source = $_file.FullName
    If(Test-Path $_source) {
        $_target = "$($env:windir)\system32\WindowsPowerShell\v1.0\Modules\bConnect"
        New-Item -Path $_target -ItemType directory -Force | Out-Null
        $_Destination = $_file.FullName.Replace($PSScriptRoot, $_target)
        New-Item -ItemType File -Path $_Destination -Force | Out-Null
        Copy-Item -Path $_source -Destination $_Destination -Force
        If($env:PROCESSOR_ARCHITECTURE -match "AMD64") {
            $_target = "$($env:windir)\syswow64\WindowsPowerShell\v1.0\Modules\bConnect"
            New-Item -Path $_target -ItemType directory -Force | Out-Null
            $_Destination = $_file.FullName.Replace($PSScriptRoot, $_target)
            New-Item -ItemType File -Path $_Destination -Force | Out-Null
            Copy-Item -Path $_source -Destination $_Destination -Force
        }
    } else {
        Write-Host "Installation failed: Module not found!" -ForegroundColor Red
    }
    }
} else {
    Write-Host "Installation failed: Run this script as admin!" -ForegroundColor Red
}