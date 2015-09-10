public with sharing class AccountSelectClassController {
    
    //Our collection of the class/wrapper objects wrapAccount
    public List<wrapAccount> wrapAccountList {get; set;}
    public List<users__c> selectedAccounts{get;set;}
 
 
 
    public void processSelected() {
    selectedAccounts = new List<users__c>();
    list<user> lst = new list<User>();
    map<id, users__c> mapuser = new   map<id, users__c>();

 users__c obj= new Users__c();
 
        for(wrapAccount wrapAccountObj : wrapAccountList) {
        system.debug('@@@@'+wrapAccountObj );
            if(wrapAccountObj.selected == true) {
          
          mapuser.put(wrapAccountObj.acc.user__c, wrapAccountObj.acc  );
          
            }
        }
        
        
        for(user objuser :[select id, isactive from user where id in : mapuser.keyset()])
        {
            objuser.isactive= true;
            lst.add(objuser );
        }
       
        update lst;
    }
 
    // This is our wrapper/container class. In this example a wrapper class contains both the standard salesforce object Account and a Boolean value
    public class wrapAccount {
        public users__c acc {get; set;}
        public Boolean selected {get; set;}
 
        public wrapAccount(users__c a) {
            acc = a;
            selected = false;
        }
    }
    



 Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    
    public ApexPages.StandardSetController setCon {
    
    
    
    
      
        get{
            if(setCon == null){
                 size = 2;
                 string queryString = 'select id, name, End_Time__c, Start_Time__c, Status__c, User__c  from users__c ';
            if(wrapAccountList == null) {
            wrapAccountList = new List<wrapAccount>();
            for(users__c a: [select id, name, End_Time__c, Start_Time__c, Status__c, User__c  from users__c ]) {
                // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
                wrapAccountList.add(new wrapAccount(a));
                
                
             
                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
              
                noOfRecords = setCon.getResultSize();
            }
        }
        
              
            }
            return setCon;
        }set;
    }
     

    
    Public List<Users__c> getUserAccounts(){
        List<Users__c> accList = new List<Users__c>();
        for(Users__c a : (List<Users__c>)setCon.getRecords())
            accList.add(a);
        return accList;
    }
     
    public pageReference refresh() {
        setCon = null;
        getUserAccounts();
        setCon.setPageNumber(1);
        return null;
    }
     
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
  
    public void previous() {
        setCon.previous();
    }
  
    public void next() {
        setCon.next();
    }
}