$Script:AuthInfo = @{
    CustomerKey = ""
    AccessToken = ""
    AccessTokenExpiry = ""
    UserID = ""
}
$Script:BaseURL = "https://api.puzzel.com/ContactCentre5"

#region LoadFunctions
$PrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$PublicFunctions = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the functions
ForEach ($File in @($PublicFunctions + $PrivateFunctions)) {
    Try {
        . $File.FullName
    }
    Catch {
        $errorItem = [System.Management.Automation.ErrorRecord]::new(
            ([System.ArgumentException]"Function not found"),
            'Load.Function',
            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
            $File
        )
        $errorItem.ErrorDetails = "Failed to import function $($File.BaseName)"
        $PSCmdlet.ThrowTerminatingError($errorItem)
    }
}
#endregion LoadFunctions