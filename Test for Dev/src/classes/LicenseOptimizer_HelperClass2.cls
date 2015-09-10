public with sharing class LicenseOptimizer_HelperClass2
{

    map<string, Shift_Master__c> mapStrShiftMaster = new map<string, Shift_Master__c>();
    map<id, users__c> mapCustuser = new   map<id, users__c>();
    map<id, users__c> mapUserNew = new   map<id, users__c>();
    
    List<user> lst = new list<User>();
    list<case> objnewcase = new list<case>();
    list<string>  lstShiftType { get; set; }
    List<categoryWrapper> lstStdUser{get;set;}
    List<string> lstUserName = new list<string>();
    
    set<id> objid = new set<id>();  
    set<id> setcaseID = new set<id>();
    set<id> setuserid = new set<id>();

    
   Boolean blStatusCheck ; 
    
   
    
   public void  getShiftMaster()
    {
        for(Shift_Master__c objshift : [select Shift__c, End_Time__c  from Shift_Master__c ])
            mapStrShiftMaster.put(objshift.shift__c, objshift);
        //return mapStrShiftMaster ;
    }
    
    
      public set<id> activate(set<id> setCustUserId) 
    {

//getting the current  time
        Datetime CurrentDateTime = Datetime.now();
        String CurrentTime = CurrentDateTime.format('hh:mm:ss', 'GMT');
        
        DateTime newDateTime1 = CurrentDateTime.addMinutes(-20);
        String CurrentTimeLessTen = newDateTime1.format('hh:mm:ss', 'GMT');
       
       
//getting the end Date with Datetime        
        String strInput = string.valueOf(Datetime.now());
        
        String[] strValues = strInput.split(' ');
        String[] strCurrentDate = strValues[0].split('-');
 
    
      for(users__c objCustUser : [select id, start_time__c, user__c from  users__c where id in :setCustUserId and name__c =: 'vixit_bhardwaj6@syntelinc.com'])
      {
        String strEndDate = objCustUser.start_time__c;
        String[] strTimeFractions = strEndDate.split(':');
        
        String strDate = strCurrentDate [0] +'-'+ strCurrentDate [1] +'-'+strCurrentDate [2] +' '+ strTimeFractions[0] +':'+ strTimeFractions[1] +':'+ strTimeFractions[2];
        
        Datetime CurrentDateTime2 = Datetime.valueOf(strDate);
        
        String StartDateTime = CurrentDateTime2.format('hh:mm:ss', 'GMT');
      
        
        
        if( StartDateTime > CurrentTimeLessTen && StartDateTime  < CurrentTime)
        {
            lstUserName.add(objCustUser.user__c);
            setuserid.add(objCustUser.id);
        }
      
      
      }
     
      blStatusCheck = true ;
          updateCustUser(blStatusCheck ); 
          
          updateUserStatus(setuserid, blStatusCheck );
   return setuserid ;     
          
    }
    
    public void updateCustUser(Boolean blCustStatusCheck)
    {
        list<users__c> lstUsers = new list<users__c>();
        
        getShiftMaster();
        
        for(users__c objUsers : [select id, status__c, End_Time__c, Shift_Type__c from users__c where id in : setuserid ])
        {
            if(blCustStatusCheck== false)
            {
                objUsers.status__c = false ; 
                lstUsers.add(objUsers);
            }
            else if(blCustStatusCheck == true)
            {
                objUsers.End_Time__c = mapStrShiftMaster.get(objUsers.Shift_Type__c ).End_Time__c ;
                objUsers.status__c = true;
                lstUsers.add(objUsers);
            }
        }
       
        if(lstusers.size() > 0 && lst != null)
            update lstUsers ;
    }
    
    
    @future(callout=true)
    private static void updateUserStatus(set<id> setuserid, Boolean blIsActive)
    {   
        LoopStop.tempvar = false;
        List<user> lst = new list<User>();
         List<string> lstCustUserName= new list<string>();
         
        //system.debug('@@@'+lstUserName);
        
        for(users__c objUsers : [select id, user__c from users__c where id in : setuserid])
{

lstCustUserName.add(objUsers.user__c);
}
        
        for(user objuser :[select id, name, isactive from user where id in : lstCustUserName])
        {
        
        system.debug('@@@1'+objuser.name);
            if(blIsActive == false)
            {
                objuser.isactive= false;
                lst.add(objuser);
            }
            else if(blIsActive == true)
            {
                objuser.isactive= true;
                lst.add(objuser);
            }
        }
        
        if (lst.size()>0 && lst != null)
        {
            update lst;
        }
    }
    
    
}