trigger UserPreference on User (before insert, before update, after insert, after update){

    if(LoopStop.tempvar == true)
    {
        
        if( Trigger.isAfter && Trigger.isInsert ){
            UserObjectClass process = new UserObjectClass(Trigger.new, Trigger.old, UserObjectClass.triggeredAction.afterInsert);
        }
       
        if( Trigger.isAfter && Trigger.isUpdate ){
            UserObjectClass process = new UserObjectClass(Trigger.new, Trigger.old, UserObjectClass.triggeredAction.afterUpdate);
        }
        
/*   These Condiotion are not required in the application and may be used in the futher releases
         if(Trigger.isBefore && Trigger.isUpdate){
            UserObjectClass process = new UserObjectClass(Trigger.new, Trigger.old, UserObjectClass.triggeredAction.beforeUpdate);
        }
        
        if( Trigger.isBefore && Trigger.isInsert ){
            UserObjectClass process = new UserObjectClass(Trigger.new, Trigger.old, UserObjectClass.triggeredAction.beforeInsert);
        }
*/     
    }
}