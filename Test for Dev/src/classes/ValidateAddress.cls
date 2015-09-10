public class ValidateAddress
{
    public Lead Con{get;set;}
    public Lead GoogleCon{get;set;}
    public string ConID{get;set;}    
    public string src{get;set;}

    public ValidateAddress()
    {
    }
    
    public ValidateAddress(ApexPages.StandardController controller) 
    {
        GoogleCon = new Lead();
        Con = new Lead();         
        if(ApexPages.currentPage().getParameters().get('ID') != null)        
        {            
            ConID = ApexPages.currentPage().getParameters().get('ID');
            System.debug('ConID :::::::::::::::: ' + ConID);
            Con = [select id, name, Lead.Street, Lead.City, Lead.State, Lead.PostalCode, Lead.Country, address from Lead where id=:ConID limit 1];
            System.debug('Con :::::::::::::::: ' + Con);
        }
    }
 
    public void AddressValidation()
    {
        System.debug('In AddressValidation :::::::::::::::: ' );
        try
        {
        
/*
            String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json?components=postal_code:' + Con.PostalCode +'|country:'+con.country+ '|locality:' + Con.city +'|administrative_area_level_1:' + con.state ;

//      String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json?components=locality:' + Con.mailingCity + '|' +'administrative_area_level_1:' + con.mailingstate + '|' + ' postal_code:' + Con.MailingPostalCode;
*/

        String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=';
            if(Con.Street != null && Con.Street != '')
                baseUrl = baseUrl   +   Con.Street  +   '+';
            if(Con.City != null && Con.City != '')
                baseUrl = baseUrl   +   Con.City    +   '+';
            if(Con.State != null && Con.State != '')
                baseUrl = baseUrl   +   Con.State   +   '+'; 
            if(Con.Country != null && Con.Country != '')
                baseUrl = baseUrl   +   Con.Country +   '+';
            if(Con.PostalCode != null && Con.PostalCode != '')
                baseUrl = baseUrl   +   Con.PostalCode;
      
        System.debug('baseUrl :::::::::::::::: ' + baseUrl);
   
            
            HTTPRequest request = new HTTPRequest();              
            request.setEndpoint(baseUrl);
            request.setHeader('Content-Type', 'application/json');
         // request.setHeader('Content-Length', '4096');            
            request.setMethod('GET');
            request.setTimeout(120000);
        
            HTTP http = new HTTP();
            HTTPResponse  response =  http.send(request);    
            response.getStatusCode();
            response.getBody();
        
            GeoCodeResult geo =(GeoCodeResult)JSON.deserialize(response.getBody(),GeoCodeResult.class);
            System.debug('geo :::::::::::::::: ' + geo.status );
            if(geo.status=='OK')
            {
                system.debug('@@@@@@ ' + geo.results); 
                for(Results results : geo.results)
                {
                    for(Address_components address :  results.address_components)
                    {
                        if(address.types.get(0)=='locality')
                        {
                            GoogleCon.City__c=address.long_name;
                        }
                        else if(address.types.get(0)=='administrative_area_level_1')
                        {
                            GoogleCon.State_Province__c=address.long_name;
                        }
                        else if(address.types.get(0)=='postal_code')
                        {
                            GoogleCon.Zip_Postal_Code__c=address.long_name;
                        }
                        else if(address.types.get(0)=='country')
                        {
                            GoogleCon.Country__c=address.long_name;
                        }                        
                    }
                }
            }
            else 
            {
                system.debug('@VB results === '+geo.status);
            }
        }
        catch(Exception e)
        {
            String errorMessage='';
            errorMessage=e.getMessage();
            errorMessage+= ' ::: inside updateAddressByGeocode.getUserByEmail(string email)  ....';
        }
    }
    
    public pageReference back()
    {
        return new pageReference('/' + ConID);
    }        
    public class GeoCodeResult 
    {
        public List<Results> results;
        public String status;
    }

    public class Address_components 
    {
        public String long_name;
        public String short_name;
        public List<String> types;
    }

    public class Results 
    {
        public List<Address_components> address_components;
    }
}