function Format-Json {
    [CmdletBinding(DefaultParameterSetName = 'Prettify')]
    Param(
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [String]$Json,
        [Parameter(ParameterSetName = 'Minify')]
        [Switch]$Minify,
        [Parameter(ParameterSetName = 'Prettify')]
        [ValidateRange(1, 1024)]
        [Int]$Indentation = 2,
        [Parameter(ParameterSetName = 'Prettify')]
        [Switch]$AsArray
    )
    if ($PSCmdlet.ParameterSetName -EQ 'Minify') {
        return ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100 -Compress
    }
    if ($Json -NotMatch '\r?\n') {
        $Json = ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100
    }
    $Padding = 0
    $Regex = '(?=([^"]*"[^"]*")*[^"]*$)'
    $Result = $Json -Split '\r?\n' | ForEach-Object {
        if ($_ -Match "[}\]]$Regex") {
            $Padding = [Math]::Max($Padding - $Indentation, 0)
        }
        $Line = (' ' * $Padding) + ($_.TrimStart() -Replace ":\s+$Regex", ': ')
        if ($_ -Match "[\{\[]$Regex") {
            $Padding += $Indentation
        }
        $Line
    }
    if ($AsArray) {
        return $Result
    }
    return $Result -Join [Environment]::NewLine
}
