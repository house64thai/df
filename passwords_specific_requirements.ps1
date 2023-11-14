function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [ValidateRange(4,[int]::MaxValue)]
        [int] $length,
        [int] $upper = 1,
        [int] $lower = 1,
        [int] $numeric = 1,
        [int] $special = 1
    )
    if($upper + $lower + $numeric + $special -gt $length) {
        throw "number of upper/lower/numeric/special char must be lower or equal to length"
    }
    $uCharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $lCharSet = "abcdefghijklmnopqrstuvwxyz"
    $nCharSet = "0123456789"
    $sCharSet = "/*-+,!?=()@;:._"
    $charSet = ""
    if($upper -gt 0) { $charSet += $uCharSet }
    if($lower -gt 0) { $charSet += $lCharSet }
    if($numeric -gt 0) { $charSet += $nCharSet }
    if($special -gt 0) { $charSet += $sCharSet }
    
    $charSet = $charSet.ToCharArray()
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[]($length)
    $rng.GetBytes($bytes)
 
    $result = New-Object char[]($length)
    for ($i = 0 ; $i -lt $length ; $i++) {
        $result[$i] = $charSet[$bytes[$i] % $charSet.Length]
    }
    $password = (-join $result)
    $valid = $true
    if($upper   -gt ($password.ToCharArray() | Where-Object {$_ -cin $uCharSet.ToCharArray() }).Count) { $valid = $false }
    if($lower   -gt ($password.ToCharArray() | Where-Object {$_ -cin $lCharSet.ToCharArray() }).Count) { $valid = $false }
    if($numeric -gt ($password.ToCharArray() | Where-Object {$_ -cin $nCharSet.ToCharArray() }).Count) { $valid = $false }
    if($special -gt ($password.ToCharArray() | Where-Object {$_ -cin $sCharSet.ToCharArray() }).Count) { $valid = $false }
 
    if(!$valid) {
         $password = Get-RandomPassword $length $upper $lower $numeric $special
    }
    return $password
}
Get-RandomPassword 8

# # length 8, 1 upper, 1 lower, 1 number, 1 special
# Get-RandomPassword 8
# # !64mQbcY
# # at least 4 upper case characters
# Get-RandomPassword 8 4
# # kEyW8IB/
# # length 12, at least 2 upper case, 2 lower case, 1 number
# Get-RandomPassword 12 2 2 1
# # USj;,Y5MKyME
# # length 12, at least 5 upper case, 5 numbers
# Get-RandomPassword 12 -upper 5 -numeric 5
# # 722HE32WWDy!
# # length 8, at least 4 lower case, 4 numbers
# Get-RandomPassword 8 0 4 4 0
# # 9ub0v47y
# # length 8, 2 upper, 2 lower, 2 number, 2 special
# Get-RandomPassword 8 2 2 2 2
# # 0=oeS.F4
# # length 20, 1 upper, 1 lower, 1 number, 1 special
# Get-RandomPassword 20 1 1 1 1
# # ma/dS@Z+ghuvCfEv=_5V