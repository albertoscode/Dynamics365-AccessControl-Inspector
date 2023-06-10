# Dynamics 365 User Access Inspector

This PowerShell script interacts with the Dynamics 365 web services and retrieves user access information, such as roles. It uses the `Microsoft.Xrm.Tooling.Connector` library to connect to Dynamics 365 and execute FetchXML queries.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Version Compatibility](#version-compatibility)
3. [Script](#script)
4. [Usage](#usage)
5. [License](#license)
6. [Contribution](#contribution)
7. [References](#references)
8. [Contact](#contact)

## Prerequisites <a name="prerequisites"></a>

Before you begin, ensure you have the following installed on your machine:

- [Dynamics 365 SDK](https://docs.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/download-tools-nuget)
- PowerShell

Also, you will need access to a Dynamics 365 environment with an account that has sufficient privileges to view user roles and access controls.

[Back to top](#dynamics-365-user-access-inspector)

## Version Compatibility <a name="version-compatibility"></a>

This script has been tested and is known to work with Dynamics 365 versions 9.0 and above. Please note that if you are using an older version, the script may not function as expected due to differences in the available web services and the data structure in Dynamics 365.

[Back to top](#dynamics-365-user-access-inspector)

## Script <a name="script"></a>

```powershell
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
```

[Back to top](#dynamics-365-user-access-inspector)

## Usage <a name="usage"></a>

First, update the

 following line in the PowerShell script with your Dynamics 365 connection string:

```powershell
$connectionString = "AuthType=OAuth;Username=yourusername@yourdomain.com; Password=yourpassword;Url=https://yourorg.crm.dynamics.com;AppId=yourappid; RedirectUri=yourappredirecturi;"
```

Replace the placeholders with your actual Dynamics 365 credentials, URL, AppId, and RedirectUri.

Once the connection string is set, you can run the script using PowerShell:

```powershell
.\UserAccessInspector.ps1
```

The script will connect to Dynamics 365, retrieve users and their associated roles, and display the results in the console. The script can be further customized to filter users, export the results, or perform additional analysis as needed.

[Back to top](#dynamics-365-user-access-inspector)

## License <a name="license"></a>

This project is licensed under the MIT License.

[Back to top](#dynamics-365-user-access-inspector)

## Contribution <a name="contribution"></a>

Contributions are welcome! Please feel free to submit a Pull Request.

[Back to top](#dynamics-365-user-access-inspector)

## References <a name="references"></a>

1. [Dynamics 365 SDK Documentation](https://docs.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/download-tools-nuget)
2. [Microsoft.Xrm.Tooling.Connector Library](https://docs.microsoft.com/en-us/dotnet/api/microsoft.xrm.tooling.connector.crmserviceclient?view=dynamics-general-ce-9)

[Back to top](#dynamics-365-user-access-inspector)

## Contact <a name="contact"></a>

For any issues or suggestions related to this script, please contact:

- Name: Alberto F. Hernandez
- Email: ah8664383@gmail.com
- Linkedin: https://www.linkedin.com/in/albertoscode/

[Back to top](#dynamics-365-user-access-inspector)

