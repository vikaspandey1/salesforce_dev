trigger OrderCase on Order_Complaint__c (After insert) 
{
    Order_Complaint__c Obj = Trigger.New[0];
    
    Case caseToAdd = new Case();
    caseToAdd.Order__c = Obj.Order__c;
    caseToAdd.Subject = Obj.Subject__c;
    caseToAdd.Description = Obj.Complaint_Desription__c;
    insert caseToAdd ;
    
    Order__c Order = [select id,name,owner.name from Order__c where id=:Obj.order__c limit 1];
    
    String[] toaddress = new String[]{};
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    
    string strbody;
    strbody = 'Hi ' + Order.owner.name + ',<BR/><BR/>' ;
    strbody += 'A new case is open for order ' + Order.Name + ' Please refer the given below URl.' + '<BR/>';
    strbody += 'https://na15.salesforce.com/' + caseToAdd.id + '<BR/><BR/>';
    strbody += 'If you have any query, Please contact me' + '<BR/><BR/><BR/>';                 
    
    strbody += 'Thanks' +'<BR/>';
    strbody += 'Salesforce'+'<BR/>';
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setSenderDisplayName('Naman Kher'); 
    mail.setReplyTo('naman.kher@gmail.com');   
    toaddress.add('naman.kher@gmail.com');
    mail.subject = 'New Case Open for Order ' + Order.name;
    mail.setHtmlBody(strbody);
    mail.setToAddresses(toaddress);
    mail.saveAsActivity = false;
    emails.add(mail);
    Messaging.sendEmail(emails);
}