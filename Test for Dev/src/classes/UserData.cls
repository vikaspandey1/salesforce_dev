public class UserData {
public List<Users__c> usrlist{get;set;}
public boolean selectedstatus{get;set;}
//List<userWrapper> userList = new List<userWrapper>();
public boolean activevisibility{get;set;}
public boolean deactivevisibility{get;set;}
public String clickedusername {get; set;} 
public id userid{get;set;}



//ConstructorList<userWrapper>()
public UserData()
{    
    selectedstatus=true;
    deactivevisibility =true;
    activevisibility=false;
    usrlist = New List<Users__c>();
    selectedUsers.clear(); 
    
}
//to fetch users details from the standard user object
public void getusername()
    {
        System.debug('clicked username:'+clickedusername);
        userid=[select id from user where Username=:clickedusername].id;
    }

//To fetch users of selected status

List<userWrapper> userList = new List<userWrapper>();
List<Users__c> selectedUsers = new List<Users__c>();

public List<userWrapper> getUsers()
    {   
        if(selectedstatus)
        {
            deactivevisibility =true;
            activevisibility=false;
        }
        else
        {
             activevisibility=true; 
             deactivevisibility =false;  
        }
        
        userList = new List<userWrapper>();
        System.Debug('selectedShift value is ' + selectedstatus);    
           // Shift_Master__c usr = [Select Start_Time__c,Shift__c from Shift_Master__c where Shift__c= :selectedShift];
            for(Users__c u : [Select u.Status__c,u.User__c ,u.Name__c,u.Start_Time__c,Users__c.Name  from Users__c u where u.Status__c=:selectedstatus])
           
                userList.add(new userWrapper(u));
            
        System.Debug('userList value is ' + userList);
        if(userList.size() <= 0)
        {
            visible = false;
            activevisibility=false; 
             deactivevisibility =false;
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.Prod_ErrMessagqe));
        }
        else
        {
            visible = true;
        }
       
        
        
        return (userList) ;
    } 
    
    public boolean visible = TRUE;
    public class userWrapper
    {
        public Users__c usr{get; set;}
        public Boolean selected {get; set;}
        public userWrapper(Users__c u)
        {
            usr = u;
            selected = false;
        }
    }
    
    public PageReference getSelected()
    {
        selectedUsers.clear();
        for(userWrapper usrWrapper : userList)
        if(usrWrapper.selected == true)
        selectedUsers.add(usrWrapper.usr);
        System.debug('@@@@@@@'+selectedUsers);
        return null;
    }
    
    public void deactivateuser()
    { 
        
       System.debug('deactivate user called'); 
       System.debug('Selected user'+selectedUsers);
        // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'No of active selected user'+selectedUsers.size()));
        List<Users__c> usersForUpdate = new List<Users__c>();
         for (Users__c u : selectedUsers)
        {
            if(u.Status__c)
            {
                u.Status__c = false;
                usersForUpdate.add(u);
            }
        }
        if (usersForUpdate.size()>0)
        {
            update usersForUpdate;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'User deactivated successfully.'));
            selectedUsers.clear();
            getUsers();
            
            
        }
        else
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no record to DeActivate.'));
             activevisibility=false; 
             deactivevisibility =false;
        } 
        
    }
    
    public void activateuser()
    {
        System.debug('Activate user called');
       // System.debug('Selected user'+selectedUsers.size());
       // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'No of Inactive selected user'+selectedUsers.size()));
        List<Users__c> usersForUpdate = new List<Users__c>();
        
        for (Users__c u : selectedUsers)
        {
            if(!u.Status__c)
            {
                u.Status__c = true;
                               
                usersForUpdate.add(u);
            }
        }
        if (usersForUpdate.size()>0)
        {
            update usersForUpdate;
            selectedUsers.clear();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'User activated successfully.'));
            getUsers();
            
            
        }
        else
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no record to Activate.no of selected users r'+selectedUsers.size()));
             activevisibility=false; 
             deactivevisibility =false;
        }
       
    }

}