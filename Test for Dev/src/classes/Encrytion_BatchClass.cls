global class Encrytion_BatchClass implements Database.Batchable<sObject> , Database.stateful{
    
    global final String StrQuery;
 
    list<sobject> setUserId = new list<sobject>();
    list<string> lstFieldName= new list<string>();
    global final String strfieldName ;
    global final String strObjectName;
    
  
 global Encrytion_BatchClass(String qrry, string fieldName, string strObjectName)
    {
        StrQuery = qrry;
        strfieldName = fieldName;
        this.strObjectName = strObjectName;
    }


  
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(StrQuery);
    }
    
    
    
    
    global void execute(Database.BatchableContext BC, List<sObject> lstSobject){
   
    Encrypt_controller objEncrypt_controller = new Encrypt_controller();
    staticFun.runME = false;
    integer i;
    
    lstFieldName= strfieldName.split(',');
   system.debug('@@@@'+lstFieldName);

 for(Sobject objSobject : lstSobject)
        {
   for(i=0; i<lstFieldName.size(); i++)
   {
   if(string.valueof(objSobject.get(lstFieldName[i])) != null )
   {
  
     //  objSobject.put(lstFieldName[i], objEncrypt_controller.decrypt1(string.valueof(objSobject.get(lstFieldName[i])) ) ); 
       
       objSobject.put(lstFieldName[i], objEncrypt_controller.encrypt1(string.valueof(objSobject.get(lstFieldName[i])) ) );
        
   }
   
   }
 setUserId.add(objSobject);
 system.debug('all userids are'+setUserId);
        }
      
update setUserId;
    
    }
    global void finish(Database.BatchableContext BC){
    staticFun.runME = false;
    for(encrypt_Config__c objEncypt : [select object_FieldName__c,  Field_Name__c  from  encrypt_Config__c  where Object_Name__c =: strObjectName ])
    {
    
    if(objEncypt.object_FieldName__c != null)
        objEncypt.object_FieldName__c = objEncypt.object_FieldName__c +','+ objEncypt.Field_Name__c ;
    else
        objEncypt.object_FieldName__c = objEncypt.Field_Name__c ;
    objEncypt.Field_Name__c = '';
    objEncypt.EncryptionEnabled__c = true;
    
    update objEncypt;
    }
    /*
    encrypt_Config__c objencrypt= [select id,EncryptionEnabled__c from encrypt_Config__c  where Field_Name__c != null ];
    
    objencrypt.EncryptionEnabled__c = true;
    
    update objencrypt;
    */
    }
}