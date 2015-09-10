public with sharing class sendEmail 
    {
        public List <String> sendTo = new List<String>();
        public List <String> ccTo = new List<String>();
        public List <String> BccTo = new List<String>();
                                       
        public String StrSendTo {get;set;}
        public String StrCCTo {get;set;}
        public String StrBCCTo {get;set;}
        public String Body {get;set;}
        public String Subject {get;set;}
        private User usr {get;set;}
        public String UserEmail {get;set;}
        public String UserName {get;set;}
        public String ErrorMSG {get;set;}
        
        public void sendEmail(){
        usr =  [SELECT Email,name FROM User WHERE Id = : UserInfo.getUserId()];
        UserEmail = usr.Email;
        UserName = usr.name;
        ErrorMSG='';
        
        }
        
        public void AssignValues(){
            
            if(StrSendTo != ''){
                sendTo.add(StrSendTo);
                }
            
            if( StrBCCTo != ''){
                BccTo.add(StrBCCTo);
                 }
            
            if(StrCCTo != ''){
                ccTo.add(StrCCTo);
                }     
                    
                    
        }
        
        public void clearValues()
        {
                    StrSendTo = '';
                    StrCCTo = '';
                    StrBCCTo = '';
                    Subject='';
                    Body = '';
                    //mails.clear();
                    sendTo.clear();
                    ccTo.clear();
                    BccTo.clear(); 
                        
        }
        
        public void doSendEmail() 
        {
            try 
              {     
                    AssignValues();
                    Messaging.SingleEmailMessage mail;
                    List<Messaging.SingleEmailMessage> mails;
                                                       
                    mails = new List<Messaging.SingleEmailMessage>();
                    mail = new Messaging.SingleEmailMessage();
                    
                    mail.setToAddresses(sendTo);
                    
                    mail.setReplyTo(UserEmail);
                    mail.setSenderDisplayName(UserName);
                    
                    mail.setCcAddresses(ccTo);
                    mail.setBccAddresses(BccTo);
                    
                    mail.setSubject(Subject);
                    mail.sethtmlBody(body);
                    
                    mails.add(mail);
                    
                    Messaging.sendEmail(mails);
                    
                    clearValues();
                    
            } catch (Exception Ex) {  
                                        system.debug(ex);
                                        ErrorMSG = ex.getMessage();
                                   }
    }
    
}