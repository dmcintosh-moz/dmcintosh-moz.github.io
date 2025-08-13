$bytes = New-Object byte[] 4096
$rng = New-Object System.Random 1337

$rng.NextBytes($bytes)

Set-Content badicon.png -AsByteStream -Value $bytes

