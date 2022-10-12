using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

#Setting variables 
$Groups = $null
$body = $null
$subscriptionName = $null

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
Write-Host "Request parameters count : "
Write-Host $Request.Query.Count

# Interact with query parameters or the body of the request.
$SubscriptionId = $Request.Query.SubscriptionId
if (-not $SubscriptionId) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::NoContent
        Body = "Error : This HTTP trigger needs at least a subscription Id to operate"
    })
}

# Interact with query parameters or the body of the request.
$TenantId = $Request.Query.TenantId
if (-not $TenantId) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::NoContent
        Body = "Error : This HTTP trigger needs at least a TenantId to operate"
    })
}

Write-Host "Start Sleep for 15 seconds"
Set-AzContext -Subscription $SubscriptionId -Tenant $TenantId
Start-Sleep -Seconds 15 

Write-Host "======================================="
Write-Host "Context after thread sleep : "
$subscriptionName = (Get-AzContext).Subscription.name
Write-Host $subscriptionName


# $group = az group show --name $groupName
$Groups = Get-AzResourceGroup
Write-Host "Groups : " $Groups.Count

$body = "This HTTP triggered function executed successfully. Pass a Group Name in the query string or in the request body for a personalized response."

if ($null -ne $Groups) {
    $subscriptionName = (Get-AzContext).Subscription.name
    $body = "You have " + $Groups.Count +" groups under the following subscription : "+ $subscriptionName }

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
