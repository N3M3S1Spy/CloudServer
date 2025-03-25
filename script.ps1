# Pfad zum Startverzeichnis (z. B. "C:\")
$startDirectory = "C:\"

# Hash-Algorithmus (SHA256, MD5, SHA1 usw.)
$hashAlgorithm = "MD5"

# Array mit den Hash-Werten, nach denen gesucht wird
$hashList = @(
    "4f2d0f4a5ba798fa9e85379c7c4bd36e",
    "33a75bfb1b9038899b9ba5e2a06d5d57",
    "ba2a1815e16b357eeff23b8394457aa5",
    "b0a1fb39e017644ea5a78332328d0ebd",
    "bdc4a8043e404ce1949394bc1799b0d7",
    "235f2a28722708cb3053d1897d3f6bc0",
    "e6a53480ad684a4401aed5430c6af251",
    "b652bd25b26bcc5ab35e9c56053c2069",
    "b0e0460783df540e55c63c0be16d18eb"
)

# Pfad zur Ausgabedatei
$outputPath = "C:\Windows\Temp\uebereinstimmungen.txt"

# Funktion zur rekursiven Durchsuchung des Dateisystems
function Find-Files {
    param(
        [string]$directory
    )

    # Alle Dateien im aktuellen Verzeichnis abrufen
    $files = Get-ChildItem -Path $directory -File -ErrorAction SilentlyContinue

    # Alle Unterverzeichnisse im aktuellen Verzeichnis abrufen
    $directories = Get-ChildItem -Path $directory -Directory -ErrorAction SilentlyContinue

    # Hash-Werte für alle Dateien berechnen und vergleichen
    foreach ($file in $files) {
        try {
            Write-Host "Überprüfe: $($file.FullName)"
            $hash = Get-FileHash -Path $file.FullName -Algorithm $hashAlgorithm | Select-Object -ExpandProperty Hash
            if ($hashList -contains $hash) {
                Write-Host "Übereinstimmung gefunden: $($file.FullName)"
                Add-Content -Path $outputPath -Value "Übereinstimmung gefunden: $($file.FullName)"
            }
        } catch {
            Write-Warning "Fehler beim Berechnen des Hash-Werts für $($file.FullName): $($_.Exception.Message)"
        }
    }

    # Rekursive Durchsuchung der Unterverzeichnisse
    foreach ($subdirectory in $directories) {
        Find-Files -directory $subdirectory.FullName
    }
}

# Suche starten
Find-Files -directory $startDirectory