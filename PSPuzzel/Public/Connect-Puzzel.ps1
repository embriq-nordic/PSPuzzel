Function Connect-Puzzel {

    [CmdletBinding(DefaultParameterSetName = "Credentials")]
    param(
        [Parameter(
            ParameterSetName = "Credentials",
            Mandatory = $false
        )]
        [PSCredential] $Credential,

        [Parameter(
            ParameterSetName = "Token",
            Mandatory = $true
        )]
        [string]
        $Token
    )

    # Check if token already is set
    if ((Test-Token)) {
        Write-Output "INFO: Your token is already set."
        return
    }

    if ($PSCmdlet.ParameterSetName -eq "Credentials") {

        # If credentials are not passed, then ask for them
        if (-not $Credential) {
            $Credential = Get-Credential -Message "Provide username with customer key. e.g 1234566\username"
        }
    
        # Request token based on credentials
        $Auth = Invoke-WebRequest `
            -Uri ("{0}/auth/credentials?userName={1}&password={2}" -f ($Script:BaseURL, $Credential.Username, $Credential.GetNetworkCredential().password)) `
            -Method GET

        if ($Auth.StatusCode -ne 200) {
            ThrowError `
                -ExceptionName "AuthenticationFailedExeception" `
                -ExceptionMessage "Authentication failed. Please try again" `
                -errorId 1 `
                -errorCategory AuthenticationError
        }

        $AuthData = $Auth.Content | ConvertFrom-Json
        $Script:AuthInfo.AccessToken = $AuthData.result

    }
    elseif ($PSCmdlet.ParameterSetName -eq "Token") {

        $Script:AuthInfo.AccessToken = $Token

    }

    $TokenInfo = Invoke-WebRequest `
        -Uri ("{0}/accesstokeninformation" -f ($Script:BaseURL)) `
        -Method GET `
        -Headers @{ "X-AccessToken" = $Script:AuthInfo.AccessToken }

    if ($TokenInfo.StatusCode -ne 200) {
        ThrowError `
            -ExceptionName "AuthenticationFailedExeception" `
            -ExceptionMessage "Could not retrieve accesstoken information" `
            -errorId 2 `
            -errorCategory AuthenticationError
    }

    $TokenInfoData = $TokenInfo.Content | ConvertFrom-Json
    $Script:AuthInfo.CustomerKey = $TokenInfoData.result.customerKey
    $Script:AuthInfo.UserID = $TokenInfoData.result.userId
    $Script:AuthInfo.AccessTokenExpiry = $TokenInfoData.result.accessTokenExpiry
}