public without sharing class CommunityUserCreator {			
    @AuraEnabled
    public static Boolean CommunityUserCreator(List<String> accountIdsList) {
		List<String> communityUserIDs = new List<String>();
		List<Account> accounts = getAccounts(accountIdsList);		
		List<Contact> contacts = getContacts(accountIdsList);
		List<Profile> communityUsersProfile = getCommunityProfile();
		try {
			if (accounts.isEmpty()) {
				return false;
            }
            else{
				Account relatedAccount = accounts.get(0);
					Contact relatedContact = contacts.get(0);
					Profile communityUserProfile = communityUsersProfile.get(0);
					User communityUser = new User();
					communityUser.FirstName = relatedAccount.FirstName;
					communityUser.LastName = relatedAccount.LastName;
					communityUser.Email = relatedAccount.PersonEmail;
					communityUser.Username = relatedAccount.PersonEmail;
					communityUser.ProfileId = communityUserProfile.Id;
					communityUser.CommunityNickname = generateUniqueAlias(relatedAccount.LastName);
					communityUser.Alias = generateUniqueAlias(relatedAccount.LastName);
					communityUser.TimeZoneSidKey = 'Europe/Amsterdam';
					communityUser.LocaleSidKey = 'nl_NL';
					communityUser.EmailEncodingKey = 'UTF-8';
					communityUser.LanguageLocaleKey = 'nl_NL';
					communityUser.ContactId = relatedContact.Id;
					insert communityUser;
				    return true;
			}
		} catch (Exception e) {
				    return false;
		}
	}
	// Function to generate a unique alias
	public static String generateUniqueAlias(String lastName) {
    String baseAlias = lastName.toLowerCase().substring(0, Math.min(8, lastName.length()));
    String uniqueAlias = baseAlias;
    Integer suffix = 1;

    // Check if the alias already exists
    	while ([SELECT COUNT() FROM User WHERE CommunityNickname = :uniqueAlias] > 0) {
        	uniqueAlias = baseAlias + String.valueOf(suffix);
        	suffix++;
    	}
    	return uniqueAlias;
	}

	public static List<Account> getAccounts(List<String> accountIdsList) {
        return [
            SELECT  Id, FirstName, LastName, PersonEmail
            FROM Account
            WHERE ID IN :accountIdsList
        ];
    }
	public static List<Contact> getContacts(List<String> accountIdsList) {
        return [
            SELECT  Id, FirstName, LastName,AccountId
            FROM Contact
            WHERE AccountId IN :accountIdsList
        ];
    }
	public static List<Profile> getCommunityProfile() {
        return [
            SELECT Id, Name FROM Profile WHERE Name = 'Volkteq Community User'
        ];
    }
}