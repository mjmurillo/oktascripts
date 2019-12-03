# We do this so we only have to query the Okta user information once
$okta_users = (oktaListUsers -oOrg prod)

# Requirements: the Okta PSModule from https://github.com/mbegan/Okta-PSModule

# Get list of all users assigned in group. Group ID can be found by copy/paste the string of a group via the OKTA GUI
$group = oktaGetGroupMembersbyId -oOrg prod -gid enterGroupIDhere | where { $_.status -eq "ACTIVE" }

$group | % {
    $okta_id = $_.id
    # Retrieve the user profile for the user assigned to Briefing source against the list of Okta users
    $profile = $okta_users | where { $_.id -eq $okta_id }
    [PSCustomObject]@{
        Email = $profile.profile.login
        FirstName = $profile.profile.firstName
        LastName = $profile.profile.lastName
        Title = $profile.profile.title
        Manager = $profile.profile.manager
        Created = $profile.created
        Activated = $profile.activated
        CostCenterName = $profile.profile.cost_center_name
        Department = $profile.profile.department
    }
#export groupsmemeber with attributes
} | export-csv groupmemebership.csv