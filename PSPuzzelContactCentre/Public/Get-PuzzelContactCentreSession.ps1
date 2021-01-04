function Get-PuzzelContactCentreSession {
    [CmdletBinding()]
    param ()
    
    process {
        if (-not (Test-Token)) {
            Write-Error "ERROR: You do not have a valid session. Please run Connect-Puzzel first."
            return
        } else {
            $Script:AuthInfo
        }
    }
}
