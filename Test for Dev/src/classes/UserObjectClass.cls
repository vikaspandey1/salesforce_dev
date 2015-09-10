public class UserObjectClass {
    UserHelper userHelperObj;
   
   public enum triggeredAction {beforeInsert, beforeUpdate, afterInsert, afterUpdate}

    public UserObjectClass(User[] userObjects, User[] userOldObjects,triggeredAction ta) 
    {   
        userHelperObj = new UserHelper();
       
     // AFTER INSERT  
       if (ta == triggeredAction.afterInsert) 
        {
            userHelperObj.userAfterInsertMethod(userObjects);
        }
        
        // AFTER UPDATE
        if (ta == triggeredAction.afterUpdate) 
        {
            userHelperObj.userAfterUpdateMethod(userObjects, userOldObjects);
        }
        
/*   These Condiotion are not required in the application and may be used in the futher releases     
         // BEFORE INSERT
        if (ta == triggeredAction.beforeInsert) 
        {
          // userHelperObj.userBeforeInsertMethod(userObjects, userOldObjects);
        }
        
        // BEFORE UPDATE
        if (ta == triggeredAction.beforeUpdate) 
        {
            //userHelperObj.userBeforeUpdateMethod(userObjects, userOldObjects);
        }
*/
    }
}