trigger updateorderamount on Order_Item__c (after insert, after update, before insert, before update)
{
    Order_Item__c obj = trigger.new[0];
    
    list<Order_Item__c> lst = new list<Order_Item__c>();
    
    if(Trigger.Isafter)
    {
        decimal TotalAmount =0;
                
        lst = [select Cost_Price__c from Order_Item__c where Order__c=:obj.Order__c];

        for(Order_Item__c lst1 :lst)
        { 
            TotalAmount = TotalAmount + lst1.Cost_Price__c;
        }
        
        Order__c order= [select Order_Amount__c  from  Order__c where id=:obj.Order__c];
        
        Order.Order_Amount__c = TotalAmount;    
        Update Order;
    }
    
    if(Trigger.IsBefore)
    {
        lst = [select Quantity__c from Order_Item__c where Product__c=:obj.product__c];
        Product__c Prod = [select Order_Quantity__c,Stock_Quantity__c from Product__c where id=:obj.product__c];
        
        Decimal TotalOrderQty = 0 ;
            
        //for(Order_Item__c lst1 :lst)
        //{ 
            //TotalOrderQty = TotalOrderQty + lst1.Quantity__c;
        //} 
        
        if(Trigger.Isupdate)
        {
            Order_Item__c objold = trigger.old[0];

            TotalOrderQty = Prod.Stock_Quantity__c + objold.quantity__c - obj.quantity__c;
        }
        else if(Trigger.Isinsert)
        {
            TotalOrderQty = Prod.Stock_Quantity__c - obj.quantity__c;
        }
                
        
        if(TotalOrderQty < 0 )
        {
            obj.adderror('These many items are not available in warehouse');
        }
                
    }
}