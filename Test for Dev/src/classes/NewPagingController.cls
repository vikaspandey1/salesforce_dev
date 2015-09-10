public with sharing class NewPagingController {
    
    map<string, Shift_Master__c> mapShift = new map<string, Shift_Master__c>();
    public boolean test = false;
    public Boolean selectedstatus { get; set; }
    Public Integer size{get;set;}
    Public Integer noOfRecords{get; set;}
    List<categoryWrapper> users{get;set;}
    
    public String strheaderclass {get; set;}     

    
    public boolean activevisibility{get;set;}
    public boolean deactivevisibility{get;set;}
    public String clickedusername {get; set;} 
    
    public id userid{get;set;}
    public String shiftType { get; set; }
    public string shiftType2 { get; set; }
    
    
    
    public NewPagingController ()
    {

        selectedstatus=true;

        shiftType2 = 'Regular';
        deactivevisibility =true;
        activevisibility=false;
        refresh();
    }
    
    public void getusername()
    {
        userid=[select id from user where Username=:clickedusername].id;
    }
    
    public ApexPages.StandardSetController con {

        get {

            if(con == null) {
                if(test == false){
                    size = 10;
                    
                }
                                con = new ApexPages.StandardSetController(Database.getQueryLocator
                                                          ([select id, name,Name__c, ProfileName__c, End_Time__c, Start_Time__c, Status__c,shift_type__c,User__c
                                                            from users__c where ( Status__c =:selectedstatus AND 
                                                            Shift_Type__c =:shiftType2 )
                                                            Order By Shift_Type__c ]));  
                                                                         
            

                con.setPageSize(size);
                
                noOfRecords = con.getResultSize();
             
                test = true;
                
            }
            return con;
        }
        set;
    }
    
    
    public List<categoryWrapper> getUsers() {
        users= new List<categoryWrapper>();
        
        
        if(selectedstatus)
        {
            deactivevisibility =true;
            activevisibility=false;
        }
        else
        {
            activevisibility=true; 
            deactivevisibility =false;  
        } 
        
        for (users__c  urs: ((List<users__c>)con.getRecords()))
            users.add(new CategoryWrapper(urs));
        
        system.debug('List of selected Users'+users);
        return users;
    }
    
    public pageReference refresh() {
        Con = null;
        getUsers();
        con.setPageNumber(1);
        return null;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('30','30'));
        return options;
    }
    
    
    map<id, users__c> mapuser = new   map<id, users__c>();
    
    
    
    public void activate() {
        list<user> lst = new list<User>();
        
        
        users__c obj= new Users__c();
        
        
        for (CategoryWrapper cw : users) {
            if (cw.checked)
                mapuser.put(cw.cat.user__c, cw.cat );    
        }
        
        for(user objuser :[select id, isactive from user where id in : mapuser.keyset() ])
        {

            setuserid.add(objuser.id);
            
        }
                system.debug('ID of standard user'+setuserid);
        updateUserStatus(setuserid);
        
        updateCustUser();
        refresh();
        getUsers();
        
        
        
        
        //  return null;
    }
    
    
    set<id> setcaseID = new set<id>();
    
    set<id> setuserid = new set<id>(); 
    
    
    public void deactivate() {
        set<id> setuserid = new set<id>();
        
        
        users__c obj= new Users__c();
        
        
        for (CategoryWrapper cw : users) {
            if (cw.checked)
            {
                mapuser.put(cw.cat.user__c, cw.cat );            //cw.cat.users__c will give the ID of the record
                                                                //cw.cat will give the record information
            }
            
        }
        
        assigncontactQueue();                    
        
        for(user objuser :[select id, isactive from user where id in : mapuser.keyset()])
        {
            //objuser.isactive= false;
            setuserid.add(objuser.id);
        }
        updateUserStatus(setuserid);
        updateCustUser();
        refresh();
        getUsers();
        
    }
    
    
    public void ShiftMaster()
    {
        for(Shift_Master__c objshift : [select Shift__c, End_Time__c  from Shift_Master__c ])
            mapShift.put(objshift.shift__c, objshift);
    }
    
    public void updateCustUser()
    {
        list<users__c> lstUsers = new list<users__c>();
        
        ShiftMaster();
        for(users__c objUsers : [select id, status__c,User__c, End_Time__c, Shift_Type__c from users__c where User__c in : mapuser.keyset()])
        {
            
            
            if(objUsers.status__c == false)
            {
                objUsers.status__c = true ; 
                lstUsers.add(objUsers);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'User Activated successfully.'));
                getUsers();
            }
            else
            {
                objUsers.End_Time__c = mapShift.get(objUsers.Shift_Type__c ).End_Time__c ;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'User De-Activated successfully.'));
                activevisibility=false; 
                deactivevisibility =false;
                objUsers.status__c = false;
                lstUsers.add(objUsers);
            }
        }
        if(lstusers.size() > 0)
            update lstUsers ;
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There is no record to DeActivate.'));
    }
    
    
    
    @future
    private static void updateUserStatus(set<id> setuserid)
    {   
        LoopStop.tempvar = false;

        list<user> lst = new list<user>();
        
        for(user objuser :[select id, isactive from user where id in : setuserid])
        {
            if(objuser.isactive == false)
            {
                
                objuser.isactive= true;
                lst.add(objuser);
                
            }
            else
            {
                
                objuser.isactive= false;
                lst.add(objuser);
                
            }
            
            
            
        }
        
        system.debug('List to update the standard user'+lst);
        if (lst.size()>0)
        {
                    system.debug('inside if of standard usr');
            update lst;
        }
        
    }
    
    
    
    
    public void assigncontactQueue()
    {
        list<case> objnewcase = new list<case>();
        set<id> objid = new set<id>();
        string queueID = [SELECT id,Name FROM Group WHERE Name = 'Queue For Testing'].id;
        
        
        
        for(case objcon : [select id,ownerid from case where ownerid in : mapuser.keyset()])
        {
            
            objcon.OwnerId = queueID;
            
            objnewcase.add(objcon);
        }
        update objnewcase ;
    }
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    
    
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    
    public void first() {
        con.first();
    }
    
    
    public void last() {
        con.last();
    }
    
    
    public void previous() {
        con.previous();
    }
    
    
    public void next() {
        con.next();
    }
    
    
    public void cancel() {
        con.cancel();
    }
    
    Public Integer getTotalPages(){
        
        Decimal totalSize = this.con.getResultSize();
        Decimal pageSize = this.con.getPageSize();
        
        Decimal pages = totalSize/pageSize;
        
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    
set<string> lstinteger = new set<string>();  

    public void testvalue() {
       
        
        integer i;
        
        //String[] cd = shiftType2.split(',');

        
       // for(i=0; i < cd.size();i++)
       //{
          //  lstinteger.add(cd[i]);
        
       // }

return ;        
    }
    

}