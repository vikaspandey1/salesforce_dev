public with sharing class LicenseOptimizerController
{
   
    map<string, Shift_Master__c> mapStrShiftMaster = new map<string, Shift_Master__c>();
    map<id, users__c> mapuser = new   map<id, users__c>();
    map<id, users__c> mapUserNew = new   map<id, users__c>();
    
    List<user> lst = new list<User>();
    list<case> objnewcase = new list<case>();
    list<string>  lstShiftType { get; set; }
    public List<categoryWrapper> lstStdUser{get;set;}
    
    set<id> objid = new set<id>();  
    set<id> setcaseID = new set<id>();
    set<id> setuserid = new set<id>(); 
    
    public boolean blVariable = false;
    public boolean blShowSearchPanel{ get; set; }
    public Boolean blStatusValue { get; set; }
    public boolean blActivateButton{get;set;}
    public boolean blDeactivateButton{get;set;}
    public boolean blShowUserDetail{get;set;}
    public Boolean blStatusCheck;
    
    Public Integer iPageRecordSize{get;set;}
    Public Integer iNoOfRecords{get; set;}
   
    public String strSelectedUser {get; set;} 
    public String[] strShiftType  {get; set;} 
    public string[] strProfileType  {get; set;} 
    public String CRON_EXP = '0 15 * * * ?';
    public String CRON_EXP2 = '0 30 * * * ?';
  
    
    public id idUser{get;set;}
    
    public LicenseOptimizerController()
    {
        strShiftType = new list<string>();
        strProfileType = new list<string>();
        
        blStatusValue=false;
        
        strShiftType.add('Regular');
        strShiftType.add('Evening');
        strShiftType.add('Afternoon');
        strShiftType.add('Night');
        
        strProfileType.add('Standard');
        blShowUserDetail = true;
     
        blDeactivateButton =true;
        blActivateButton=false;
        
       
  
      
    }
    
    
    
    //used to get the deatil of seleted user on the detail page.
    public void getusername()
    {
        blShowUserDetail= true;
        idUser=[select id from user where Username=:strSelectedUser].id;
    }
    
    
    
    public List<categoryWrapper> getUsers() 
    {
      try{
        lstStdUser= new List<categoryWrapper>();
        if(blStatusValue)
        {
            blDeactivateButton =true;
           
            blActivateButton=false;
        }
        else
        {
            blActivateButton=true; 
            blDeactivateButton =false;  
        } 
        
        for (users__c  urs: [select id, name,Name__c, ProfileName__c, End_Time__c, Start_Time__c, Status__c,shift_type__c,User__c
                             from users__c where ( Status__c =:blStatusValue AND 
                                                  Shift_Type__c in: strShiftType AND
                                                  Profilename__c in : strProfileType            
                                                 ) ])
        lstStdUser.add(new CategoryWrapper(urs));
        
       }
       
       catch (Exception e)
       {
       
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' Loading error '));
       }
       
        return lstStdUser;
    }
    
    public pageReference refresh() 
    {
       
        ApexPages.getMessages().clear();
        getUsers();
      // startSchedule();
        return null;
    }
    
    
    public List<SelectOption> getProfileType() 
    {
    List<SelectOption> options = new List<SelectOption>();

   
   for(profile objprofile : [select id, name from profile order by name])
     options.add(new SelectOption(objprofile.name,objprofile.name));
        
        
        return options;
    }
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('30','30'));
        return options;
    }
    
    public void activate() 
    {
    
    try{
        users__c obj= new Users__c();
        
        
        for (CategoryWrapper cw : lstStdUser) {
            if (cw.checked){
                mapuser.put(cw.cat.user__c, cw.cat );    
                
            }
            }
           
            
            for(user objuser :[select id, isactive from user where id in : mapuser.keyset() ])
            {
                // mapUserNew.put(objuser.id, objuser);
                setuserid.add(objuser.id);
                
            }
            system.debug('set id of the seleced custom user'+setuserid);
            
            if(setuserid.size() > 0 && setuserid != null )
            {
                blStatusCheck = true;
                updateUserStatus(setuserid, blStatusCheck);
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Users are Activated '));
            }
             else
            {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select the User '));
            }
           
            
                updateCustUser();
            
             }
            catch (Exception e)
            {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' Error while activating the users '));
            system.debug('Error at activate' +e);
            }
            //refresh();
        
    }
    
    
    public void deactivate() 
    {
       try{
        users__c obj= new Users__c();
        
        for (CategoryWrapper cw : lstStdUser) {
            if (cw.checked)
            {
                mapuser.put(cw.cat.user__c, cw.cat );            //cw.cat.users__c will give the ID of the record
            }
        }
        
        assigncontactQueue();                    
        
        for(user objuser :[select id, isactive from user where id in : mapuser.keyset()])
        {
            setuserid.add(objuser.id);
            //mapUserNew.put(objuser.id, objuser);
        }
        
        if(setuserid.size() > 0 && setuserid != null )
        {
            blStatusCheck = false;
            updateUserStatus(setuserid, blStatusCheck);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Users Are Deactivated '));
        }
        else
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select the User '));
        }
        
      updateCustUser();
         
         }
