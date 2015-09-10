trigger updateshippingaddress on Order__c (before insert,before update) 
{
    order__c obj = trigger.new[0];
    if (obj.Same_as_billing_address__c) 
    { 
        obj.Shipping_Postal_Code__c = obj.Billing_Postal_Code__c ;
        obj.Shipping_State__c = obj.Billing_State__c;
        obj.Shipping_Street_Address__c = obj.Billing_Street_Address__c;
        obj.Shipping_City__c = obj.billing_City__c;
        obj.Shipping_Country__c = obj.Billing_Country__c;
    }
    
    if(obj.Tracking_Number__c != null)
        obj.Order_Status__c= 'Shipped';    
    if(obj.Order_Received_Date__c != null)
        obj.Order_Status__c= 'Completed';    

}