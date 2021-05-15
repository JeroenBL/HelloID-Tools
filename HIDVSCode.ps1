# Register editorCommands
Register-EditorCommand -Name HelloID.SetVSCodePerson -DisplayName "HelloID.SetVSCodePerson" -ScriptBlock {
    $PersonId = Read-Host 'Enter PersonId'
    $content = Get-Content $helloIDConfigFile
    [regex]$regex = "(['])(?:(?=(\\?))\2.)*?\1"
    $newContent = $content -replace $regex, "'$PersonId'"
    $newContent | Set-Content -Path $helloIDConfigFile
}

Register-EditorCommand -Name HelloID.SetVSCodeManager -DisplayName "HelloID.SetVSCodeManager" -ScriptBlock {
    $ManagerId = Read-Host 'Enter ManagerId'
    $content = Get-Content $helloIDConfigFile
    [regex]$regex = "(['])(?:(?=(\\?))\2.)*?\1"
    $newContent = $content -replace $regex, "'$ManagerId'"
    $newContent | Set-Content -Path $helloIDConfigFile
}

Register-EditorCommand -Name HelloID.SetVSCodeConnectorConfiguration -DisplayName "HelloID.SetVSCodeConnectorConfiguration" -ScriptBlock {
    $connectorConfigFile = Read-Host 'Path to config file'
    $content = Get-Content $helloIDConfigFile
    [regex]$regex = '[a-zA-Z]:\\(((?![<>:"/\\|?*]).)+((?<![ .])\\)?)*$'
    $newContent = $content -replace $regex, $connectorConfigFile
    $newContent | Set-Content -Path $helloIDConfigFile
}

Register-EditorCommand -Name HelloID.GetCurrentVSCodeSettings -DisplayName "HelloID.GetCurrentVSCodeSettings" -ScriptBlock {
    $content = Get-Content $helloIDConfigFile
    $html = $null
    foreach ($line in $content){

$htmlList = @"
<li>$line</li>
"@
        $html += $htmlList
    }

    $htmlContentView = New-VSCodeHtmlContentView -Title "HelloID.GetCurrentVSCodeSettings"
    Set-VSCodeHtmlContentView -HtmlContentView $htmlContentView -HtmlBodyContent @"
<h1>HelloID.GetCurrentVSCodeSettings</h1>
<p>Current config:</p>
<pre>
<ol>
$html
</ol>
</pre>
"@
    Show-VSCodeHtmlContentView $htmlContentView
}
