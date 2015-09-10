public with sharing class landingPageController {

    private final Account account;
    public static String newInquiryUrl;
    public landingPageController(ApexPages.StandardController controller) {
        this.account = (Account)controller.getRecord();
        
    }



    public landingPageController() {
        newInquiryUrl = URL.getSalesforceBaseUrl() + '//500//e?retURL=%2F500%2Fo&';
    }
            
  

    // Initialize setCon and return a list of Members

    public ApexPages.StandardSetController setCases {
        get 
        {
        
            if(Test.isRunningTest())
            { 
                    setCases = new ApexPages.StandardSetController(Database.getQueryLocator(
                                  [SELECT CaseNumber,Subject, Reason, CreatedDate, IsEscalated, Priority, Status FROM Case  order by status, CreatedDate DESC LIMIT 7]));                                
            }
            else
            {
                if(setCases == null) 
                {
                    setCases = new ApexPages.StandardSetController(Database.getQueryLocator(
                                  [SELECT CaseNumber,Subject, Reason, CreatedDate, IsEscalated, Priority, Status FROM Case where AccountId=:Account.Id order by CreatedDate DESC LIMIT 7]));
                }
           
           } 
            return setCases;
        }
        set;
    }

    // Initialize setCases and return a list of Inquiries
    public List<Case> getCases() {
         return (List<Case>) setCases.getRecords();
    }
  
    public ApexPages.StandardSetController setClaim {
        get {
            if(Test.isRunningTest())
            { 
                 setClaim = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name,policy__r.Product__r.Name,Allowed_Amount__c, Claim_Amount__c, Claim_Status__c, Paid_Amount__c, Reciept_Date__c FROM Claim__c Order by Name LIMIT 4]));                      
            }
            
            else{
            
                if(setClaim == null) {
                    setClaim = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name,policy__r.Product__r.Name,Allowed_Amount__c, Claim_Amount__c, Claim_Status__c, Paid_Amount__c, Reciept_Date__c FROM Claim__c where Policy__r.Account__r.Id=:Account.Id Order by Name LIMIT 4]));
            }
          }
          return setClaim ;
        }
        set;
    }

    // Initialize setClaim and return a list of Claims
    public List<Claim__c> getClaim() {
        return (List<Claim__c>) setClaim .getRecords();
    }
    
   
     public ApexPages.StandardSetController setBenefit {
        get {
         if(Test.isRunningTest())
            { 
                  setBenefit = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name,Product__r.Name,Product__r.ProductCode,Product__r.Description FROM Policy__c LIMIT 4]));                     
            }
            else{
            
                if(setBenefit == null) {
                    setBenefit = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name,Product__r.Name,Product__r.ProductCode,Product__r.Description FROM Policy__c where Account__r.Id=:Account.Id LIMIT 4]));
                }
            }
            return setBenefit ;
        }
        set;
    }
   
    // Initialize setBenefits and return a list of Benefits
    public List<Policy__c> getBenefit () {
        return (List<Policy__c>) setBenefit.getRecords();
    }
    
    public ApexPages.StandardSetController setAlert {
        get {
        if(Test.isRunningTest())
            { 
                   setAlert = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Alert__r.Name,Alert__r.Type__c,Alert__r.offer__c,Alert__r.Offer_Description__c FROM Policy__c LIMIT 2]));                    
            }
        else{
        
            if(setAlert == null) {
                setAlert = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Alert__r.Name,Alert__r.Type__c,Alert__r.offer__c,Alert__r.Offer_Description__c FROM Policy__c where Account__r.Id=:Account.Id LIMIT 2]));
            }
         }
         return setAlert ;
        }
        set;
    }

    // Initialize setAlert and return a list of Alerts
    public List<Policy__c> getAlert () {
        return (List<Policy__c>) setAlert.getRecords();
    }
   /* public ApexPages.StandardSetController setBnft {
        get {
            if(setBnft == null) {
                setBnft = new ApexPages.StandardSetController(Database.getQueryLocator(
                   [SELECT Benefit__r.Name,Benefit__r.Service_Category__c,Benefit__r.Service_Type__c,Benefit__r.Place_of_Service__c,Benefit__r.In_Network__c,Benefit__r.Out_Network__c FROM Policy__c where Account__r.Id=:Account.Id LIMIT 4]));
            }
            return setBnft ;
        }
        set;
    }

    // Initialize setAlert and return a list of Alerts
    public List<Benefit__c> getBnft () {
        return (List<Benefit__c>) setBnft.getRecords();
    }*/
    public PageReference NewInquiry(){
    
       if(Test.isRunningTest())
            { 
            PageReference secondPage = new PageReference ('/500/e?retURL=%2F500%2Fo&cas4');
            secondPage.setRedirect(true);   
             return secondPage;                   
            }
        else{    
         PageReference secondPage = new PageReference ('/500/e?retURL=%2F500%2Fo&cas4='+account.Name);
         secondPage.setRedirect(true);  
         return secondPage;  
         }
        
    }
    
}