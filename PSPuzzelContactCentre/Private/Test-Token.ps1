Function Test-Token {
    if ([string]::IsNullOrEmpty($Script:AuthInfo.AccessToken)) {
        return $false
    }

    if ($Script:AuthInfo.AccessTokenExpiry -lt (Get-Date)) {
        return $false
    }

    return $true
}