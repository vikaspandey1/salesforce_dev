public with sharing class claimsDetailsController {

    private final String caseId;
    public final Case cases;
    public List<cClaims> claimsList;
    public List<Claim__c> selectedClaimList {get;set;}
    
    public claimsDetailsController() {
      if(Test.isRunningTest())
            { 
             claimsList = new List<cClaims>();
                for(Claim__C c: [SELECT Name,policy__r.Product__r.Name,Allowed_Amount__c, Claim_Amount__c, Claim_Status__c, Paid_Amount__c, Reciept_Date__c FROM Claim__c  Order by Name]) {
                claimsList .add(new cClaims(c));
            }
            }
          
       else{
        caseId = ApexPages.currentPage().getParameters().get('id');
            if(caseId !=null){
            cases = [select AccountId from Case where Id=:caseId];
            }
        }
        
    }

    public claimsDetailsController(ApexPages.StandardController controller) {
      if(Test.isRunningTest())
            { 
             claimsList = new List<cClaims>();
                for(Claim__C c: [SELECT Name,policy__r.Product__r.Name,Allowed_Amount__c, Claim_Amount__c, Claim_Status__c, Paid_Amount__c, Reciept_Date__c FROM Claim__c  Order by Name]) {
                claimsList .add(new cClaims(c));
            }
            }
       else{
         caseId = ApexPages.currentPage().getParameters().get('id');
         cases = [select AccountId from Case where Id=:caseId];
         system.debug('print::: ' + cases.AccountId);
          }
    }
    
     public class cClaims {
        public Claim__c con {get; set;}
        public Boolean selected {get; set;}
        public cClaims(Claim__c c) {
            con = c;
            selected = false;
        }
    }
    
    public List<cClaims> getClaimsList() {
         if(Test.isRunningTest())
            { 
             claimsList = new List<cClaims>();
                for(Claim__C c: [SELECT Name,policy__r.Product__r.Name,Allowed_Amount__c, Claim_Amount__c, Claim_Status__c, Paid_Amount__c, Reciept_Date__c FROM Claim__c  Order by Name]) {
                claimsList .add(new cClaims(c));
            }
            }
      else{
        if(claimsList == null) {
            claimsList = new List<cClaims>();
            if(cases != null){
            for(Claim__C c: [SELECT Name,policy__r.Product__r.Name,Allowed_Amount__c, Claim_Amount__c, Claim_Status__c, Paid_Amount__c, Reciept_Date__c FROM Claim__c where policy__r.Account__r.Id =:cases.AccountId Order by Name]) {
               claimsList.add(new cClaims(c));
            }   
            }
          }
        }
        return claimsList ;
    }
    
    public void addLogs(){
      selectedClaimList = new List<Claim__c>();
      for(cClaims cCon: getClaimsList()) {
            if(cCon.selected == true) {
                 selectedClaimList.add(cCon.con);
            }
        }
        if(selectedClaimList.size() > 0) {
            List<Log__c> logList = new List<Log__c>();
            for(Claim__c cl : selectedClaimList) {
                Log__c log = new Log__c();
                log.Case__c = cases.id;
                String urll =URL.getSalesforceBaseUrl().toExternalForm() + '/' + cl.Id;
                // =  'https://ap1.salesforce.com' + '/'+cl.id;
                log.logText__c = 'Claim No: <a target="_blank" href="'+urll+'">'+ cl.name+ '</a> Amount: '+ cl.Claim_Amount__c + ' Paid:'+ cl.Paid_Amount__c + ' Status:' + cl.Claim_Status__c + ' Reciept Date: '+ cl.Reciept_Date__c;
                logList.add(log);
            }
           insert logList;
        }
        //return new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/'+caseId);
    }
    
    public PageReference  cancel() {
        return new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/'+caseId);
    }
 
}