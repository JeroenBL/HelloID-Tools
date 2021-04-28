# Register-EditorCommand allows you to add commands to VScode that can be executed using the command palette. CRTL+Shift+P (CMD + Shift + P on Mac). 
# 1. Make sure to change lines 2/3 according to your own environment.
# 2. Execute the code to register a new editorCommand.
# 3. Open a new document in VSCode using CRTL + n
# 4. Enter the userName and immediately select the userName.
# 5. Open the command palette using CRTL+Shift+P (CMD + Shift + P on Mac). 
# 6. Select: <PowerShell: Show additional commands from PowerShell modules>.
# 7. Select: <Add user from HelloID>.

Register-EditorCommand -Name HelloID.User -DisplayName "Add user from HelloID" -ScriptBlock {
    $helloIDUrl = "https://Customer-helloid.com"
    $apiKeySecret = "YOUR_API_KEY:Your_API_Secret"

    $context = $psEditor.GetEditorContext()
    $userName = $context.CurrentFile.GetText()

    $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiKeySecret))
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Basic $base64")

    $result = Invoke-WebRequest "$helloIDUrl/api/v1/users/$userName" -Method 'GET' -Headers $headers
    $person = $result.Content

    $content = '$person = @"' +[environment]::NewLine + $person +[environment]::NewLine + '"@ | ConvertFrom-Json'
    $context.CurrentFile.InsertText($content, $context.SelectedRange)
}
