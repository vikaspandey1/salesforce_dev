public class encryptController {
    
    public String state {get;set;}
    public String city {get;set;}
    public String objectval {get;set;}
    // public String[] fieldval {get;set;}
    public String fieldval {get;set;}
    //public String[] fieldval2 {get;set;}
     public List<String> fieldval2 {get;set;}
     string   updatefield;
      String[] tmpString;
      String[] tmpStringdecrypt;
     String[] tmpStringdecryptlist2;
       
     public String[] fieldval3 {get;set;}
     
    
    public boolean encryptcheck {get;set;}
    public boolean decryptcheck {get;set;}
    public boolean isdelete;
    
    
    List<SelectOption> options{get;set;}
    
    List<SelectOption> options1{get;set;}
    
    public boolean visibility{get;set;}
    public boolean visibility02{get;set;}
    public boolean visibility03{get;set;}
    public boolean visibility04{get;set;}
    public boolean visibility05{get;set;}
    
    list<encrypt_Config__c> lstnewrecords ; 
    map <string,encrypt_Config__c> mapencryold;
        map <string,encrypt_Config__c> mapdecryold;
    
    encrypt_Config__c encryptobj;
     encryptionobj__c settings= encryptionobj__c.getOrgDefaults();
     Blob seckey =  Blob.valueof(settings.key__c);
    
    
    Map<string,String> map_contact_address=new  Map<string,String>();
    Public Id ContactId;
    Public String OrgURl {get; set;}
    
    set<ID> setPropertyId = new set<ID>();
    String strContactAddress;
    
    public PageReference run() {
        
        
        getObjects();
        return null;
    }
    
    
   
    
    public List<SelectOption> getObjects()
    {
        
        if(objectval==null)
        {
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
            
            
            options=new List<SelectOption>();
            options.add(new SelectOption('---','---Select---'));
            
            for(Schema.SObjectType f : gd)
            {
                
                options.add(new SelectOption(f.getDescribe().getname(),f.getDescribe().getlabel()));
                //       system.debug('the describe name vaues are'+f.getDescribe().getname()); // inside name api name is der
                // system.debug('the describe label are'+f.getDescribe().getlabel());
                
            }
            
            visibility02=true;
        }
        return options;
        
    } 
    
    public void testfunction()
    {
        getmap_contact_address();
        
        visibility04=true;
    }
    
    
    
    public List<SelectOption> getFieldss()
    {
        system.debug('outside if'+objectval);
        if(objectval!=null)
        {
            system.debug('raj the obejct avls is if'+objectval);
            SObjectType objToken = Schema.getGlobalDescribe().get(objectval);
            DescribeSObjectResult objDef = objToken.getDescribe();
            Map<String, SObjectField> fields = objDef.fields.getMap(); 
            options1=new List<SelectOption>();
            Set<String> fieldSet = fields.keySet();
            
            options1.add(new SelectOption('---','---Select----'));
            for(String s:fieldSet)
            {
                SObjectField fieldToken = fields.get(s);
                DescribeFieldResult selectedField = fieldToken.getDescribe();
                options1.add(new SelectOption(selectedField.getname(),selectedField.getlabel()));
                
            } 
            visibility03=true;
           
        }
        
        return options1;
    }   
    
    
    public List<SelectOption> getFieldss2()
    {
        system.debug('outside if'+objectval);
        if(objectval!=null)
        {
            system.debug('inside if'+objectval);
            SObjectType objToken = Schema.getGlobalDescribe().get(objectval);
            DescribeSObjectResult objDef = objToken.getDescribe();
            Map<String, SObjectField> fields = objDef.fields.getMap(); 
            //Schema.getGlobalDescribe().get('ObjectName').getDescribe().fields.getMap().get('FieldName').getDescribe().getLabel();
            options1=new List<SelectOption>();
            Set<String> fieldSet = fields.keySet();
            
            options1.add(new SelectOption('---','---Select----'));
            for(String s:fieldSet)
            {
                SObjectField fieldToken = fields.get(s);
                DescribeFieldResult selectedField = fieldToken.getDescribe();
                options1.add(new SelectOption(selectedField.getname(),selectedField.getlabel()));
                
            } 
            visibility03=true;
          
            
        }
        
        return options1;
    } 
    
    
    
  
    
 
   
public void encrypt()
{
ApexPages.getMessages().clear();
encryptcheck = true ;
decryptcheck= false;

try{
       // lstnewrecords = new list<encrypt_Config__c> ();
        mapencryold = new map<string,encrypt_Config__c>();
            
        
       for (encrypt_Config__c  urs: [select id, Object_Name__c,object_FieldName__c from encrypt_Config__c   ])
        {
          // lstnewrecords.add(urs);
            mapencryold.put(urs.Object_Name__c,urs);
            
        }
           
           list<encrypt_Config__c> lstnew  = new list<encrypt_Config__c>();
            if(mapencryold.containsKey(objectval)) // logic to check if the object is already inserted 
            {
            try
            {
          
           for(encrypt_Config__c objencrypt: mapencryold.values())
           // for(encrypt_Config__c objencrypt: mapencryold.keySet())
            {
            if(objectval==objencrypt.Object_Name__c && fieldval!=null ) // for having object name and adding new fields to the encryption
            { 
             
              updatefield=objencrypt.object_FieldName__c;
             tmpString = objencrypt.object_FieldName__c.split(',');       
           for(integer i = 0; i<tmpString.size(); i++)
        {
        if(fieldval.contains(string.valueof(tmpString[i]))) // for already inserted fields check
          {

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Selected Fields '+tmpString[i]+' is already encrypted, Please select another field to encrypt'));

        // break;            
        }
       
       else 
        {
            //lstnew = new list<encrypt_Config__c>();
             objencrypt.Field_name__c = fieldval; 
         
           //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'the obje vale in else part '+ objencrypt.object_FieldName__c)); 
          
            objencrypt.EncryptionEnabled__c = encryptcheck;
          
          
          update objencrypt;
          // lstnew.add(objencrypt);
          
           // break;
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The selected field has been encrypted '));     
          
        }  
       
        }   
        // update objencrypt;             
          }        
         
         /*  these condions are not required as of now
          else if(objectval==objencrypt.Object_Name__c && fieldval==null ) // for having object name but fields are empty
          {
          objencrypt.object_FieldName__c=fieldval+';';
          lstnew.add(objencrypt);
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The selected field for encrytion was updated'));
          }
          
          else
          {
          //do nothing
          }
            */
         } 
              // condition where we have object and no fields are empty.
              
              //update lstnew;
            //update lstnew;
            }
            catch(System.DmlException e)
            {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Too many fields inserted for encryption '+e));
             system.debug('there was an exception while saving the record'+e);
            }
            
            }

else // for inserting the new encrypt objects
{
   encryptobj = new encrypt_Config__c();
   encryptobj.Object_Name__c = objectval;
   encryptobj.Field_Name__c= ','+fieldval;
   encryptobj.Field_Name__c= string.valueof(encryptobj.Field_Name__c.substring(1));
   encryptobj.EncryptionEnabled__c = encryptcheck;
  
   //lstnewrecords.add(encryptobj);
   insert encryptobj;
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The selected field was encryted'));
}
}

catch (Exception e)
{

ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The encryption application has encountered an exception please contact your system admin '+e));
system.debug('there was some error while encrypting the data'+e);
}

 visibility05=true;
}
        
     public void decrypt()
    {
        ApexPages.getMessages().clear();       
        encryptcheck = false ;
        decryptcheck= true;

       mapdecryold = new map<string,encrypt_Config__c>();
       for(encrypt_Config__c objdecryp : [select Id,Object_Name__c,object_FieldName__c,EncryptionEnabled__c from encrypt_Config__c ])
       
       {
        mapdecryold.put(objdecryp.Object_Name__c,objdecryp);
       }
                
        try
        {
           list <encrypt_Config__c> decryptobjlst = new list<encrypt_Config__c>();
           list <encrypt_Config__c> decryptobjlst2 = new list<encrypt_Config__c>();
           for(encrypt_Config__c objdecrypt: mapdecryold.values()) 
           {

           if(objdecrypt.Object_Name__c == objectval ) // removing the field names for more than one fields in record
           {

             String s1 = objdecrypt.object_FieldName__c;

        String s2 = s1.remove(fieldval);
        string s3=s2.replace(',,',',');
        String s4 =  s3.removeStart(',');
        system.debug('the after string  finally is here'+s4);
               
          objdecrypt.object_FieldName__c=  s4 ;   
           
         

                }          
             
             
             else
             {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This field is not selected for encryption , Please select another field for encryption'));
             }
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The selected field is decrypted'));
         update objdecrypt;
            } 
            
            for(encrypt_Config__c objdeldecrypt:mapdecryold.values())
        {
       if(String.isBlank(objdeldecrypt.object_FieldName__c)) 
             {          
           
           delete objdeldecrypt;
             }
             }
            
            }
           
            
        
        
        catch (Exception e)
        {
            
          //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,' there was some technical glinch in the encryption application ,Please contact your system admin to rectify the issue '+e));
        }
        
        
        visibility05=true;
    }
    
    
    
    
    
    public Map<string,string> getmap_contact_address()
    {
        system.debug('inside map'+state+city+visibility03);
        string lan ='hello';
        string query;
        string namevf = city;
        string contactvf =state;
        string id;
        system.debug('!!!!'+state+city);  
        if(state!=null && city !=null)
        {        query = 'SELECT id,'+city +' FROM '+contactvf  ;
         system.debug('@@@@'+query);}
        string test;
        integer count=0;
        for( sobject ojb :Database.query(query))
        {
            if(string.valueof(ojb.get(city))!=null)
            {
                map_contact_address.put(ojb.id,string.valueof(ojb.get(city)));
            }
            system.debug('selectedField#####'+ojb.id);
            
        }
        
        
        OrgURl = System.Url.getSalesforceBaseUrl().toExternalForm();    
        
        return map_contact_address;
    }
    
    
    
}