Register-EditorCommand allows you to add commands to VScode that can be executed using the command palette. CRTL+Shift+P (CMD + Shift + P on Mac). 

## Prerequisites

- Make sure to have the PSModule: https://www.powershellgallery.com/packages/EditorServicesCommandSuite/1.0.0-beta4 installed.

> If you use both Windows PowerShell and PowerShell Core, the module must be installed twice for both versions.

## Configuration
1. Copy and paste the code below to VSCode.
1. Make sure to change the _$HelloIDUrl_ and _$apiKeySecret_ according to your own environment.
2. Execute the code to register a new editorCommand.

```powershell
$helloIDUrl = "https://Customer-helloid.com"
$apiKeySecret = "YOUR_API_KEY:Your_API_Secret"
$base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiKeySecret))

Register-EditorCommand -Name HelloID.User -DisplayName "HelloIDGetUser" -ScriptBlock {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Basic $base64")
    
    $context = $psEditor.GetEditorContext()
    $userName = $context.CurrentFile.GetText()
    $result = Invoke-WebRequest "$helloIDUrl/api/v1/users/$userName" -Method 'GET' -Headers $headers
    $person = $result.Content

    $content = '$person = @"' +[environment]::NewLine + $person +[environment]::NewLine + '"@ | ConvertFrom-Json'
    $context.CurrentFile.InsertText($content, $context.SelectedRange)
}

Register-EditorCommand -Name HelloID.GetAllUsers -DisplayName "HelloID.GetAllUsers" -ScriptBlock {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Basic $base64")

    $result = Invoke-WebRequest "$helloIDUrl/api/v1/users" -Method 'GET' -Headers $headers

    $htmlContentView = New-VSCodeHtmlContentView -Title "HelloID.GetAllUsers"
    Set-VSCodeHtmlContentView -HtmlContentView $htmlContentView -HtmlBodyContent @"
<h1>HelloID.GetAllUsers</h1>
<p>Users from $helloIDUrl</p>
<pre>
<ol>
$($result.Content)
</ol>
</pre>
"@
    Show-VSCodeHtmlContentView $htmlContentView
}

Register-EditorCommand -Name HelloID.GetAllAutomationVariables -DisplayName "HelloID.GetAllAutomationVariables" -ScriptBlock {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Basic $base64")

    $result = Invoke-WebRequest "$helloIDUrl/api/v1/automation/variables" -Method 'GET' -Headers $headers

    $htmlContentView = New-VSCodeHtmlContentView -Title "HelloID.GetAllAutomationVariables"
    Set-VSCodeHtmlContentView -HtmlContentView $htmlContentView -HtmlBodyContent @"
<h1>HelloID.GetAllAutomationVariables</h1>
<p>Variables from $helloIDUrl</p>
<pre>
<ol>
$($result.Content)
</ol>
</pre>
"@
    Show-VSCodeHtmlContentView $htmlContentView
}
```

## Usage
1. Open a new document in VSCode using CRTL + n
2. Enter the userName and immediately select the userName.
3. Open the command palette using CRTL+Shift+P (CMD + Shift + P on Mac). 
4. Select: <PowerShell: Show additional commands from PowerShell modules>.
5. Have fun!
