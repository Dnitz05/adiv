[CmdletBinding()]
param (
  [string[]] = @('SUPABASE_DB_URL','SUPABASE_URL','SUPABASE_SERVICE_ROLE_KEY','SUPABASE_ANON_KEY')
)

 = @()
foreach ( in ) {
   = [Environment]::GetEnvironmentVariable()
  if ([string]::IsNullOrWhiteSpace()) {
     += 
  }
}

if (.Count -gt 0) {
  Write-Warning "Missing environment variables: "
  exit 1
}

Write-Output 'Supabase environment variables detected.'