catch (Exception e)
{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' Error while deactivating users '));
            system.debug('Error at deactivate' +e);
}
  
        //refresh();
    }
    
    
    
    
    
    public void updateCustUser()
    {
    try{
        list<users__c> lstUsers = new list<users__c>();
        
        ShiftMaster();
        
        for(users__c objUsers : [select id, status__c, End_Time__c, Shift_Type__c from users__c where user__c in : setuserid ])
        {
            if(blStatusCheck == false)
            {
                objUsers.status__c = false ; 
                lstUsers.add(objUsers);
            }
            else if(blStatusCheck == true)
            {
                objUsers.End_Time__c = mapStrShiftMaster.get(objUsers.Shift_Type__c ).End_Time__c ;
                blActivateButton=false; 
                blDeactivateButton =false;
                objUsers.status__c = true;
                lstUsers.add(objUsers);
            }
        }
        if(lstusers.size() > 0 && lst != null)
            update lstUsers ;}
            catch (Exception e)
            {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,' Error while updateCustUser funcion '));
                        system.debug('Error at updateCustUser ' +e);
            }
    }
    
    public void ShiftMaster()
    {
        for(Shift_Master__c objshift : [select Shift__c, End_Time__c  from Shift_Master__c ])
            mapStrShiftMaster.put(objshift.shift__c, objshift);
    }
    
    public void startSchedule()
    {
    try
    {
    String CRON_EXP = '0 15 * * * ?';
   LicenseOptimizer_BatchClass  sch = new LicenseOptimizer_BatchClass ();
   system.schedule('quaterly hour batch for license', CRON_EXP, sch);
   
    String CRON_EXP2 = '0 30 * * * ?';
   LicenseOptimizer_BatchClass  sch2 = new LicenseOptimizer_BatchClass ();
   system.schedule('half hour batch for license', CRON_EXP2, sch2);
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The schedule batches are started '));
    }
    catch (Exception e)
    {
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The schedule batches have already been started '));
    
    }
    }
    
    
    @future
    public static void updateUserStatus(set<id> setuserid, Boolean blStatusCheck)
    {   
        LoopStop.tempvar = false;
        List<user> lst = new list<User>();
        
        for(user objuser :[select id, isactive from user where id in : setuserid])
        {
            if(blStatusCheck == false)
            {
                objuser.isactive= false;
                lst.add(objuser);
            }
            else if(blStatusCheck == true)
            {
                objuser.isactive= true;
                lst.add(objuser);
            }
        }
        
        if (lst.size()>0 && lst != null && !test.isRunningTest())
        {
            update lst;
        }
    }   

    
    public void assigncontactQueue()
    {
        string queueID = [SELECT id,Name FROM Group WHERE Name = 'CaseQueue'].id;
        
        for(case objcon : [select id,ownerid from case where ownerid in : mapuser.keyset()])
        {
            objcon.OwnerId = queueID;            
            objnewcase.add(objcon);
        }
        
        if(objnewcase.size() > 0 && objnewcase != null)
            update objnewcase ;
    }
}