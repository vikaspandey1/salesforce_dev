@isTest
private class TestLicenseClasses{
    public static testMethod void testLicenseController() {
        
        set<id> stUserId= new set<id>();
        list<Shift_Master__c > lstShift = new list<Shift_Master__c >();
        Shift_Master__c objShift;

        objShift = new Shift_Master__c( Shift__c = 'Regular', End_Time__c = '09:00:00',  Start_Time__c = '17:30:00');
        lstShift.add(objshift);
        
        objShift = new Shift_Master__c( Shift__c = 'Afternoon', End_Time__c = '14:30:00',  Start_Time__c = '23:00:00');
        lstShift.add(objshift);

        insert lstShift;     

        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User objUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = objProfile.Id, Shift_Association__c ='Afternoon' ,
                                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@abc.com');
        
        insert objUser;
        
        stUserId.add(objUser.id);
        
        Users__c objUsers = [select Name__c from Users__c where user__c =: objuser.id];
        
        LicenseOptimizerController objLicenseOptimizerController  = new LicenseOptimizerController();
        
        objLicenseOptimizerController.idUser = objUser.id;
        objLicenseOptimizerController.strSelectedUser = objUser.username;
        objLicenseOptimizerController.blShowSearchPanel = true;
        objLicenseOptimizerController.iPageRecordSize = 1;
        objLicenseOptimizerController.iNoOfRecords= 1;
        objLicenseOptimizerController.blStatusValue = true;
        
        objLicenseOptimizerController.getusername();
        
        objLicenseOptimizerController.getUsers();
        objLicenseOptimizerController.blStatusValue = false;
        objLicenseOptimizerController.getUsers();
        objLicenseOptimizerController.refresh();
        objLicenseOptimizerController.getProfileType();
        objLicenseOptimizerController.getItems();
        objLicenseOptimizerController.activate();
        objLicenseOptimizerController.deactivate();
        objLicenseOptimizerController.ShiftMaster();
        objLicenseOptimizerController.updateCustUser();
        objLicenseOptimizerController.assigncontactQueue();
        LicenseOptimizerController.updateUserStatus(stUserId,false);
        LicenseOptimizerController.updateUserStatus(stUserId,true);
        
    }
    
    
    
    
    
    public static testmethod void  testWrapperClass()
    {
        CategoryWrapper  cw1 = new CategoryWrapper ();
        system.assertequals(false,cw1.checked);
        system.assertnotequals(null,cw1.cat);
        
        users__c u = new users__c(Name__c ='standarduser@abc.com',Start_Time__c ='12:39:00',End_Time__c = '17:30:00');
        insert u;
        CategoryWrapper  cw2 = new CategoryWrapper (u);
    }
    
    public static testMethod void testLicenseBatchClass() {
        set<id> stUserId= new set<id>();
        
        list<Shift_Master__c > lstShift = new list<Shift_Master__c >();
        Shift_Master__c objShift;
        
        Custom_Comp_Info__c objCustomLicenseInfi = new Custom_Comp_Info__c(User_Licenses__c = 'Salesforce', Salesforce_Used_Licenses__c = 20, Salesforce_Total_Licenses__c =100);
        insert objCustomLicenseInfi ;
        
        datetime   CurrentDateTime = Datetime.now();
        string CurrentTime = CurrentDateTime.format('hh:mm:ss','IST');
        
        datetime      newDateTime1 = CurrentDateTime.addMinutes(-2);
        
        
        datetime       newDateTime2 = CurrentDateTime.addMinutes(8);
        
        
        String strEndDate = string.valueof(newDateTime1);
        String[] strCurrentTimeLessTen = strEndDate.split(' ');
        
        String strStartDate = string.valueof(newDateTime2);
        String[] strCCurrentTimeGreatTen  = strStartDate.split(' ');
        
        
        
        string strEndtime = strCurrentTimeLessTen[1] ;
        string strStarttime = strCCurrentTimeGreatTen[1] ;
        
     
        objShift = new Shift_Master__c( Shift__c = 'Regular', End_Time__c = '00:00:00' ,  Start_Time__c = strStarttime );
        lstShift.add(objshift);
        
        objShift = new Shift_Master__c( Shift__c = 'Afternoon', End_Time__c = strEndtime ,  Start_Time__c = '20:00:00');
        lstShift.add(objshift);
        
        
        objShift = new Shift_Master__c( Shift__c = 'Night', End_Time__c = '11:47:00',  Start_Time__c = '20:00:00');
        lstShift.add(objshift);
        
     
        
        insert lstShift;      
        
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
       User objUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = objProfile.Id, Shift_Association__c ='Afternoon' ,
                                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@abc.com');
        
        User objUser1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = objProfile.Id, Shift_Association__c ='Regular' ,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@abc.com');
        
        
        insert objUser;
        
        User objUser11 = new User(Alias = 'standt11', Email='standarduser11@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = objProfile.Id, Shift_Association__c ='Night' ,
                                  TimeZoneSidKey='America/Los_Angeles', UserName='standarduser12@abc.com');
        
        
        insert objUser11;
        
        insert objUser1;
        
        
       LicenseOptimizer_Automated objLicenseOptimizer_Automated = new LicenseOptimizer_Automated();
       objLicenseOptimizer_Automated.LicenseOptimizer();
        
        LicenseOptimizer_HelperClass objLicenseOptimizerHelperClass = new LicenseOptimizer_HelperClass();
        objLicenseOptimizerHelperClass.assigncontactQueue();
        
        
        Shift_Master__c objShift1 =[select Shift__c,End_Time__c , start_time__c from Shift_Master__c where Shift__c=:'Night'];
        objShift1.start_time__c = '11:11:11';
        objShift1.end_time__c ='12:12:12';
        
        update objShift1 ;
        
        
    }
    
    public static testMethod void testUserTrigger() {
        set<id> stUserId= new set<id>();
        
        list<Shift_Master__c > lstShift = new list<Shift_Master__c >();
        Shift_Master__c objShift;
        
        objShift = new Shift_Master__c( Shift__c = 'Regular', End_Time__c = '09:00:00',  Start_Time__c = '17:30:00');
        lstShift.add(objshift);
        
        objShift = new Shift_Master__c( Shift__c = 'Afternoon', End_Time__c = '14:30:00',  Start_Time__c = '23:00:00');
        lstShift.add(objshift);
       
        insert lstShift;     
        
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User objUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = objProfile.Id, Shift_Association__c ='Afternoon' ,
                                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@abc.com');
        
        
        insert objUser;
        
        stUserId.add(objUser.id);
        
        
        
        Users__c objUsers = [select Name__c from Users__c where user__c =: objuser.id];
        
        
        objUsers.approaval_track__c = 'Extend Time Request Rejected';
        
       
        
        update objUsers;
        objUsers.End_Time__c='12:00:00';
           objUsers.approaval_track__c = 'Extend Time Request Approved';
         objUsers.Extension_EndTime1__c = '00:00:30';
         
         update objUsers;
       
        User objNewUser = [select Shift_Association__c from user where id=: objuser.id];
        objNewUser.Shift_Association__c = 'Regular';
        
        update objNewUser ;
        
        
        UserHelper.updateUsername(stUserId, 'Future Call');
        UserHelper.updateUsername(stUserId, 'Future and Non-Future Call');
       
        
        
    }
    
}