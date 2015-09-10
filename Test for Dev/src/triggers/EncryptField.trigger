trigger EncryptField on Account (before insert, before update) 
{

if(staticFun.runME  == true)
{
    EncryptTriggerHandler objEncryptTriggerHandler  = new EncryptTriggerHandler ();
    
    string strQuery;
     
    if(trigger.isinsert)
    {
     objEncryptTriggerHandler.insertRecords(trigger.new, 'account');
    }
    
    if(trigger.isupdate)
    {
     objEncryptTriggerHandler.updateRecords(trigger.new, trigger.old, 'account');
    }
}    
}