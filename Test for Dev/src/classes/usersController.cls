global with sharing class usersController {

  


    public usersController ()
    {
       
   Map<ID, User> m1 = new Map<ID, User>([SELECT Id, Name,IsActive FROM User ]);
    for (ID idKey : m1.keyset()) 
    {
    User a = m1.get(idKey);

   //System.debug(a);
    }
    

     
}}