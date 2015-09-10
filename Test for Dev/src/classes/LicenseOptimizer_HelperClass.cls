public with sharing class LicenseOptimizer_HelperClass
{

    map<string, Shift_Master__c> mapStrShiftMaster = new map<string, Shift_Master__c>();
    map<id, boolean> mapUserString= new   map<id, boolean>();
    map<id, users__c> mapUserNew = new   map<id, users__c>();
         
    
    List<user> lst = new list<User>();
    list<case> objnewcase = new list<case>();
    list<string>  lstShiftType { get; set; }
    List<categoryWrapper> lstStdUser{get;set;}
    List<string> lstUserName = new list<string>();
    
    set<id> objid = new set<id>();  
    set<id> setcaseID = new set<id>();
    set<id> setuserid = new set<id>();
    set<id> setActiveUserId= new set<id>();
    set<id> setDeActiveUserId= new set<id>();

    
   Boolean blStatusCheck ; 
    
   
    
   public void  getShiftMaster()
    {
        for(Shift_Master__c objshift : [select Shift__c, End_Time__c  from Shift_Master__c ])
            mapStrShiftMaster.put(objshift.shift__c, objshift);
        //return mapStrShiftMaster ;
    }
  
  map<id, string> mapStartDateTime = new map<id, string>();
    
    public void CalculateStartTime(set<id> setNewCustUserId)
    {
    for(users__c objCustUser : [select id, start_time__c, user__c, End_Time__c from  users__c where id in :setNewCustUserId ])
      {
          String strStartDate = objCustUser.start_time__c;
        String[] strTimeFractions = strStartDate.split(':');
        
        String strDate = strCurrentDate [0] +'-'+ strCurrentDate [1] +'-'+strCurrentDate [2] +' '+ strTimeFractions[0] +':'+ strTimeFractions[1] +':'+ strTimeFractions[2];
        
        Datetime CurrentDateTime2 = Datetime.valueOf(strDate);
        
        String StartDateTime = CurrentDateTime2.format('hh:mm:ss', 'GMT');
        
        mapStartDateTime.put(objCustUser.id, StartDateTime);
      
      }
      
    }
    
    
    map<id, string> mapEndDateTime = new map<id, string>();
    
    public void CalculateEndTime(set<id> setNewCustUserId)
    {
    
    for(users__c objCustUser : [select id, start_time__c, user__c, End_Time__c from  users__c where id in :setNewCustUserId ])
      {
              String strEndDate = objCustUser.end_time__c;
            String[] strTimeFractions_End = strEndDate.split(':');
            
            String strDate_End = strCurrentDate [0] +'-'+ strCurrentDate [1] +'-'+strCurrentDate [2] +' '+ strTimeFractions_End[0] +':'+ strTimeFractions_End[1] +':'+ strTimeFractions_End[2];
            
            Datetime CurrentDateTime_End = Datetime.valueOf(strDate_End);
            
            String strEndDateTime = CurrentDateTime_End.format('hh:mm:ss', 'GMT');
          
          mapEndDateTime.put(objCustUser.id, strEndDateTime );
      }
      
    }

map<string, Custom_Comp_Info__c> mapStrCustomCmpnyInfo = new map<string, Custom_Comp_Info__c> ();
list<Custom_Comp_Info__c> lstCustomCmpnyInfo = new list<Custom_Comp_Info__c>();    
 map<string, decimal> mapLicenseCount = new map<string, decimal> (); 
     
    public set<id> CheckTime(set<id> setCustUserId) 
    {

        CalculateTime();
        CalculateStartTime(setCustUserId);
        CalculateEndTime(setCustUserId);
        
        
        
        for(Custom_Comp_Info__c objCustomCmpnyInfo: [SELECT Id, Salesforce_Used_Licenses__c, Salesforce_Remaining_Licenses__c,User_Licenses__c FROM Custom_Comp_Info__c])
        {
            mapStrCustomCmpnyInfo.put(objCustomCmpnyInfo.User_Licenses__c, objCustomCmpnyInfo);
            mapLicenseCount.put(objCustomCmpnyInfo.User_Licenses__c , objCustomCmpnyInfo.Salesforce_Used_Licenses__c);
        }
        
        
      for(users__c objCustUser : [select id, start_time__c, user__c, End_Time__c, User_Licenses__c from  users__c where id in :setCustUserId ])
      {
      
      Custom_Comp_Info__c  objCustomCmpnyInfo = new Custom_Comp_Info__c (User_Licenses__c = objCustUser.User_Licenses__c  );
     
      if(mapStrCustomCmpnyInfo.get(objCustUser.User_Licenses__c).Salesforce_Remaining_Licenses__c > 3)
      {
        if( mapStartDateTime.get(objCustUser.id) < CurrentTimeGreatTen && mapStartDateTime.get(objCustUser.id) > CurrentTime)
        {
            lstUserName.add(objCustUser.user__c);
            mapUserString.put(objCustUser.id, true);
            setActiveUserId.add(objCustUser.id);
          
          mapLicenseCount.put(objCustUser.User_Licenses__c, mapStrCustomCmpnyInfo.get(objCustUser.User_Licenses__c).Salesforce_Used_Licenses__c - 1);
           //objCustomCmpnyInfo.Salesforce_Used_Licenses__c = mapStrCustomCmpnyInfo.get(objCustUser.User_Licenses__c).Salesforce_Used_Licenses__c - 1;
          // lstCustomCmpnyInfo.add(objCustomCmpnyInfo);
        }
        
        else if( mapEndDateTime.get(objCustUser.id)  > CurrentTimeLessTen && mapEndDateTime.get(objCustUser.id) < CurrentTime)
        {
            lstUserName.add(objCustUser.user__c);
            mapUserString.put(objCustUser.id, false);
            setDeActiveUserId.add(objCustUser.id);
            mapLicenseCount.put(objCustUser.User_Licenses__c, mapStrCustomCmpnyInfo.get(objCustUser.User_Licenses__c).Salesforce_Used_Licenses__c + 1);
           // objCustomCmpnyInfo.Salesforce_Used_Licenses__c = mapStrCustomCmpnyInfo.get(objCustUser.User_Licenses__c).Salesforce_Used_Licenses__c - 1;
           // lstCustomCmpnyInfo.add(objCustomCmpnyInfo);
        }
    }
    
      }
      
      if(setActiveUserId != null && setActiveUserId.size() > 0)
     {
     system.debug('stage 2');
          blStatusCheck = true ;
          ActivateCustUser(); 
     }
     
     if(setDeActiveUserId!= null && setDeActiveUserId.size() > 0)
     {
          blStatusCheck = false;
          DeActivateCustUser(); 
     }    
          
          System.Queueable job = new LicenseOptimizer_FutureHelper(mapUserString);
          System.enqueueJob(job);
  
  
   
   
   for(Custom_Comp_Info__c objCustomCmpnyInfo: [SELECT Id, Salesforce_Used_Licenses__c, Salesforce_Remaining_Licenses__c,User_Licenses__c FROM Custom_Comp_Info__c])
        {
            objCustomCmpnyInfo.Salesforce_Used_Licenses__c = mapLicenseCount.get(objCustomCmpnyInfo.User_Licenses__c );
            lstCustomCmpnyInfo.add(objCustomCmpnyInfo);
        }
        system.debug('%%%%'+lstCustomCmpnyInfo);
  update lstCustomCmpnyInfo;
   return setuserid ;     
          
    }
    
    
    
    public void ActivateCustUser()
    {
        list<users__c> lstUsers = new list<users__c>();
        
        getShiftMaster();
       system.debug('stage 3'); 
        for(users__c objUsers : [select id, user__c, status__c, End_Time__c, Shift_Type__c from users__c where id in : setActiveUserId])
        {if(!test.isRunningTest())
                objUsers.End_Time__c = mapStrShiftMaster.get(objUsers.Shift_Type__c ).End_Time__c ;
                objUsers.status__c = true;
                lstUsers.add(objUsers);
            
        }
     if(lstUsers!= null && lstUsers.size() > 0)  
     update lstUsers;
    }
    
    
    public void DeActivateCustUser()
    {
        list<users__c> lstUsers = new list<users__c>();
        
        getShiftMaster();
        
        for(users__c objUsers : [select id, user__c, status__c, End_Time__c, Shift_Type__c from users__c where id in : setDeActiveUserId])
        {	if(!test.isRunningTest())
                objUsers.End_Time__c = mapStrShiftMaster.get(objUsers.Shift_Type__c ).End_Time__c ;
                objUsers.status__c = false;
                lstUsers.add(objUsers);
            
        }
     if(lstUsers!= null && lstUsers.size() > 0)  
      update lstUsers;
    }
    
     public void assigncontactQueue()
    {
        string queueID = [SELECT id,Name FROM Group WHERE Name = 'CaseQueue'].id;
        
        for(case objcon : [select id,ownerid from case where ownerid in : lstUserName])
        {
            objcon.OwnerId = queueID;            
            objnewcase.add(objcon);
        }
        
        if(objnewcase.size() > 0 && objnewcase != null)
            update objnewcase ;
    }
  
  
    Datetime CurrentDateTime ;
    String CurrentTime ;
    DateTime newDateTime1 ;
    String CurrentTimeLessTen ;
    DateTime newDateTime2 ;
    String CurrentTimeGreatTen ;
    String strInput ;
    String[] strValues ;
    String[] strCurrentDate ;
    
    Public void CalculateTime()
    {
        
//getting the current  time
        CurrentDateTime = Datetime.now();
        CurrentTime = CurrentDateTime.format('hh:mm:ss', 'GMT');
        
        newDateTime1 = CurrentDateTime.addMinutes(-10);
        CurrentTimeLessTen = newDateTime1.format('hh:mm:ss', 'GMT');
        
        newDateTime2 = CurrentDateTime.addMinutes(10);
        CurrentTimeGreatTen = newDateTime2.format('hh:mm:ss', 'GMT');
       
       
//getting the end Date with Datetime        
        strInput = string.valueOf(Datetime.now());
        
        strValues = strInput.split(' ');
        strCurrentDate = strValues[0].split('-');
 
    
    }

  
    
}