# Import the Dynamics 365 Connector
try {
    # This is required to interact with Dynamics 365
    Add-Type -Path "C:\path\to\Microsoft.Xrm.Tooling.Connector.dll"
} catch {
    Write-Error "Error loading Microsoft.Xrm.Tooling.Connector.dll: $_"
    return
}

# Get Dynamics 365 credentials
# We prompt for credentials to avoid having to hardcode the password
$cred = Get-Credential

# Dynamics 365 connection string
# AppId and RedirectUri are required for OAuth authentication
$connectionString = "AuthType=OAuth; Username=$($cred.UserName); Password=$($cred.GetNetworkCredential().Password); Url=https://yourorg.crm.dynamics.com; AppId=yourappid; RedirectUri=yourappredirecturi;"

# Create a new CrmServiceClient
$crmServiceClient = New-Object -TypeName Microsoft.Xrm.Tooling.Connector.CrmServiceClient -ArgumentList $connectionString

# Check if the connection was successful
if ($crmServiceClient.IsReady -eq $false) {
    Write-Error "Error connecting to Dynamics 365: $($crmServiceClient.LastCrmError)"
    return
}

# Fetch users and their roles
# This query fetches the full name, business unit ID, title, and system user ID for all users, along with their roles
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
try {
    # This attempts to fetch the user data based on the query
    $result = $crmServiceClient.GetEntityDataByFetchSearch($query)
} catch {
    Write-Error "Error executing fetch query: $_"
    return
}

# Display the user access information
# This goes through each record in the result and outputs the user's name and role
foreach ($record in $result) {
    $userFullName = $record["fullname"]
    $userRole = $record["role1.name"]
    Write-Output "User: $userFullName, Role: $userRole"
}