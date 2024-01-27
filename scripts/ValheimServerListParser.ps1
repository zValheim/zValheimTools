$workpath = "C:\users\zanzo\desktop\V"
$savefile = "$($workpath)\test.vsl"
$FavoriteServerList = "C:\Users\zanzo\AppData\LocalLow\IronGate\Valheim\serverlist_local\favorite"
$RecentServerList = "C:\Users\zanzo\AppData\LocalLow\IronGate\Valheim\serverlist_local\recent"

$serverlist_regex = "(?<name>[a-zA-Z0-9 ]+)(?<test>[\p{C}|\s]{1})?(?:\t  \t[^0-9\s]+)?(?<ip>[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(?:[^a-zA-Z0-9]+)(?<world>[a-zA-Z0-9]+)(?:[\s|^\p{L}])"gm
$regex = "(?<name>[a-zA-Z0-9 ]+)(?<test>[\p{C}|\s]{1})?(?:\t  \t[^0-9\s]+)?(?<ip>[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(?:˜)?(?:[^a-zA-Z0-9]+)(?<world>[a-zA-Z0-9]+)(?:[\s|^\p{L}])"gm