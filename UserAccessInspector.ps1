# Import the Dynamics 365 Connector
Add-Type -Path "C:\path\to\Microsoft.Xrm.Tooling.Connector.dll"

# Dynamics 365 connection string
$connectionString = "AuthType=OAuth;Username=yourusername@yourdomain.com; Password=yourpassword;Url=https://yourorg.crm.dynamics.com;AppId=yourappid; RedirectUri=yourappredirecturi;"

# Create a new CrmServiceClient
$crmServiceClient = New-Object -TypeName Microsoft.Xrm.Tooling.Connector.CrmServiceClient -ArgumentList $connectionString

# Check if the connection was successful
if ($crmServiceClient.IsReady -eq $false) {
    Write-Error "Error connecting to Dynamics 365: $($crmServiceClient.LastCrmError)"
    return
}

# Fetch users and their roles
$query = @"
<fetch distinct="false" no-lock="true" mapping="logical">
    <entity name="systemuser">
        <attribute name="fullname" />
        <attribute name="businessunitid" />
        <attribute name="title" />
        <attribute name="systemuserid" />
        <order attribute="fullname" descending="false" />
        <link-entity name="systemuserroles" from="systemuserid" to="systemuserid">
            <link-entity name="role" from="roleid" to="roleid">
                <attribute name="name" />
            </link-entity>
        </link-entity>
    </entity>
</fetch>
"@

# Execute the fetch query
$result = $crmServiceClient.GetEntityDataByFetchSearch($query)

# Display the user access information
foreach ($record in $result) {
    $userFullName = $record["fullname"]
    $userRole = $record["role1.name"]
    Write-Output "User: $userFullName, Role: $userRole"
}
