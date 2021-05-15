Register-EditorCommand -Name HelloID.AddVSCodePersonVariable -DisplayName "HelloID.AddVSCodePersonVariable" -ScriptBlock {
    $PersonId = Read-Host 'Enter PersonId'

$stringToAdd = @"
    `$Global:person = Get-Stuntman -UserId $PersonId -ConvertToPerson | ConvertTo-Json -Depth 100
"@

    $stringToAdd | Out-File $helloIDConfigFile -Append
}

Register-EditorCommand -Name HelloID.AddVSCodeManagerVariable -DisplayName "HelloID.AddVSCodeManagerVariable" -ScriptBlock {
    $ManagerId = Read-Host 'Enter ManagerId'

$stringToAdd = @"
    `$Global:manager = Get-Stuntman -UserId $ManagerId -ConvertToPerson | ConvertTo-Json -Depth 100
"@

    $stringToAdd | Out-File $helloIDConfigFile -Append
}

Register-EditorCommand -Name HelloID.AddVSCodeConnectorConfigurationVariable -DisplayName "HelloID.AddVSCodeConnectorConfigurationVariable" -ScriptBlock {
    $connectorConfigFile = Read-Host 'Config File'

$stringToAdd = @"
    `$Global:configuration = Get-Content "$connectorConfigFile"
"@

    $stringToAdd | Out-File $helloIDConfigFile -Append
}

Register-EditorCommand -Name HelloID.RemoveCurrentVSCodeConfiguration -DisplayName "HelloID.RemoveCurrentVSCodeConfiguration" -ScriptBlock {
    $content = Get-Content $helloIDConfigFile
    $null | Out-File $helloIDConfigFile

    $htmlContentView = New-VSCodeHtmlContentView -Title "HelloID.RemoveCurrentVSCodeConfiguration"
    Set-VSCodeHtmlContentView -HtmlContentView $htmlContentView -HtmlBodyContent @"
<h1>HelloID.RemoveCurrentVSCodeConfiguration</h1>
<p>Removed content:</p>
<pre>
$content
</pre>
"@
    Show-VSCodeHtmlContentView $htmlContentView
}

Register-EditorCommand -Name HelloID.GetCurrentVSCodeConfiguration -DisplayName "HelloID.GetCurrentVSCodeConfiguration" -ScriptBlock {
    $content = Get-Content $helloIDConfigFile

    $htmlContentView = New-VSCodeHtmlContentView -Title "HelloID.GetCurrentVSCodeConfiguration"
Set-VSCodeHtmlContentView -HtmlContentView $htmlContentView -HtmlBodyContent @"
<h1>HelloID.GetCurrentVSCodeConfiguration</h1>
<p>Current config:</p>
<pre>
$content
</pre>
"@
    Show-VSCodeHtmlContentView $htmlContentView
}
