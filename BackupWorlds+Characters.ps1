$LocalDataPath = "C:\Users\zanzo\AppData\LocalLow\IronGate\Valheim"
$steamCloudDataPath = "C:\Program Files (x86)\Steam\userdata\8911761\892970\remote" #steam cloud saves
#steam install paths
$steamClientPath = "D:\SteamLibrary\steamapps\common\Valheim" #steam client
$steamServerPath = "D:\SteamLibrary\steamapps\common\Valheim dedicated server" #steam dedicated server
#xbox install paths
$xboxClientPath = "D:\WindowsApps\CoffeeStainStudios.Valheim_0.217.38.0_x64__496a1srhmar9w" #xbox client
$xboxServerPath = "D:\WindowsApps\CoffeeStainStudios.Valheim_0.217.38.0_x64__496a1srhmar9w\Server" #xbox dedicated server
#local
$localCharactersPath = "$($LocalDataPath)\characters_local"
$localWorldsPath = "$($LocalDataPath)\worlds_local"
#steam cloud
$steamCloudCharactersPath = "$($steamCloudDataPath)\characters"
$steamCloudWorldsPath = "$($steamCloudDataPath)\worlds"
#backups storage path
$BackupSavePath = "D:\ValheimBackups"


function Get-AutoCloudID()
{
    $steamCloudFile = "$($LocalDataPath)\characters\steam_autocloud.vdf"
    $data = get-content($steamCloudFile)
    $id = $data[2].Replace('	"accountid"		',"").Replace("\t", "").replace('"',"").Replace(" ","")
    return $id
}

$steamCloudDataPath = "C:\Program Files (x86)\steam\userdata\$(Get-AutoCloudID)\892970\remote"
#steam remote character and world save file locations...
$cloudCharactersPath = "$($steamCloudDataPath)\characters"
$cloudWorldsPath = "$($steamCloudDataPath)\worlds"
$cloudServerListPath = "$($steamCloudDataPath)\serverlist"

function Get-LocalCharacters()
{
    $characterFiles = Get-ChildItem -File -Name -Path $localCharactersPath -include *.fch -Exclude *_backup*.fch
    foreach($char in $characterFiles){
        $character = $char.Replace(".fch","")
        $characterBackups = Get-ChildItem  -Path $localCharactersPath -File -Name -include "$($character)_backup*.fch"
        write-host "Found character " -nonewline; write-host $character -ForegroundColor Green -NoNewline
        write-host " with " -NoNewline; write-host "$($characterBackups.Length)" -ForegroundColor green -NoNewline
        write-host " backup files:"# -NoNewline; write-host $character -ForegroundColor Green
        foreach($backup in $characterBackups){
            write-host "`t$($backup)" -ForegroundColor Yellow
        }
    }
    <#foreach($backup in $characterBackups){
        write-host "Found character backup: " -NoNewline; write-host $backup.replace(".fch","") -ForegroundColor Yellow
    }#>
}

function List-LocalWorlds()
{
    $worldFiles = Get-ChildItem -File -Name -Path $localWorldsPath -include *.db -Exclude *_backup*.db
    foreach($char in $worldFiles){
        $world = $char.Replace(".db","")
        $worldBackups = Get-ChildItem  -Path $localWorldsPath -File -Name -include "$($world)_backup*.db"
        write-host "Found world " -nonewline; write-host $world -ForegroundColor Green -NoNewline
        write-host " with " -NoNewline; write-host "$($worldBackups.Length)" -ForegroundColor green -NoNewline
        write-host " backup files:"# -NoNewline; write-host $world -ForegroundColor Green
        foreach($backup in $worldBackups){
            write-host "`t$($backup)" -ForegroundColor Yellow
        }
    }
    <#foreach($backup in $worldBackups){
        write-host "Found world backup: " -NoNewline; write-host $backup.replace(".db","") -ForegroundColor Yellow
    }#>
}


function BackupAllWorlds()
{
    #local worlds
    $worldFiles = Get-ChildItem -Path $localWorldsPath\* -File -Name -include *.db -Exclude *_backup*
    write-host "Backing up " -nonewline; write-host $worldFiles.Length -foregroundcolor Green -nonewline; write-host " local Worlds..."
    foreach($f in $worldFiles){
        write-host $f.replace(".db","") -ForegroundColor Green
    }
    #copy local worlds...
    copy-item -Path $localWorldsPath\* -Destination "D:\ValheimBackups\world_backups\worlds_local\" -force
    
    #remote worlds
    $worldFiles = Get-ChildItem -Path $cloudWorldsPath\* -File -Name -include *.db -Exclude *_backup*
    write-host "Backing up " -nonewline; write-host $worldFiles.Length -foregroundcolor Green -nonewline; write-host " remote Worlds..."
    foreach($f in $worldFiles){
        write-host $f.replace(".db","") -ForegroundColor Green
    }
    #copy remote worlds...
    copy-item -Path $cloudWorldsPath\* -Destination "D:\ValheimBackups\world_backups\worlds\" -force

    write-host "Backup Complete!" 
}

