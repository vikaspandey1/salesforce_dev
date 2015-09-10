//This is the Custom Controller for the VF Component: GoogleChartComponent
public with sharing class GoogleDashboardController 
{
    public List<AggregateValueObject> summaryRecords {get;set;}
    public GoogleDashboardValueObject dashboard {get;set;}
    
    
    
    public String ParentName{
        get;
        set{ParentName = value; init();}
    }
    
    public String dashboardName {
        get;
        set{dashboardName = value; }
    }
    
    //Default Constructor. Since we are using apex parameters and VF components, we need to use in initialize function as the values won't be avail in constructor
    public GoogleDashboardController()
    {
        system.debug('GoogleDashbaordController Constructor.....');
    }
    
    //This is the initialize function. This will query to retrieve the dashbards based on input of the dashbaord param on the VF Component.
    public void init()
    {
    
    string strID = [select id from Parent_DashBoard__c where name = :ParentName ].id;
    
        List<Google_Dashboard_Configuration__c> gdashboards = [Select Id, Name, Object_Type__c, Group_By_Field__c, Group_By_Field_Label__c, Dashboard_Type__c , Summary_Field1__c, Where_Clause__c from Google_Dashboard_Configuration__c where Name =:dashboardName and  Parent_DashBoard__c =: strID  ];
        for(Google_Dashboard_Configuration__c gdashboard : gdashboards)
        {
            system.debug('Processing Dashboards for Dashboard Name: ' + dashboardName);
            String summaryQuery = buildGroupQuery(gdashboard);
            List<SObject> results = Database.query(summaryQuery);
            summaryRecords = new List<AggregateValueObject>();
            List<AggregateResult> summaryAggAcctRecords = results;
            for(AggregateResult agg : summaryAggAcctRecords)
            {
                AggregateValueObject aggVal = new AggregateValueObject((String)agg.get(gdashboard.Group_By_Field__c),(integer)agg.get('num'));
                //If this dashboard has a Summary Field, then the user want to perform a SUM not a COUNT, and use the SUM Field as the NUM.
                if(gdashboard.Summary_Field1__c != null && gdashboard.Summary_Field1__c != '')
                {
                    system.debug('The Summary Field: ' + gdashboard.Summary_Field1__c + ' was not null or empty, so the user wants to do a SUM not a count.....');
                    aggVal.num = Integer.valueOf((Decimal)agg.get(gdashboard.Summary_Field1__c));
                }
                summaryRecords.add(aggVal);
            }
            dashboard = new GoogleDashboardValueObject(gdashboard,summaryRecords);
        }
    }
    
    //This will use Dynamic SOQL at runtime to build a Summary Query off the Dashboard Configuration Object
    private String buildGroupQuery(Google_Dashboard_Configuration__c gdashboard)
    {
        system.debug('Building Dynamic SOQL Query per Dashboard Configuration' + gdashboard.Name + '.....');
        String query = 'Select count(id) num, ';
        if(gdashboard.Summary_Field1__c != null && gdashboard.Summary_Field1__c != '')
        {
            query = query + ' sum(' + gdashboard.Summary_Field1__c + ') ' + gdashboard.Summary_Field1__c + ', ';
        }
        query += gdashboard.Group_By_Field__c + ' from ' + gdashboard.Object_Type__c;
        if(gdashboard.Where_Clause__c != '' && gdashboard.Where_Clause__c != null)
        {
            query += ' ' + gdashboard.Where_Clause__c + ' ';
        }
        query +=  ' group by ' + gdashboard.Group_By_Field__c;
        system.debug('Dynamic SOQL Query == ' + query);
        return query;
    }
    
    //This is a wrapper class for the view layer to that we can display the results in a VF Component
    public class GoogleDashboardValueObject
    {
        public  List<AggregateValueObject> recs {get;set;}
        public Google_Dashboard_Configuration__c dashConfig {get;set;}
        
        public GoogleDashboardValueObject(Google_Dashboard_Configuration__c inConfig, List<AggregateValueObject> inrecs)
        {
            recs = inrecs;
            dashconfig = inConfig;
        }
    }
    
    //This is another wrapper object for the Aggregate Values since we can do object.get(String param) in a VF Page
    public class AggregateValueObject
    {
        public String field_name {get;set;}
        public integer num {get;set;}
        
        public AggregateValueObject(String inname, integer innum)
        {
            field_name = inname;
            if(field_name == null || field_name == '')
            {
                field_name = 'NA';
            }
            num = innum;
        }
    }
    
    //--------------UNIT TESTS-----------------------
  
    
    
    
}