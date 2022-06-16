$CommandName = "New-ADUser"
$ObjectName = ""

$commandInfo = Get-Command -Name $CommandName

# These types describe the parameters such as Verbose, WhatIf, etc
$commonParameters = @(
    [System.Management.Automation.Internal.CommonParameters].GetProperties().Name
    [System.Management.Automation.Internal.ShouldProcessParameters].GetProperties().Name
)
<#
# Find the default parameter set name. It's not always __AllParameterSets.
if ($commandInfo.DefaultParameterSet) {
    $defaultParameterSet = $commandInfo.DefaultParameterSet
} else {
    $defaultParameterSet = '__AllParameterSets'
}
#>
# Find the possible parameters in the default parameter set)
$FilteredParameters = $commandInfo.Parameters.Keys | Where-Object {
    $parameter = $commandInfo.Parameters[$_]

    $parameter.ParameterSets.Keys -and
    $_ -notin $commonParameters
}

$Splatting = @"
`$$($CommandName -replace "-")`Splatting = @{
     $(
        $String=""
        foreach ($param in $FilteredParameters) {
            if ($ObjectName) {
                $String += "`t $param = `$$ObjectName.$param"+ [Environment]::NewLine
            }
            else {
                $String += "`t $param = `"`""+ [Environment]::NewLine
            }
        }
        $String.Trim()
     )
}

`$$($CommandName -replace "-")`Common = @{
     $(
        $String=""
        foreach ($param in $($CommonParameters)) {
            $String += "`t $param = `"`""+ [Environment]::NewLine
        }
        $String.Trim()
     )
}
$CommandName @$($CommandName -replace "-")`Splatting @$($CommandName -replace "-")`Common
"@

$Splatting | Set-Clipboard
