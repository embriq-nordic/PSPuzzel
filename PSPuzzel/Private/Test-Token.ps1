Function Test-Token {
    If ([string]::IsNullOrEmpty($Script:AuthInfo.AccessToken)) {
        return $false
    } else {
        return $true
    }

    If ($Script:AuthInfo.AccessTokenExpiry -lt (Get-Date)) {
        return $false
    } else {
        return $true
    }
}