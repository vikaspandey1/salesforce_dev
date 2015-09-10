public class Invoice 
{
    public string OID{get;set;}
    public List<Order_item__c> productlist {get;set;}
    public Order__c Order{get;set;}    
    
    public Invoice(ApexPages.StandardController controller) 
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

    public Invoice() 
    {
        

    } 
}