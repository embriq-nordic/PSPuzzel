function Get-PuzzelUser {

    [CmdletBinding(DefaultParameterSetName = 'Single')]
    param (
        [Parameter(
            Mandatory=$True,
            ValueFromPipelineByPropertyName=$True,
            ParameterSetName = 'Single'
        )]
        [string[]] $Id,

        [Parameter(
            Mandatory=$True,
            ParameterSetName = "Identity"
        )]
        [Alias('userName')]
        [string[]]
        $Identity,

        [Parameter(
            ParameterSetName = 'All'
        )]
        [switch] $All
    )

    begin {
        if (-not (Test-Token)) {
            throw "ERROR: You accessToken is not valid. Please run Connect-Puzzel first"
        }

        if ($PSCmdlet.ParameterSetName -eq 'Identity') {
            try {
                $AllUsers = Invoke-APIRequest -Uri "/users"
            } catch {
                Write-Error "ERROR: Could not fetch list of users"
                Write-Error $_
                return
            }
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Single') {
    
            foreach ($User in $Id) {
    
                Write-Verbose "Getting info about user with ID: $($User)"
                try {
                    $Response = Invoke-APIRequest -Uri ("/users/{0}" -f ($User))
                } catch {
                    Write-Error $_
                    return
                }
    
                Write-Output $Response.result
            }
    
        }

        if ($PSCmdlet.ParameterSetName -eq 'Identity') {

            foreach ($IdentityItem in $Identity) {

                
                $User = $AllUsers.result | Where-Object { $_.userName -eq "$($IdentityItem)" }
                
                if ($User) {
                    Write-Verbose "Getting info about user with Identity: $($IdentityItem)"
                    $Result = $User | Get-PuzzelUser
                    Write-Output $Result
                } else {
                    Write-Error "Could not find any users with identity $($IdentityItem)"
                    return
                }

            }
        }
    
        if ($PSCmdlet.ParameterSetName -eq 'All') {
            try {
                $Response = Invoke-APIRequest -Uri "/users"
            } catch {
                Write-Error "ERROR: Could not fetch list of users"
                Write-Error $_
                return
            }
    
            Write-Output $Response.result
        }
    }

    end {

    }
}