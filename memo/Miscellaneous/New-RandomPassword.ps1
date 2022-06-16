function New-RandomPassword {
    param(
        [Parameter(Mandatory)]
        [int] $Length,
        [int] $NonAlphaChars = $Length / 4,
        [switch] $AsSecureString
    )
    Add-Type -AssemblyName 'System.Web'
    $ComplexEnough = $false
    do {
        $RandomPassword = $([System.Web.Security.Membership]::GeneratePassword($Length, $NonAlphaChars))
        $ComplexEnough = ($RandomPassword -cmatch "[A-Z\p{Lu}\s]") -and ($RandomPassword -cmatch "[a-z\p{Ll}\s]") -and ($RandomPassword -match "[\d]") -and ($RandomPassword -match "[^\w]")

    }
    while (-not $ComplexEnough)

    if ($AsSecureString) {
        ConvertTo-SecureString -String $RandomPassword -AsPlainText -Force
    }
    else {
        $RandomPassword
    }
}
