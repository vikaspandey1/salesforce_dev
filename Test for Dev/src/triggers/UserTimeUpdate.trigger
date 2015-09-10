trigger UserTimeUpdate on Users__c (before update) {

AddTime objAddTime = new AddTime();
for(users__c objUsers : trigger.new)
{

if(trigger.oldmap.get(objUsers.id).approaval_track__c != 'Extend Time Request Approved' &&
     objUsers.approaval_track__c == 'Extend Time Request Approved') 
     {
         objUsers.End_Time__c = objAddTime.calculateTime(objUsers.End_Time__c, objUsers.Extension_EndTime1__c);
     }

}

}