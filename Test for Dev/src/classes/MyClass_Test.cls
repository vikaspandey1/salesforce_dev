global class MyClass_Test {
    webservice static void myMethod( string s){
        System.debug('I am excuting via javascript');
    }
    webService static Id makeContact(String lastName, Account a) { 
        Contact c = new Contact(LastName = lastName, AccountId = a.Id); 
        return c.id; 
    }
    webService static String getContextUserName() {
        return UserInfo.getFirstName();
    }

      
    
}