# memory-search.ps1 - Search agent memory

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Query,
    
    [ValidateSet("journal", "decision", "pattern", "learning")]
    [string]$Type,
    
    [string]$From,
    [string]$To,
    [int]$Limit = 10,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

# Configuration
$DB_PATH = ".gsd/memory/index.db"
$MEMORY_DIR = ".gsd/memory"

# Usage
function Show-Help {
    Write-Host @"
Search agent memory

USAGE:
    .\memory-search.ps1 QUERY [OPTIONS]

OPTIONS:
    -Type TYPE          Filter by type (journal, decision, pattern, learning)
    -From DATE          Filter from date (YYYY-MM-DD)
    -To DATE            Filter to date (YYYY-MM-DD)
    -Limit N            Limit results (default: 10)
    -Help               Show this help

EXAMPLES:
    # Search all
    .\memory-search.ps1 "user communication"

    # Search journal only
    .\memory-search.ps1 "migration" -Type journal

    # Search date range
    .\memory-search.ps1 "bash" -From "2026-02-20" -To "2026-02-25"

    # Limit results
    .\memory-search.ps1 "decision" -Limit 5

"@
}

# Search with SQLite FTS5
function Search-WithSqlite {
    param(
        [string]$Query,
        [string]$Type,
        [string]$FromDate,
        [string]$ToDate,
        [int]$Limit
    )
    
    $whereClause = "content MATCH '$Query'"
    
    if ($Type) {
        $whereClause += " AND type = '$Type'"
    }
    
    if ($FromDate) {
        $whereClause += " AND date >= '$FromDate'"
    }
    
    if ($ToDate) {
        $whereClause += " AND date <= '$ToDate'"
    }
    
    $sql = @"
.mode column
.headers on
SELECT 
    type,
    date,
    filename,
    snippet(memory, 4, '<mark>', '</mark>', '...', 32) as snippet
FROM memory
WHERE $whereClause
ORDER BY rank
LIMIT $Limit;
"@
    
    $sql | sqlite3 $DB_PATH
}

# Search with Select-String (fallback)
function Search-WithSelectString {
    param(
        [string]$Query,
        [string]$Type,
        [int]$Limit
    )
    
    $searchDir = $MEMORY_DIR
    
    if ($Type) {
        $searchDir = Join-Path $MEMORY_DIR $Type
    }
    
    if (-not (Test-Path $searchDir)) {
        Write-Host "No results found"
        return
    }
    
    Write-Host "Results:" -ForegroundColor Cyan
    Write-Host ""
    
    Get-ChildItem -Path $searchDir -Filter "*.md" -Recurse | 
        Select-String -Pattern $Query -Context 2 |
        Select-Object -First $Limit |
        ForEach-Object {
            Write-Host "$($_.Filename):$($_.LineNumber)" -ForegroundColor Green
            Write-Host $_.Line
            Write-Host ""
        }
}

# Main
if ($Help) {
    Show-Help
    exit 0
}

# Check if SQLite is available and database exists
$hasSqlite = $null -ne (Get-Command sqlite3 -ErrorAction SilentlyContinue)
$hasDatabase = Test-Path $DB_PATH

if ($hasSqlite -and $hasDatabase) {
    Write-Host "Searching with SQLite FTS5..." -ForegroundColor Blue
    Write-Host ""
    Search-WithSqlite -Query $Query -Type $Type -FromDate $From -ToDate $To -Limit $Limit
}
else {
    Write-Host "SQLite not available, using Select-String..." -ForegroundColor Yellow
    Write-Host ""
    Search-WithSelectString -Query $Query -Type $Type -Limit $Limit
}
