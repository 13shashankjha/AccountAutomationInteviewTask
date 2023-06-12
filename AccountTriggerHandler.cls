public class AccountTriggerHandler {
    public void checkActiveCriteria(List<Account> newaccList, Map<Id,Account> newAccountMap){
        for(Account a : newaccList){
            //Can alse be done by validation rule
            if(a.Active__c == true && (a.AccountActivationSummary__c == null || a.AccountActivationSummary__c == '')){
                a.addError('Account Activation Summary is required while activating account');
            }
        }
    }
    
    public void createDefaultContact(List<Account> newaccList, Map<Id,Account> newAccountMap){
        List<Contact> conList = new List<Contact>();
        List<Contact> allContacts = [Select id,accountId,lastname from contact where accountId in :newAccList];
        Map<Id,List<Contact>> accMap = new Map<Id,List<Contact>>();
        for(contact con : allContacts){
            if(accMap.get(con.AccountId) == null){
                List<Contact> conList2 = new List<Contact>();
                conList2.add(con);
                accMap.put(con.AccountId,conList2);
            }
            else{
                accMap.get(con.AccountId).add(con);
            }
        }
        for(Account a : newaccList){
            if(a.Active__c == true && a.Type == 'Customer - Direct' && accMap.get(a.id)==null){
                Contact con = new Contact();
                con.FirstName = a.Name;
                con.LastName = 'Customer Representative';
                con.AccountId = a.Id;
                con.Email = a.CompanyEmail__c;
                con.Phone = a.Phone;
                conList.add(con);
            }
        }
        Database.insert(conList,false);
    }
}