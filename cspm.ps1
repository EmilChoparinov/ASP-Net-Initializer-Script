param(
    [string]$n,
    [string]$w,
    [string]$i
)
$a = @"

<ItemGroup>
    <DotNetCliToolReference Include=`"Microsoft.DotNet.Watcher.Tools`" Version=`"1.0.0`" />
</ItemGroup>

"@

if ($n) {
    $n = $n.Insert($n.Length, ".csproj")
    if (!$w -or $w.Equals("all")) {
        dotnet add package Microsoft.AspNetCore.Mvc -v="1.1" 
        dotnet add package Microsoft.AspNetCore.StaticFiles -v="1.1"
    }
    if ($i) {
        $content = Get-Content ".\$n"
        $content[$content.Length - 2] += $a
        $content | Set-Content ".\$n"
    }
    dotnet build
    dotnet restore
}
else {
    echo "Help`n`t-n (name of project)`n`t-w (with [if empty everything])`n`t-i include(include watcher [if empty included])"
}