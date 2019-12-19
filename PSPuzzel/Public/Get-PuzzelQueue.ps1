Function Get-PuzzelQueue {
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

            foreach ($Group in $Id) {

                try {
                    $Response = Invoke-APIRequest -Uri ("/visualqueues/stateinformation/All?visualQueueId={0}" -f $Group)
                } catch {
                    Write-Error "ERROR: Could not fetch information about group with ID: $($Group)"
                    Write-Error $_
                    return
                }

                Write-Output $Response.result
            }

        }
    
        if ($PSCmdlet.ParameterSetName -eq 'All') {

            try {
                $Response = Invoke-APIRequest -Uri "/visualqueues"
            } catch {
                Write-Error "ERROR: Could not fetch a list of all groups"
                Write-Error $_
                return
            }

            Write-Output $Response.result
        }

    }
}