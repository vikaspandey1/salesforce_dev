global class LicenseOptimizer_BatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful, Schedulable{
    
    global final String StrQuery;
 
    set<id> setUserId = new set<id>();
    
    
     global LicenseOptimizer_BatchClass()
    {
        StrQuery = 'Select id, End_Time__c, user__c from  users__c';
    }

 global LicenseOptimizer_BatchClass(String qrry)
    {
        StrQuery = 'Select id, End_Time__c, user__c from  users__c';
    }


    global void execute(SchedulableContext sc) {
  
  
      LicenseOptimizer_BatchClass pa= new LicenseOptimizer_BatchClass();
   // string cronStr = '0 5 * * * ?';
//    System.schedule('Process Accs Job', cronStr, pa);
      database.executebatch(pa);
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
//if(!test.isRunningTest())
        objHelper.CheckTime(setUserId);
    }
    global void finish(Database.BatchableContext BC){
    }
}