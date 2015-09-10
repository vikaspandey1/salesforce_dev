public class UserStatusController {
    public List<Users__c> managerInfo {get;set;}
    public List<Users__c> userInfo {get;set;}
    public List<casesWrapper> caseList{get;set;}
    public List<Case> casesInfo {get;set;}
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<Users__c> usrlist{get;set;}
    public string caseQueue{get;set;}
    public String selectedQueue{get;set;}
    List<Group> lstQueueRecords{get;set;}
    public String selectedShift{get;set;}
    List<Users__c> lstShiftRecords{get;set;}
    //public List<InactiveUserObject__c> customUsrlist{get;set;}
    public List<SelectOption> options{get;set;}
    public List<AggregateResult> arList{get;set;}
    
   
  private Boolean convertToBoolean(String value) {
    boolean returnValue = false;
    if ('1'.equalsIgnoreCase(value) || 'yes'.equalsIgnoreCase(value) || 
        'true'.equalsIgnoreCase(value) || 'on'.equalsIgnoreCase(value))
        returnValue = true;
    return returnValue;
}
    //public User ManagerInfo {get;set;}  
    public UserStatusController() {
       //init variable
        //this.selectedUserIds= new Set<Id>();
        csvFileLines = new String[]{};
        usrlist = New List<Users__c>();
        //getUserList();
           getUsers();        
    }
    String newSearchText = '%Vijay%';
    String userTypeText = '%Customer Support Executive%';
    
    public void getManagersName()
    {
        List<Users__c> usersToUpdate = new List<Users__c>
        ([Select u.Id, u.Status__c,u.Name__c from Users__c u where (Not u.Name__c LIKE :newSearchText)]);
        System.debug('UsersToUpdate in getManagerName method is @@@@' + usersToUpdate);
        managerInfo = new List<Users__c>
            ([Select  u.Status__c from Users__c u where u.id in :usersToUpdate]);
        System.debug('ManagerInfo in getManagerName method is @@@@' + managerInfo);
    }
    
    public void getUserList()
    {
        /*userInfo = new List<Users__c>
        ([Select u.Id, u.IsActive, u.Name from Users__c u where (Not u.Name LIKE :newSearchText)]);*/
        userInfo = new List<Users__c>([Select u.Id, u.Status__c, u.Name from Users__c u ]);
        
        System.debug('userInfo is@@@@' + userInfo);
    }
      
    public void makeAllInactive()
    {
        List<Users__c> usersForUpdate = new List<Users__c>();
        /*List<User> usersToUpdate = new List<User>
        ([Select u.Id, u.IsActive from User u where (Not u.Name LIKE :newSearchText)]);
        System.debug('UsersToUpdate is@@@@' + usersToUpdate);*/
        System.debug('Selected users are:'+selectedUsers);
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
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully DeActivated.'));
            getUsers();
        }
        else
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no record to DeActivate.'));
        } 
    }
    public void makeAllActive()
    {
        List<Users__c> usersForUpdate = new List<Users__c>();
       // List <Profile> pid = [Select p.id from Profile p where Name Like :userTypeText];        
        /*List<User> usersToUpdate = new List<User>
        ([Select u.Id, u.IsActive from User u where (Not u.Name LIKE :newSearchText)]);
        System.debug('UsersToUpdate is@@@@' + usersToUpdate);*/
        for (Users__c u : selectedUsers)
        {
            if(!u.Status__c)
            {
                u.Status__c = true;
               // u.ProfileId = pid[0].id;                
                usersForUpdate.add(u);
            }
        }
        if (usersForUpdate.size()>0)
        {
            update usersForUpdate;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully Activated.'));
            getUsers();
        }
        else
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no record to Activate.'));
        }
    }
     public void makeInactive()
    {
        List<Users__c> usersForUpdate = new List<Users__c>();
        System.debug('usrlist in makeInactive @@@@' + usrlist);
        
        /* List<Case> casesToUpdate = findAllAssignedCases();
        if(casesToUpdate.size() > 0)
        {
            assignCases();
        }*/
        for (Users__c u : usrlist)
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
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully Deleted.'));
        }
        else
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no record to Delete.'));
        }
    }
     //List<casesWrapper> caseList;
     List<case> selectedcases = new List<case>();
    public void findCases()
    {
    
    //Need to update before deploy
    caseList = new List<casesWrapper>();
        System.Debug('selectedShift value is ' + selectedShift);    
          //  for(case cs : [Select c.Id, c.CaseNumber, c.Subject, c.OwnerId from Case c where c.OwnerId in :selectedUsers])
           //     caseList.add(new casesWrapper(cs));
    
       /* casesInfo = new List<Case>
        ([Select c.Id, c.CaseNumber, c.Subject, c.OwnerId from Case c where c.OwnerId in :selectedUsers]);
        caseList.
        */
        
        System.Debug('SelectedUsers value is ' + selectedUsers);                
        System.Debug('casesInfo value is ' + caseList);        
        if (caseList.size()<=0)
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no cases being worked by selected users.'));
        }
    }
    
    //Select c.Id, c.CaseNumber, c.Subject, c.OwnerId from Case c where c.OwnerId in :selectedUsers
    
    public class casesWrapper
    {
        public Case cases{get; set;}
        public Boolean selected {get; set;}
        
        
        public casesWrapper(Case cs)
        {
            cases = cs;
            selected = false;
        }
    }
    
    
    /*public List<Case> findAllAssignedCases()
    {
        casesInfo = new List<Case>
        ([Select c.Id, c.CaseNumber, c.Subject, c.OwnerId from Case c where c.OwnerId in :userInfo]);
        System.debug('casesInfo is@@@@' + casesInfo);
        return casesInfo;
    }*/
    public List<SelectOption> getopenQueueOptions(){
        List<SelectOption> options = new List<Selectoption>();
        lstQueueRecords = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' and name='Queue For Testing'];
        for(Group g : lstQueueRecords){
           options.add(new selectOption(g.Id, g.Name));
        }            
        return options;
    }
    public List<SelectOption> getopenShiftOptions(){
        List<Shift_Master__c> arList = [select shift__c from Shift_Master__c];
        System.Debug('arList value is ' + arList);
        options = new List<SelectOption>();
         for(Shift_Master__c u : arList){
              System.Debug('Shift__c value is ' + String.valueOf(u.get('Shift__c')));
              System.Debug('Shift__c is ' + String.valueOf(u.get('Shift__c')));
              if(String.valueOf(u.get('Shift__c')) != null && String.valueOf(u.get('Shift__c')) != null)
              options.add(new selectOption(String.valueOf(u.get('Shift__c')), String.valueOf(u.get('Shift__c'))));
          }
        System.Debug('options value is ' + options);
        return options;
    }
    
    public PageReference getSelectedCases()
    {
        selectedcases.clear();
        for(casesWrapper caseWrapper : caseList)
        if(caseWrapper.selected == true)
        selectedcases.add(caseWrapper.cases);
        return null;
    }
    public void assignCases()
    {
        /*List<Group> lstQueueRecords = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue'];
        for (Group g: lstQueueRecords)
        {
            if(g.Name.contains('Unclaimed Cases Queue'))
            {
                caseQueue = g.id;
            }
        }*/
        List<Case> casesToUpdate = new List<Case>();
        for (Case c : selectedcases)
        {
            c.OwnerId = selectedQueue;
            casesToUpdate.add(c);
        }
        if (casesToUpdate.size()>0)
        {
            update casesToUpdate;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Cases successfully Assigned to Queue.'));
        }
        else
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no record to be Assigned to Queue.'));
        }
    }
     
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
    List<userWrapper> userList = new List<userWrapper>();
    List<Users__c> selectedUsers = new List<Users__c>();
    public boolean visible = TRUE;
   
    public List<userWrapper> getUsers()
    {   
        System.debug('Get user called:'); 
        userList = new List<userWrapper>();
        System.Debug('selectedShift value is***** ' + selectedShift);  
          //(Select Start_Time__c from Shift_Master__c where Shift__c=: selectedShift)
         /* Shift_Master__c usr = [Select Start_Time__c,Shift__c from Shift_Master__c where Shift__c= 'Regular'];
          //Shift_Master__c usr = [Select Start_Time__c,Shift__c from Shift_Master__c where Shift__c= :selectedShift];
            for(Users__c u : [Select u.Status__c,u.User__c ,u.Name__c,u.Start_Time__c from Users__c u where u.Start_Time__c = :usr.Start_Time__c])
                userList.add(new userWrapper(u)); */
                
           List<Shift_Master__c> shiftlist =[select Start_Time__c,Shift__c from Shift_Master__c where Shift__c=:selectedShift];
           
            Map<string,Shift_Master__c> usrshiftmap = new Map<string,Shift_Master__c>();
            for(Shift_Master__c shiftc :[select Start_Time__c,Shift__c from Shift_Master__c where Shift__c=:selectedShift])
            {   
                usrshiftmap.put(shiftc.Shift__c,shiftc);
            }
            
           Map<string,Users__c> StarttimeUsermap = new Map<string,Users__c>();
           for(Users__c custom_user: [Select Start_Time__c from Users__c])
           {
              StarttimeUsermap.put(custom_user.Start_Time__c,custom_user); 
           }
           
           
            List<Users__c> users =new List<Users__c>();
           // List <Users__C> userdetail=[select u.Status__c,u.User__c ,u.Name__c  from Users__c u where u.Start_Time__c =:usrshiftmap.get(selectedShift).Start_Time__c];
           for(Shift_Master__c shiftdata:[select Start_Time__c,Shift__c from Shift_Master__c where Shift__c=:selectedShift])
            for(Users__c usr:[select u.Status__c,u.User__c ,u.Name__c,u.Start_Time__c  from Users__c u ])
            { 
                Shift_Master__c shiftmstr = usrshiftmap.get(usr.Start_Time__c);
                
                if(usr.Start_Time__c == shiftdata.Start_Time__c )
                {        System.debug('###Inside for loop'+usr.Start_Time__c+shiftdata.Start_Time__c);
                          //System.debug('###Inside for loop'+usr.Start_Time__c);   
                         System.debug('Users :'+usr);   
                        users.add(usr);
                        userList.add(new userWrapper(usr));
                }
            }   
            System.debug('No of available users'+userList);   
            integer i;
           /* for(i=0;i<users.size();i++)
            {
                userList[i]=new userWrapper(users[i]);
            }*/   
             
            // Map<string,Shift>   
            
        System.Debug('userList value is ' + userList);
        if(userList.size() <= 0)
        {
            visible = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Currently there is no user who belongs to '+selectedShift+'Shift'));
        }
        else
        {
            visible = true;
        }
        return userList;
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
   
    public List<Users__c> GetSelectedUsers()
    {
        if(selectedUsers.size()>0)
        return selectedUsers;
        else
        return null;
    }

}