function BackupWorld($world_name)
{
    #local worlds
    $worldFiles = Get-ChildItem -Path $localWorldsPath\$world_name* -File -Name -include $world_name*.db -Exclude $world_name*_backup*
    write-host "Backing up " -nonewline; write-host $worldFiles.Length -foregroundcolor Green -nonewline; write-host " local $($world_name) Worlds..."
    foreach($f in $worldFiles){
        write-host $f.replace(".db","") -ForegroundColor Green
    }
    #copy local worlds...
    copy-item -Path $localWorldsPath\$world_name* -Destination "D:\ValheimBackups\world_backups\worlds_local\" -force
    
    #remote worlds
    $worldFiles = Get-ChildItem -Path "$($cloudWorldsPath)\$($world_name)*" -File -Name -include $world_name*.db -Exclude $world_name*_backup*
    write-host "Backing up " -nonewline; write-host $worldFiles.Length -foregroundcolor Green -nonewline; write-host " remote $($world_name) Worlds..."
    foreach($f in $worldFiles){
        write-host $f.replace(".db","") -ForegroundColor Green
    }
    #copy remote worlds...
    copy-item -Path "$($cloudWorldsPath)\$($world_name)*" -Destination "D:\ValheimBackups\world_backups\worlds\" -force

    write-host "Backup Complete!"
}

function BackupAllCharacters()
{
    #local characters
    $characterFiles = Get-ChildItem -Path $localCharactersPath\* -File -Name -include *.fch -Exclude *_backup*
    write-host "Backing up " -nonewline; write-host $characterFiles.Length -foregroundcolor Green -nonewline; write-host " local Characters..."
    foreach($f in $characterFiles){
        write-host $f.replace(".fch","") -ForegroundColor Green
    }
    #copy local characters...
    copy-item -Path "$($localCharactersPath)\*" -Destination "D:\ValheimBackups\character_backups\characters_local" -force
    
    #remote characters
    $characterFiles = Get-ChildItem -Path $cloudCharactersPath\* -File -Name -include *.fch -Exclude *_backup*
    write-host "Backing up " -nonewline; write-host $characterFiles.Length -foregroundcolor Green -nonewline; write-host " remote Characters..."
    foreach($f in $characterFiles){
        write-host $f.replace(".fch","") -ForegroundColor Green
    }
    #copy remote characters...
    copy-item -Path "$($cloudCharactersPath)\*" -Destination "D:\ValheimBackups\character_backups\characters" -force

    write-host "Backup Complete!" 
}

function BackupCharacter($character_name)
{
    #local characters
    $characterFiles = Get-ChildItem -Path "$($localCharactersPath)\*" -File -Name -include $character_name*.fch -Exclude $character_name*_*.fch
    write-host "Backing up " -nonewline; write-host $characterFiles.Length -foregroundcolor Green -nonewline; write-host " local $($character_name) Characters..."
    foreach($f in $characterFiles){
        write-host $f.replace(".fch","") -ForegroundColor Green
        copy-item -Path "$($localCharactersPath)\$($f)" -Destination "D:\ValheimBackups\character_backups\characters_local\$($f)" -force
    }
    #remote characters
    $characterFiles = Get-ChildItem -Path "$($cloudCharactersPath)\*" -File -Name -include "$($character_name)*.fch" -Exclude "$($character_name)*_*.fch*", $character_name*.old
    write-host "Backing up " -nonewline; write-host $characterFiles.Length -foregroundcolor Green -nonewline; write-host " remote $($character_name) Characters..."
    foreach($f in $characterFiles){
        write-host $f.replace(".fch","") -ForegroundColor Green
        copy-item -Path "$($cloudCharactersPath)\$($f)" -Destination "D:\ValheimBackups\character_backups\characters\$($f)" -force
    }

    write-host "Backup Complete!"
}

#TODO: add functions to backup local/remote favorite & recent ServerLists.
BackupAllWorlds
pause
backupallcharacters