public class LicenseOptimizer_FutureHelper implements System.Queueable
{

    private map<id, boolean> mapUserString;
    

    public LicenseOptimizer_FutureHelper(map<id, boolean> mapUserString) {
        this.mapUserString = mapUserString;
        //this.bsStatusCheck= bsStatusCheck;
        
    }

list<string> lstCustUserName = new list<string>();
 map<id, boolean> mapUser = new   map<id, boolean>();
 
    public void execute(System.QueueableContext objContext)
    {
       
       //system.debug('@@@'+this.mapUserString+'....'+this.bsStatusCheck);
      
       LoopStop.tempvar = false;
        List<user> lst = new list<User>();
        
        
        for(users__c objUsers : [select user__c from users__c where id in : this.mapUserString.keyset() ])
        {
        
        lstCustUserName.add(objUsers.user__c);
        if(this.mapUserString.get(objUsers.id)== true)
        {
        mapUser.put(objUsers.user__c , this.mapUserString.get(objUsers.id));
        }
        
        else if(this.mapUserString.get(objUsers.id)== false)
        {
        mapUser.put(objUsers.user__c , this.mapUserString.get(objUsers.id));
        }
        
        }
        
        for(user objuser :[select id, name, isactive from user where id in : lstCustUserName])
        {
        
        system.debug('@@@1'+objuser.name);
            if(this.mapUser.get(objuser.id)== false)
            {
                objuser.isactive= false;
                lst.add(objuser);
            }
            else if(this.mapUser.get(objuser.id)== true)
            {
                objuser.isactive= true;
                lst.add(objuser);
            }
        }
        
         system.debug('###'+lst);
        if(!test.isRunningTest())
      update lst;
     
      
    }
    }