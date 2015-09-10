public class cls_displaycontactinfo
{
 
  public final Users__c contact;
  public user user1;
  public string strStatus {get; set;}
  
    public cls_displaycontactinfo (){
      
         user1= [ select id,name,email from user where id= :UserInfo.getUserID()];
        contact=[select name__c,start_time__c from users__c where user__c=:user1.id];
        }
        
        
        
        public users__c getContact() {
        return contact;
        }
        
        
       
        public List<SelectOption> getStates()
        {
        
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Users__c.Extension_EndTime1__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry p : ple)
        {
            options.add(new SelectOption(p.getValue(), p.getValue()));        
        }
        return options;
          
          
        
        }    
        
        public void SendForApproval()
        {
            users__c objCustUser = new Users__c();
                        
             user1= [ select id,name,email from user where id= :UserInfo.getUserID()];
            objCustUser =[select approaval_track__c from users__c where user__c=:user1.id ];
        

            
            objCustUser.approaval_track__c='Extend Time Request';
            
            objCustUser.Extension_EndTime1__c= strStatus ;
            
            update objCustUser;
        }
      

   
 }