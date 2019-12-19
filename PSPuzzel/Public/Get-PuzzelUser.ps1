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
            ParameterSetName = 'All'
        )]
        [switch] $All
    )

    begin {
        if (-not (Test-Token)) {
            throw "ERROR: You accessToken is not valid. Please run Connect-Puzzel first"
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Single') {
    
            foreach ($User in $Id) {
    
                Write-Verbose "Getting info about user with ID: $($User)"
                try {
                    $Response = Invoke-APIRequest -Uri ("/users/{0}" -f ($User))
                } catch {
                    Write-Error "ERROR: Could not fetch information about user with ID: $($User)"
                    Write-Error $_
                    return
                }
    
                Write-Output $Response.result
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