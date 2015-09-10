public class Encrypt_controller{
    
   encryptionobj__c settings= encryptionobj__c.getOrgDefaults();
   Blob seckey =  Blob.valueof(settings.key__c);


  
    public string encrypt1(string value){
       
 
       Blob stringencry = Blob.valueOf(value);
       Blob encrypted = Crypto.encryptWithManagedIV('AES256', seckey,stringencry);       
      //String bly = encrypted.toString();
      String b64=EncodingUtil.base64Encode(encrypted);
       
        
         return b64; 
    }
    public string decrypt1(string value){
         
       
         Blob data = EncodingUtil.base64Decode(value);
         
         
         Blob decryptedData = Crypto.decryptWithManagedIV('AES256', seckey , data);
         String dryptData = decryptedData.toString();
         
         
        
         return dryptData ; 
    }
}