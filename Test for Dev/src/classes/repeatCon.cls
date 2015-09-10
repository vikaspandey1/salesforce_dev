public class repeatCon {
      
     public string strtitle {get; set;}
     public string iColumns {get; set;}
     list<String> lstDashNames {get; set;}
     
     public list<String> getDashNames() {
     strtitle = 'test title';
     iColumns = '2';
     lstDashNames = new list<string>();
     
     for(Google_DashBoard_Configuration__c obj : [select name from Google_DashBoard_Configuration__c])
     {
     lstDashNames.add(obj.name);
     
     }
         return lstDashNames;
     }
     
     
     
     
 }