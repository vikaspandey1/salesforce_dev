public class batchSchedulerClass 
{
    public void  testbatchClass()
    {
         map<id, Users__c> mapCustUsers = new map<id, Users__c>();
         
        string strquery = 'select id, User__c, end_time__c from users__c where status__c = true';
        
        Id batchInstanceId = Database.executeBatch(new UpdateLargeRecods(strquery), 5);
    
    }
    
    public set<id> calculate(list<Users__c> lstCustUsers)
    {
        Datetime DtDateTime = Datetime.now();
        String strCurrentTime = DtDateTime.format('hh:mm:ss', 'GMT');
        DateTime newDtDateTime = DtDateTime.addMinutes(10);

        
        
        
        for(sobject objCustUser : lstCustUsers)
        {
            
        }
        //mapCustUser = new map<id, Users__c>()
        return null;
    }
    
    
}