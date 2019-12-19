function Remove-PuzzelSession {
    [CmdletBinding()]
    param ()
    
    process {
        $Script:AuthInfo = @{}
    }
    
    end {
        
    }
}