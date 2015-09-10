trigger BatchTrigger on encrypt_Config__c (after insert,after update)
{

string strQuery;
staticFun.runME = false;
if(trigger.isinsert)
{
    for(encrypt_Config__c objEncypt : trigger.new)
    {
       if(objEncypt.Field_Name__c != null)
        {
            strQuery = 'Select '+ objEncypt.Field_Name__c +' from '+ objEncypt.Object_Name__c;
            Id batchInstanceId = Database.executeBatch(new Encrytion_BatchClass(strQuery,objEncypt.Field_Name__c, objEncypt.Object_Name__c),4);
        }
     }
}


if(trigger.isupdate)
{
    for(encrypt_Config__c objEncypt : trigger.new)
    {
       if(  (trigger.oldmap.get(objEncypt.id).Field_Name__c != objEncypt.Field_Name__c )  &&
             objEncypt.Field_Name__c != null)
        {
            strQuery = 'Select '+ objEncypt.Field_Name__c +' from '+ objEncypt.Object_Name__c;
            Id batchInstanceId = Database.executeBatch(new Encrytion_BatchClass(strQuery,objEncypt.Field_Name__c, objEncypt.Object_Name__c),4);
        }
     }
}


   
}