trigger UpdateShiftTimes on Shift_Master__c (after update) {
    
    Map<string, Shift_Master__c > mapStrShiftMaster= new Map<string, Shift_Master__c > ();
    list<users__c> lstCustUsers = new list<users__c>();
    
    for(Shift_Master__c  objShiftMaster : trigger.new)
    {
        if(trigger.oldmap.get(objShiftMaster.id).start_time__c != objShiftMaster.start_time__c || 
           trigger.oldmap.get(objShiftMaster.id).end_time__c != objShiftMaster.end_time__c )
        {
            mapStrShiftMaster.put(objShiftMaster.Shift__c, objShiftMaster );
        }  
    }
    
    
    for(users__c objCustUsers : [select Shift_Type__c, Start_Time__c, End_Time__c from users__c where Shift_Type__c in : mapStrShiftMaster.keyset()])
    {
        objCustUsers.start_time__c = mapStrShiftMaster.get(objCustUsers.Shift_Type__c).start_time__c ;
        objCustUsers.end_time__c = mapStrShiftMaster.get(objCustUsers.Shift_Type__c).end_time__c ;
        
        lstCustUsers.add(objCustUsers);
    }
    
    update lstCustUsers;
}