public class EncryptExtension {
    public encrypttobj__c encrypt{get;set;}
    //Blob cryptoKey;
//    Blob cryptoKey = Blob.valueOf('380db410e8b11fa9');
    Blob cryptoKey = Crypto.generateAesKey(128);
    public Id recordId{get;set;}
    public EncryptExtension(ApexPages.StandardController controller) {
        //cryptoKey = Crypto.generateAesKey(256);
        recordId = Apexpages.CurrentPage().getParameters().get('id');
        if(recordId !=null){
            encrypt = [SELECT id,name__c,Date_ofBirth__c,Email__c,Phone_number__c,  SSN__c From encrypttobj__c 
                    WHERE id=:recordId];
        }
        else{
            encrypt = new encrypttobj__c();
        }
    }
    
    public PageReference encrypt1(){
         
         Blob data = Blob.valueOf(encrypt.name__c);
         Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , data );
         String b64Data = EncodingUtil.base64Encode(encryptedData);
         encrypt.name__c = b64Data ;
         
         insert encrypt;
         return null; 
    }
    public PageReference decrypt1(){
         
         //Blob cryptoKey = Crypto.generateAesKey(256);
         //Blob data = Blob.valueOf(encrypt.Name);
         Blob data = EncodingUtil.base64Decode(encrypt.name__c);
         Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey , data);
         String dryptData = decryptedData.toString();
         System.debug('Printing dryptData '+dryptData);
         
         encrypt.name__c = dryptData;
         
         update encrypt;
         return null; 
    }
}