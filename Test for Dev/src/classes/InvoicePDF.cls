public class InvoicePDF 
{
    public string OID{get;set;}
    public List<Order_item__c> productlist {get;set;}
    public Order__c Order{get;set;}    
    
    public InvoicePDF(ApexPages.StandardController controller) 
    {
        Order = new Order__c();
        productlist = new List<Order_Item__c>();
                        
        if(ApexPages.currentPage().getParameters().get('ID') != null)
        {
            OID = ApexPages.currentPage().getParameters().get('ID'); 
             
            Order = [select id, Order_Amount_Text__c,name,First_Name__c,Last_name__c,Order_Date__c,Billing_Street_Address__c,Billing_Postal_Code__c,Billing_City__c
                         ,Shipping_Street_Address__c, Shipping_Postal_Code__c,Shipping_City__c from Order__c where id=:OID limit 1];
             
            productlist =[select id,Product__r.name,Quantity__c,Price__c,Cost_Price__c from order_item__c where order__c =:OID];                         
        }
    }

    public InvoicePDF () 
    {
        

    } 
    
    public PageReference attachinvoice()
    {
        List<Attachment> delatt = [select id from Attachment where parentID=:OID];
        
        if(delatt.size()>0)        
        {
            delete delatt;
        }
         
        Attachment att = new Attachment(name ='Invoice.pdf');
        PageReference invoicePage = Page.Order_Invoice;
        invoicePage .getParameters().put('ID',OID);
        att.body = invoicePage.getContent();
        att.parentid = OID;
        insert att;
        
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        PageReference pdf =  Page.Order_Invoice;
        pdf.getParameters().put('ID',OID); 
        pdf.setRedirect(true);
        Blob b = pdf.getContent();

        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Invoice.pdf');
        efa.setBody(b);        
        String[] toAddresses = new String[]{'naman.kher@gmail.com'};
        String[] ccAddresses = new String[] {'shailendra_jain@syntelinc.com'};        
        email.setSubject('Order Confirmation');
        email.setToAddresses( toAddresses );
        email.setCcAddresses(ccAddresses);        
        email.setPlainTextBody('Order has been placed on your behalf in ABC corporation, please find the details attached');

        /*EmailTemplate et=[Select id from EmailTemplate where name=:'OrderDetail'];
        email.setTargetObjectId(UserInfo.getuserid());
        email.setSenderDisplayName('Name Kher');
        email.setTemplateId(et.id);
        //email.setWhatId(OID);
        email.setSaveAsActivity(false);
        */
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});           
        return invoicePage ;
    }   
}