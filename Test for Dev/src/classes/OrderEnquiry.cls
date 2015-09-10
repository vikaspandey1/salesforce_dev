public class OrderEnquiry
{

    public String Order { get; set; }
    public string OrderNumber{get;set;}
    public string FirstName{get;set;}
    public string Email{get;set;}
    public List<Order__c> orderlist{get;set;}
    public boolean bDisplay{get;set;}

    public OrderEnquiry()
    {
        bDisplay = false;
    }


    public void SearchOrder()
    {
        orderlist = new List<Order__c>();
        bDisplay = false;
        
        string TempFirstName = '';
        string TempEmail= '';
        


    if(OrderNumber == '' && FirstName == ''  && Email =='')
    {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Order Number , Customer Name or Email to search the orders.');
        ApexPages.addMessage(myMsg);
        return; 
    } 
        if(OrderNumber != '' && FirstName == '' && Email=='')
        {
            orderlist = [select id, name, Customer__c,Order_Status__c, First_Name__c, Last_Name__c, Email__c, Phone__c,Order_Amount_Text__c from Order__c where name=:OrderNumber]; 
        }
        else if(OrderNumber == '' && FirstName != '' && Email=='')
        {
            TempFirstName = '%' + FirstName + '%'; 
            orderlist = [select id, name, Customer__c,Order_Status__c, First_Name__c, Last_Name__c, Email__c, Phone__c,Order_Amount_Text__c from Order__c where First_Name__c like:TempFirstName ]; 
        }
        else if(OrderNumber== '' && FirstName== '' && Email !='')
        {
            TempEmail= '%' + Email + '%';
            orderlist = [select id, name, Customer__c,Order_Status__c, First_Name__c, Last_Name__c, Email__c, Phone__c,Order_Amount_Text__c from Order__c where Email__c like:TempEmail];
        }
        else if(OrderNumber != '' && FirstName != '' && Email =='')
        {
            TempFirstName = '%' + FirstName + '%'; 
            orderlist = [select id, name, Customer__c,Order_Status__c, First_Name__c, Last_Name__c, Email__c, Phone__c,Order_Amount_Text__c from Order__c where name=:OrderNumber or First_Name__c like:TempFirstName];
        }
        else if(OrderNumber != '' && FirstName == '' && Email !='')
        {
            TempEmail= '%' + Email + '%';
            orderlist = [select id, name, Customer__c,Order_Status__c, First_Name__c, Last_Name__c, Email__c, Phone__c,Order_Amount_Text__c from Order__c where name=:OrderNumber or Email__c like:TempEmail];
        }
        else if(OrderNumber == '' && FirstName != '' && Email !='')
        {
            TempEmail= '%' + Email + '%';
            TempFirstName = '%' + FirstName + '%';             
            orderlist = [select id, name, Customer__c,Order_Status__c, First_Name__c, Last_Name__c, Email__c, Phone__c,Order_Amount_Text__c from Order__c where Email__c like:TempEmail or First_Name__c like:TempFirstName];
        }        
        else if(OrderNumber != '' && FirstName != '' && Email!='')
        {
            TempFirstName = '%' + FirstName + '%';
            TempEmail = '%' +Email + '%';
            orderlist = [select id, name, Customer__c,Order_Status__c, First_Name__c, Last_Name__c, Email__c, Phone__c,Order_Amount_Text__c from Order__c where name=:OrderNumber or Customer__r.name like:TempFirstName or Email__c like:TempEmail]; 
        }
        
        if(orderlist.size()>0) 
            bDisplay = true;
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no order found in the system');
            ApexPages.addMessage(myMsg);
            return; 
        } 
    }

    public pagereference LogComplaint()
    {
        PageReference Page = null;
        string OID = ApexPages.currentPage().getParameters().get('OID'); 
        string OName = ApexPages.currentPage().getParameters().get('OName');
        string str = '/a0O/e?CF00Ni000000EvGSx=' + OName + '&CF00Ni000000EvGSx_lkid=' + OID + '&retURL=%2Fa' + OID;
        Page = new PageReference(str);
        Page.setredirect(true);
        return Page; 
    }
    
    public pagereference OderDetails()
    {
        PageReference Page = null;
        string OID = ApexPages.currentPage().getParameters().get('OID'); 
        Page = new PageReference('/' + OID);
        Page.setredirect(true);
        return Page; 
    }
}