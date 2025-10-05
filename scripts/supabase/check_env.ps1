[CmdletBinding()]
param(
    [string[]]$Variables = @(
        'SUPABASE_DB_URL',
        'SUPABASE_URL',
        'SUPABASE_SERVICE_ROLE_KEY',
        'SUPABASE_ANON_KEY'
    )
)

$missing = @()
foreach ($var in $Variables) {
    $value = [Environment]::GetEnvironmentVariable($var)
    if ([string]::IsNullOrWhiteSpace($value)) {
        $missing += $var
    }
}

if ($missing.Count -gt 0) {
    Write-Warning ("Missing environment variables: {0}" -f ($missing -join ', '))
    exit 1
}

Write-Output 'Supabase environment variables detected.'
