public class test_ctrl_GoogleMaps_Accounts {

    /* Constructor */
    public test_ctrl_GoogleMaps_Accounts() {
        updateAccounts();
    }

    /* Accounts */
    public List<Account> accounts = new List<Account>();
    
    public List<Account> getAccounts() {
        return accounts;
    }
    
    public void updateAccounts() {
        accounts =
            [SELECT Id, Name, ShippingStreet, ShippingCity,
                ShippingState, ShippingPostalCode, ShippingCountry
             FROM Account
             WHERE ShippingStreet <> ''
             LIMIT 100];
    }
    
    /* Account Variables */
    public String account1Id {get;set;}
    public Account account1 {get;set;}
    public String account1Address {get;set;}
    
    public String account2Id {get;set;}
    public Account account2 {get;set;}
    public String account2Address {get;set;}
    
    public void updateAccountVariables() {
        for (Account a : accounts) {
            if (a.Id == account1Id) {
                account1 = a;
            }
            if (a.Id == account2Id) {
                account2 = a;
            }
        }
    }
    
    public void updateAccountAddresses() {
        account1Address = EncodingUtil.urlEncode(
            + account1.ShippingStreet + ' '
            + account1.ShippingCity + ', '
            + account1.ShippingState + ' '
            + account1.ShippingPostalCode + ' '
            + account1.ShippingCountry,
            'UTF-8');
            
        account2Address = EncodingUtil.urlEncode( 
            + account2.ShippingStreet + ' '
            + account2.ShippingCity + ', '
            + account2.ShippingState + ' '
            + account2.ShippingPostalCode + ' '
            + account2.ShippingCountry,
            'UTF-8');
    }
    
    /* Account Options */
    public List<selectOption> getAccountOptions() {
        
        List<selectOption> options = new List<selectOption>();
        
        for (Account a : accounts) {
            options.add(new selectOption(a.Id, a.Name));
        }
        
        return options;
    }
    
    /* Button Action */
    public void btnCalculateDistance_Click() {
        
        updateAccountVariables();
        updateAccountAddresses();
        
        googleMaps gm = new googleMaps(
            account1Address,
            account2Address);

        distance = gm.distance;
        duration = gm.duration;
        travelTime = gm.travelTime;

        System.debug('@@@3'+distance);
        System.debug('@@@3'+duration);
        System.debug('@@@3'+travelTime);
        
    }
    
    /* Results */
    public Decimal distance {get;set;}
    public String duration {get;set;}
    public Integer travelTime {get;set;}

}