param(
    [switch]$h,
    $o,
    [switch]$g,
    [switch]$d,
    [switch]$e
)
$help = @"
Commands:
    -g add git to the project
    -o <name> create a folder and create the project in there
    -d include dapper
    -e include entity 
"@

$git = @"
.vscode
bin/
obj/
"@

$a = @"

    <ItemGroup>
        <DotNetCliToolReference Include=`"Microsoft.DotNet.Watcher.Tools`" Version=`"1.0.0`" />
    </ItemGroup>
"@
if ($h) {
    echo $help
}
else {
    if ($o) {
        mkdir $o > $null
        cd $o > $nullp
    }
    dotnet new mvc
    
    if ($d) {
        dotnet add package Dapper
    }
    if ($e) {
        dotnet add package MySql.Data.EntityFrameworkCore -v 7.0.7-*
    }
    
    $fileNames = Get-ChildItem -Path $scriptPath -Recurse -Include *.csproj
    $file = $fileNames[0]
    
    try {
        dotnet add package Microsoft.AspNetCore.Session -v="1.1"
        dotnet add package MySql.Data -v 7.0.7-*
        dotnet add package System.Data.SqlClient -v 4.1.0-*  
        dotnet add package Microsoft.Extensions.Options.ConfigurationExtensions -v="1.1"
        $content = Get-Content $file
        $content[$content.Length - 2] += $a
        $content | Set-Content $file   
        echo "including complete"
        dotnet restore
        dotnet build
    }
    catch {
        echo "Count not find "$file
    }
    
    if ($g) {
        git init
        new-item .gitignore
        Set-Content ".gitignore" $git
        git add .
        git commit -m "initial commit"
    }
}
echo "Type csi -h for help!";