# Specify the AD user samAccountNames to compare
$user1samAccount = "user1" # Refernce user
$user2samAccount = "user2" # Differrence user

# Extract the AD group membership for each users
$user1Groups = (Get-ADPrincipalGroupMembership -Identity (Get-ADUser -Identity $user1samAccount)).Name
$user2Groups = (Get-ADPrincipalGroupMembership -Identity (Get-ADUser -Identity $user2samAccount)).Name

# Compare both users and display which of the two users are its members
Compare-Object -ReferenceObject $user1Groups -DifferenceObject $user2Groups -IncludeEqual | Select-Object `
    @{n="ADGroupname";e={$_.InputObject}}, 
    @{n="ComparedMembers";e={
            If ($_.SideIndicator -eq "==") {
                "$($user1samAccount), $($user2samAccount)"
            } ElseIf ($_.SideIndicator -eq "<=") {
                $user1samAccount
            } Else {
                $user2samAccount
            }
        }
    },
    @{n="GroupDescription";e={
            (Get-ADGroup -Identity $_.InputObject -Properties Description).Description
        }
    }


# List Groups and Description of a user
Get-ADPrincipalGroupMembership -Identity (Get-ADUser -Identity $user1samAccount)n`
    | Get-ADGroup -Properties Description `
    | Select-Object Name, Description