public class CategoryWrapper {

    public Boolean checked{ get; set; }
    public users__c cat { get; set;}

    public CategoryWrapper(){
        cat = new users__c ();
        checked = false;
    }

    public CategoryWrapper(users__c c){
        cat = c;
        checked = false;
    }

 

}