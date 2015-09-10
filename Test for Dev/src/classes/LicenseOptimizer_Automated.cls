public with sharing class LicenseOptimizer_Automated
{
    public LicenseOptimizer_Automated ()
    {
      
    }
    public void LicenseOptimizer()
    {
    string strQuery = 'Select id, End_Time__c, user__c from  users__c';
    Id batchInstanceId = Database.executeBatch(new LicenseOptimizer_BatchClass(strQuery ),150);
    }
    
}