function Resolve-ADOrganizationalUnit {
    param (
        $DistinguishedName
    )
    $null = $DistinguishedName -match "^(?:(?<object>(OU|CN)=(?<name>.*?)),)?(?<parent>(?:(?<path>(?:CN|OU).*?),)?(?<domain>(?:DC=.*)+))$"
    $Object = [pscustomobject]@{
        Name   = $Matches['name']
        Object = $Matches['object']
        Path   = $Matches['path']
        Domain = $Matches['domain']
        Parent = $Matches['parent']
        Tree   = ""
    }
    $preoutput = @()
    $PathArray = $Matches['parent'] -split '(?<![\\]),'
    [array]::Reverse($PathArray)
    $Object.Tree = $PathArray | ForEach-Object {
        $preoutput += $_
        if ($_ -match "OU=|CN=") {
            $output = $preoutput.Clone(); [array]::Reverse($output)
            $output -join ","
        }
    }
    $Object
}
