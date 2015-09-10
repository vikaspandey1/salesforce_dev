public class EncryptTriggerHandler {

  
  list<string> lstFieldName= new list<string>();
  list<string> lstFieldName1= new list<string>();
   list<sobject> setUserId = new list<sobject>();
  set<id> setId = new set<id>();
  
public void  insertRecords(list<sobject> lstsObject, string strObjName)
{
Encrypt_controller objEncrypt_controller = new Encrypt_controller();


integer i;     
 string strFieldName = [select object_FieldName__c from encrypt_Config__c where Object_Name__c =: strObjName].object_FieldName__c ;

lstFieldName= strfieldName.split(',');
   
 for(Sobject objSobject : lstSobject)
        {
   for(i=0; i<lstFieldName.size(); i++)
   {
   if(string.valueof(objSobject.get(lstFieldName[i])) != null )
   {
      objSobject.put(lstFieldName[i], objEncrypt_controller.encrypt1(string.valueof(objSobject.get(lstFieldName[i])).trim() ) );
        
   }
   
   }
 setUserId.add(objSobject);

        }


}  


 
public void  updateRecords(list<sobject> lstsObject, list<sobject> OldlstsObject, string strObjName)
{
Encrypt_controller objEncrypt_controller = new Encrypt_controller();

string strquery;
string strnewfield;
integer i;     
 string strFieldName = [select object_FieldName__c from encrypt_Config__c where Object_Name__c =: strObjName].object_FieldName__c ;

lstFieldName= strfieldName.split(',');
   
    for(Sobject objSobject : OldlstsObject)
    {
     
       for(i=0; i<lstFieldName.size(); i++)
       {
           if(string.valueof(objSobject.get(lstFieldName[i])) == null )
           {
           
               setId.add(objSobject.id);
                   
               strnewfield = strnewfield +','+ lstFieldName[i] ;
                    lstFieldName1.add(lstFieldName[i]);
           }
       
       }
    
    }
    
    if(strnewfield != null )
        strnewfield = strnewfield.substring(5); 
    


    for(sobject objSobject : lstsObject)
    {
        system.debug('@@@'+objSobject + setId);
        if(setId.contains(objSobject.id))
        {
            for(i=0; i<lstFieldName1.size(); i++)
            {
                if(string.valueof(objSobject.get(lstFieldName1[i])) != null )
                    objSobject.put(lstFieldName1[i], objEncrypt_controller.encrypt1(string.valueof(objSobject.get(lstFieldName1[i])).trim() ) );
            }
        }
    }
}
  
  
  
 /* 
public static void  getrecords(list<sobject> lstsObject, string strObjName)
{
    
    
    set<id> setId= new set<id>();
    
    
     for(Sobject objSobject : lstsObject)
        {
  
    setId.add(objSobject.id);
        
   }
    
    string  strQuery ;
      string strFieldName = [select object_FieldName__c from encrypt_Config__c where Object_Name__c =: strObjName].object_FieldName__c ;

    if(strFieldName != null)
    {
        strQuery = 'Select '+ strFieldName  +' from '+ strObjName + ' where id in : setId';
        Id batchInstanceId = Database.executeBatch(new Encrytion_BatchClassHelper (strQuery,strFieldName  , strObjName, setId),4);
    }
                     
}
*/
}