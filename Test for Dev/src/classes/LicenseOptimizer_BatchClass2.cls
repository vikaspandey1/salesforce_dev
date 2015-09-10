global class LicenseOptimizer_BatchClass2 implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    global final String StrQuery;
 
    set<id> setUserId = new set<id>();
    
   
 global LicenseOptimizer_BatchClass2()
    {
        StrQuery = 'Select id, End_Time__c, user__c from  users__c';
    }

   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(StrQuery);
    }
    
    
    
    
    global void execute(Database.BatchableContext BC, List<sObject> lstSobject){

    LicenseOptimizer_HelperClass objHelper = new LicenseOptimizer_HelperClass();

        for(Sobject objSobject : lstSobject)
        {
            setUserId.add(objSobject.id);
        }

        objHelper.CheckTime(setUserId);
    }
    global void finish(Database.BatchableContext BC){
    }
}