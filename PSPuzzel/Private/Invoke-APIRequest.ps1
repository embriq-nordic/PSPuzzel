function Invoke-APIRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [uri]
        $Uri,
        
        [Parameter()]
        [string]
        $Method = "GET"
    )

    begin {
        $ValidStatusCodes = @(200, 201, 202, 203)
    }


    process {
        $Headers = @{
            "X-AccessToken" = $Script:AuthInfo.AccessToken
        }

        $RequestSplat = @{
            Uri = "{0}/{1}{2}" -f ($Script:BaseURL, $Script:AuthInfo.CustomerKey, $Uri)
            Method = $Method
            Headers = $Headers
            ContentType = "application/json"
        }

        $Response = Invoke-WebRequest @RequestSplat -ErrorAction Stop
        $ResponseData = $Response.Content | ConvertFrom-Json
        
        if (-not ($ValidStatusCodes.Contains($Response.StatusCode))) {
            throw "[ERROR(HTTP{0})] {1}" -f ($Response.StatusCode, $Response.StatusDescription)
        } elseif ($ResponseData.code -and $ResponseData.code -ne 0 ) {
            throw "[ERROR({0})] {1}" -f ($ResponseData.code, $ResponseData.message)
        }

        return $ResponseData
    }

    end {

    }
}