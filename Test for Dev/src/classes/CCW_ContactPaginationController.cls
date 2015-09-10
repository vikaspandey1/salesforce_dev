public with sharing class CCW_ContactPaginationController {
//mith code start 
public boolean selectedstatus{get;set;}
public boolean activevisibility{get;set;}
public boolean deactivevisibility{get;set;} 
// mith end
    public String contextItem{get;set;}
 
    private ApexPages.StandardSetController setCon;
 
    
    private Set<Id> selectedContactIds;

    public CCW_ContactPaginationController ()
    {
      
        this.selectedContactIds= new Set<Id>();
         selectedstatus=true;
        this.setCon= new ApexPages.StandardSetController( [Select Name, Start_Time__c, End_Time__c,Status__c from Users__c  ]);
        this.setCon.setpageNumber(1);
        this.setCon.setPageSize(10);
       
       
    }
 
    
    public void doSelectItem(){
 
        this.selectedContactIds.add(this.contextItem);
 
    }
 
   
    public void doDeselectItem(){
 
        this.selectedContactIds.remove(this.contextItem);
 
    }
 
    
    public Integer getSelectedCount(){
 
        return this.selectedContactIds.size();
 
    }
 
   
    public void doNext(){
 
        if(this.setCon.getHasNext())
            this.setCon.next();
 
    }
 
    public void doPrevious(){
 
        if(this.setCon.getHasPrevious())
            this.setCon.previous();
 
    }
 
   
    public List<CCWRowItem> getUserAccounts(){
    
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
 
        List<CCWRowItem> rows = new List<CCWRowItem>();
 
        for(sObject r : this.setCon.getRecords() ){
            Users__c c = (Users__c)r;
 
            CCWRowItem row = new CCWRowItem(c,false);
            if(this.selectedContactIds.contains(c.Id))
            {
                row.IsSelected=true;
            }
            else{
                row.IsSelected=false;
            }
            rows.add(row);
            
            
        }
       
        
 
        return rows;
 
    }
 
    public Boolean getHasPrevious(){
 
        return this.setCon.getHasPrevious();
 
    }
 
    public Boolean getHasNext(){
 
        return this.setCon.getHasNext();
 
    }
 
    public Integer getPageNumber(){
 
        return this.setCon.getPageNumber();
 
    }
 
    Public Integer getTotalPages(){
         Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
         Decimal pages = totalSize/pageSize;
         return (Integer)pages.round(System.RoundingMode.CEILING);
    }
 
    public with sharing class CCWRowItem{
 
        public Users__c tContact{get;set;}
        public Boolean IsSelected{get;set;}
 
        public CCWRowItem(Users__c c, Boolean s){
            this.tContact=c;
            this.IsSelected=false;
        }
 
    }
}