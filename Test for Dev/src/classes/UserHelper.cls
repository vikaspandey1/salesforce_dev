public class UserHelper {
    set<id> setOfChangedUserId;
    set<Id> setShiftMasterId; 
    set<id> setOfNewUserId;
    
    List<Users__c> lstCustomUsers;
    list<User> lstOfChangedUsers;
    list<User> lstOfNewUsers;
    list<User> lstUser;
    list<Shift_Master__c> lstShiftMaster;
    list<Users__c> lstCustomUser;
    list<Users__c> lstTempCustomUser;
    
    map<String, Shift_Master__c> mapShiftMaster;

    map<id, User> mapOldUser;
    map<string, User> mapNewUser;
    
    map<id, UserLicense> mapIdUserLicense = new map<id, UserLicense>();
    
    Users__c objCustomUser;
    
    static String temp ;
    
    public UserHelper() {
        
    }
   
        map<id,profile> mapIDProfile = new map<id,profile>();  


    
    
    public void userAfterInsertMethod(list<User> lstUser){
        //Fetching the Shift Master Records
        mapShiftMaster();

        for(profile objprofile : [SELECT id, Name, UserLicenseId FROM Profile])
        {
            mapIDProfile.put(objprofile.id, objprofile);
        }
        
        for(UserLicense objUserLicense : [SELECT Id,Name FROM UserLicense])
        {
            mapIdUserLicense.put(objUserLicense.id, objUserLicense);
        }

        
        
        
        
        //Fetching the New Standard Users
        lstOfNewUsers = lstOfUsers(setOfNewUsers(lstUser));
        
        //Putting the Changed Users in the Custom Users
        lstCustomUser = new List<Users__C>();
        if(lstOfNewUsers != null && lstOfNewUsers.size() >0){ 
            for(User objNewUser : lstOfNewUsers){
                objCustomUser = new Users__C();
                if(mapShiftMaster != null && mapShiftMaster.size() > 0)
                {
                    objCustomUser.Start_Time__c = mapShiftMaster.get(objNewUser.Shift_Association__c).Start_Time__c;
                    objCustomUser.End_Time__c = mapShiftMaster.get(objNewUser.Shift_Association__c).End_Time__c;
                }
                objCustomUser.ownerid = objNewUser.id;
                objCustomUser.Shift_Type__c = objNewUser.Shift_Association__c;
                objCustomUser.Status__c = objNewUser.IsActive;
                objCustomUser.Name__C = objNewUser.Username;
                objCustomUser.User__c = objNewUser.id;
                objCustomUser.ProfileName__c = mapIDProfile.get(objNewUser.Profileid).name;
                objCustomUser.User_Licenses__c = mapIdUserLicense.get(mapIDProfile.get(objNewUser.Profileid).UserLicenseId).Name;
                lstCustomUser.add(objCustomUser);
            }
            if(lstCustomUser.size() > 0 && lstCustomUser != null)
            {
                insert lstCustomUser;
            }
        }
    }
    
    
    public void userAfterUpdateMethod(list<User> lstUser, list<User> lstOldUser)
    {
        //Fetching the Shift Master Records
        mapShiftMaster();
        
        setOfChangedUsers(lstUser, lstOldUser);
        
        lstCustomUsers(mapNewUser.keySet());
        
        lstTempCustomUser = new List<Users__c>();
        
        if(temp == 'Non-Future Call' )
        {
            if(mapShiftMaster.size() > 0 && mapShiftMaster != null)
            {
                if(mapNewUser.size() > 0 && mapNewUser != null)
                {
                    for(Users__C objCustomUser : lstCustomUsers )
                    {
                        objCustomUser.Start_Time__c = mapShiftMaster.get(mapNewUser.get(objCustomUser.name__c).Shift_Association__c).Start_Time__c;
                        objCustomUser.Shift_Type__c = mapNewUser.get(objCustomUser.name__c).Shift_Association__c;
                        objCustomUser.End_Time__c = mapShiftMaster.get(mapNewUser.get(objCustomUser.name__c).Shift_Association__c).End_Time__c;
                        
                        lstTempCustomUser.add(objCustomUser);
                    }
                }
            }
        }   
        else if(temp == 'Future Call' )
        {
            updateUsername(setOfChangedUserId, temp);
        }
        else if(temp == 'Future and Non-Future Call')
        {
            updateUsername(setOfChangedUserId, temp);
        }
        if(lstTempCustomUser.size() >0)
            update lstTempCustomUser;
    }
    
    // Method to fetch the Newly inserted users id
    
    public Set<id> setOfNewUsers(list<User> lstUser){
        setOfNewUserId = new Set<id>();
        for(User userObj : lstUser){
            if( userObj.Previous_Employee__c != true 
               && userObj.IsActive != false
               && userObj.Shift_Association__c != ''  
              )
            {
                setOfNewUserId.add(userObj.Id);
            }
        }
        return setOfNewUserId;
    }
    
    
    // Method to fetch the Updated  users id
    public Void setOfChangedUsers(list<User> lstUser, list<User> lstOldUser){
        
        setOfChangedUserId = new Set<id>();
        
        mapOldUser = new map<id,user>();        
        mapNewUser = new map<string,user>();        
        
        for(User oldUserObj : lstOldUser)
        {
            mapOldUser.put(oldUserObj.id, oldUserObj);
        }
        
        for(User userObj : lstUser)
        {
            if( (mapOldUser.get(userObj.id).Profileid != userObj.Profileid ) ||
                (mapOldUser.get(userObj.id).Shift_Association__c != userObj.Shift_Association__c ) &&
               (mapOldUser.get(userObj.id).Username != userObj.Username ||
                mapOldUser.get(userObj.id).IsActive != userObj.IsActive )
              )
            {
                setOfChangedUserId.add(userObj.id);
                temp = 'Future and Non-Future Call';
                system.debug('following');
            }
            else if(mapOldUser.get(userObj.id).Shift_Association__c != userObj.Shift_Association__c )
            {
                mapNewUser.put(userObj.Username, userObj);
                setOfChangedUserId.add(userObj.id);
                temp = 'Non-Future Call' ;
            }
            else if ( ( mapOldUser.get(userObj.id).Username != userObj.Username )||
                    ( mapOldUser.get(userObj.id).IsActive != userObj.IsActive ) ||
                    (mapOldUser.get(userObj.id).Profileid != userObj.Profileid) 
                    )
            {
                setOfChangedUserId.add(userObj.id);
                temp = 'Future Call' ;
            }
        }
    }
    
    // Method for Fetching the List of User Records for given ids
    public list<user> lstOfUsers(Set<id> ids){
        if(ids != null && ids.size()>0){
            lstUser = [select id, Username, isActive, profileid, Shift_Association__c from user Where  id in : ids ];
        }
        return lstUser ;
    }
    
    // Method for Fetching the Shift Master Records
    public void mapShiftMaster()
    {
        setShiftMasterId = new set<Id>(); 
        mapShiftMaster = new map<String, Shift_Master__c>();
        for(Shift_Master__c objShiftMaster : [select id, Shift__c, Start_Time__c, End_Time__c from Shift_Master__c])
        {
            mapShiftMaster.put(objShiftMaster.Shift__c, objShiftMaster);
            //setShiftMasterId(objShiftMaster.Id);
        }
    }
    
    // Method for Fetching the Custom Users Records
    public void lstCustomUsers(set<string> setCustomUserName)
    {
        
        lstCustomUsers = new list<users__c>();
        
        lstCustomUsers = [select id, Name, Name__c, User__C, Status__c, Start_Time__c, End_Time__c from Users__C where Name__c in : setCustomUserName];
       
    }
    
    
    
    @future
    public static void updateUsername(set<Id> setUpatedUser, string CallMethod)
    {   
        system.debug('working');
        map<string, Shift_Master__c> mapShiftMaster = new map<string, Shift_Master__c>();
        list<users__c> lstCustomUser = new list<users__c>();
        map<string, user> mapUser = new map<string, user>();
        
        for(Shift_Master__c objShiftMaster : [select id, Shift__c, Start_Time__c, End_Time__c from Shift_Master__c])
        {
            mapShiftMaster.put(objShiftMaster.Shift__c, objShiftMaster);
        }
        
        for(user objUser : [select id, Username, isActive, profileid, Previous_Employee__c, Shift_Association__c from user Where  id in : setUpatedUser])
        {
            if(objUser.Previous_Employee__c == false)
            {
                mapUser.put(objUser.id, objuser);     
            }
        }
        
        if(CallMethod == 'Future Call')
        {
            for(users__c objCustomUser : [select id, Name, ProfileName__c, Name__c, User__C, Status__c, Start_Time__c, End_Time__c from Users__C where user__c in : mapUser.keySet()  ])
            {
                objCustomUser.Name__c = mapUser.get(objCustomUser.User__C).UserName;
                objCustomUser.Status__c = mapUser.get(objCustomUser.User__C).isactive;
               
                lstCustomUser.add(objCustomUser);
            }
        } 
        else if(CallMethod == 'Future and Non-Future Call')
        {   
            for(users__c objCustomUser : [select id, Name, Name__c, User__C, Status__c, Start_Time__c, End_Time__c from Users__C where user__c in : mapUser.keySet()  ])
            {
                objCustomUser.Name__c = mapUser.get(objCustomUser.User__C).UserName;
                objCustomUser.Status__c = mapUser.get(objCustomUser.User__C).isactive;
                objCustomUser.Start_Time__c = mapShiftMaster.get(mapUser.get(objCustomUser.User__C).Shift_Association__c).Start_Time__c;
                   objCustomUser.End_Time__c = mapShiftMaster.get(mapUser.get(objCustomUser.User__C).Shift_Association__c).End_Time__c;
                            
                lstCustomUser.add(objCustomUser);
            }
        }
        update lstCustomUser;
    }
    
 /*   These Condiotion are not required in the application and may be used in the futher releases    
    public void userBeforeInsertMethod(list<User> lstUser, list<User> lstOldUser ){
    }
    
    
    public void userBeforeUpdateMethod(list<User> lstUser, list<User> lstOldUser ){
        
    }
 */  
    
}