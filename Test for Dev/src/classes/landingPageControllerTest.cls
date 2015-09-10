@isTest(SeeAllData=true)
public class landingPageControllerTest {


     
   private static testMethod void testGetCases() {
    // string cNumber = '00001155';    
        Case c= new Case();
        c.Subject='ABC';
        c.Status='New';
        c.Reason='CMS Error';
        insert c;
    landingPageController l= new landingPageController();   
      
      try {
            // Test contact query method
              System.assert(l.getCases().size()>0, 'Result should contain at least one case with this case number');
        } finally {
            // Delete Contact
          
        }
     
    }
       
   private static testMethod void testGetClaim() {
    // string cNumber = '00001155';    
       
    landingPageController l= new landingPageController();   
      
      try {
            // Test contact query method
              System.assert(l.getClaim().size()>0, 'Result should contain at least one claim');
        } finally {
            // Delete Contact
          
        }
     
    }
     private static testMethod void testGetBenefit() {
    // string cNumber = '00001155';    
       
    landingPageController l= new landingPageController();   
      
      try {
            // Test contact query method
              System.assert(l.getBenefit().size()>0, 'Result should contain at least one Benefit');
        } finally {
            // Delete Contact
          
        }
     
    }
     private static testMethod void testGetAlert() {
    // string cNumber = '00001155';    
       
    landingPageController l= new landingPageController();   
      
      try {
            // Test contact query method
              System.assert(l.getAlert().size()>0, 'Result should contain at least one Alert');
        } finally {
            // Delete Contact
          
        }
     
    }
    private static testMethod void testNewInquiry() {
    // string cNumber = '00001155';    
       
    landingPageController l= new landingPageController();   
      
      try {
            // Test contact query method
              System.assert(l.NewInquiry()!=null, 'Result should contain value');
        } finally {
            // Delete Contact
          
        }
     
    }
    
    }