Public Class EncryptmergepageController{

    public EncryptmergepageController(ApexPages.StandardController controller) {

    mapObj = new Map<string,String>();
        
        show = false;
       
   
    }

    
    public Map<string,string> mapObj{get;set;}
    public boolean show {get;set;}
    public string text{get;set;}
    list<string> lstFieldName= new list<string>();

    
   
string idRecord;
string strObjectName;   
string strQuery ;
integer i;

    public void showData()
    {
    show = true;


idRecord = ApexPages.currentPage().getParameters().get('id');
 

String keyCode  = idRecord.subString(0,3);

Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
for(Schema.SObjectType objectInstance : gd.values())
{
if(objectInstance.getDescribe().getKeyPrefix() == keyCode)
{//do your processing with the API name what you want

strObjectName = string.valueof(objectInstance.getDescribe().getName());

}
}

encrypt_Config__c objencrypt = [select object_FieldName__c, Object_Name__c from encrypt_Config__c where Object_Name__c =: strObjectName ];

 lstFieldName= objencrypt.object_FieldName__c.split(',');
 
strquery = 'select '+objencrypt.object_FieldName__c +' from '+ objencrypt.Object_Name__c + ' where id =: idRecord ';

text = strquery ;


 Encrypt_controller objEncrypt_controller = new Encrypt_controller();
for(sobject objSobject: database.query(strquery))
{
for(i=0; i<lstFieldName.size(); i++)
   {
   if(string.valueof(objSobject.get(lstFieldName[i])) != null )
   {
  text = string.valueof(objSobject.get(lstFieldName[i])) ;
      mapObj.put(lstFieldName[i], objEncrypt_controller.decrypt1(string.valueof(objSobject.get(lstFieldName[i])) ) ); 
       
    
        
   }
   
   }
 
        }


    
    


    
    }
    
   
    
}