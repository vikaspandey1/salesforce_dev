@isTest(SeeAllData=true) 
private class claimsDetailsControllerTest {   
    @isTest
    private static void testClaimsDetailsController()
    {
    //Standard controller of Account is just an example
    //Create a new instance of Account
    Case acc = new Case(Type='CCP');
    //Insert the object virtually
   insert acc;

    //Create a new instance of standard controller
    ApexPages.StandardController sc = new ApexPages.standardController(acc);
        try {
            // Test contact query method
         claimsDetailsController controller = new claimsDetailsController (sc);
        } finally {
            // Delete Contact
          delete acc;
        }
    
    }
     private static testMethod void testGetClaimsList() {
      claimsDetailsController c= new claimsDetailsController();   
      
      try {
            // Test contact query method
              System.assert(c.getClaimsList().size()>0, 'Result should contain at least one claim');
        } finally {
          
        }
     }
     
      private static testMethod void testNewInquiry() {
    
    claimsDetailsController c= new claimsDetailsController();   
      
      try {
            // Test contact query method
              System.assert(c.cancel()!=null, 'Result should contain value');
        } finally {

          
        }
     
    }
    
      private static testMethod void testAddLogs() {
    
    claimsDetailsController c= new claimsDetailsController();   
      
      try {
            // Test contact query method
              System.assert(c.addLogs()!=null, 'Result should contain value');
        } finally {

          
        }
     
    }
   
}