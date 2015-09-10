public class ProjectEstimateController {

    public Id ProjectId {get; set;}
    public String ProjectName {get; set;}
    public String ClientName {get; set;}
    public String Confidentiality {get; set;}
    public String Methodology {get; set;} 
    public String PlannedStartDate {get; set;}
    public String PlannedEndDate {get; set;}
    public String TypeWork {get; set;}
    
    public boolean Show {get; set;}
    
    public List<Configuration__c> lstConfiguration;
    public List<Report_and_Dashboard__c> lstReportDashboard;
    public List<User_Administration__c> lstUserAdministration;
    public List<Workflow_and_Approval__c> lstWorkflowAndApproval;
    public List<Customization__c> lstCustomization;
    public List<Data_Migration__c> lstDataMigration;
    public List<Integration_Batch__c> lstIntegrationBatch;
    public List<Integration_Real_Time__c> lstIntegrationRealTime;    

    public List<WrapperOuterClass> wrapperOuterClassObj= new List<WrapperOuterClass>();
    public List<WrapperOuterClass> wrapperOuterClassLst { get {return wrapperOuterClassObj;} set {wrapperOuterClassObj = value;} }
    
    public List<WrapperBottomTotalClass> wrapperBottomTotalClassObj = new List<WrapperBottomTotalClass>();
    public List<WrapperBottomTotalClass> wrapperBottomTotalClassLst { get{return wrapperBottomTotalClassObj;} set{wrapperBottomTotalClassObj = value;} }
    
    public ProjectEstimateController(){
        ProjectId = ApexPages.currentPage().getParameters().get('ProjectId');
        
        Projects__c objProject = [SELECT Client_Name__c, Confidential__c, Methodology__c, Name, Planned_End_Date__c, Planned_Start_Date__c,
                                Type_of_Work__c FROM Projects__c where id=: ProjectId limit 1];

        ProjectName = objProject.Name;
        ClientName = objProject.Client_Name__c;
        Confidentiality = objProject.Confidential__c;
        Methodology = objProject.Methodology__c;
        PlannedStartDate = String.valueOf(objProject.Planned_Start_Date__c);
        PlannedEndDate = String.valueOf(objProject.Planned_End_Date__c);
        TypeWork = objProject.Type_of_Work__c;

        List<Estimate__C> lstEstimate = new List<Estimate__C>();      
        lstEstimate = [select id,name,offering__c,Capability_Work_Stream__c from Estimate__C where Project__r.id =: ProjectId ];
        
        decimal tempTotalBusinessModelling = 0.0;
        decimal tempTotalSystemDesign = 0.0;
        decimal tempTotalImplementation = 0.0;
        decimal tempTotalTesting = 0.0;
        decimal tempTotalDeployment = 0.0;
        decimal tempGrandTotal = 0.0;
            
        for(Estimate__C est: lstEstimate){
            lstConfiguration = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM Configuration__c 
                                where 
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                                ];

            
            
            lstReportDashboard = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM Report_and_Dashboard__c 
                                where 
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                               ];
            
            lstUserAdministration = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM User_Administration__c 
                                where
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                               ];
            
            lstWorkflowAndApproval = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM Workflow_and_Approval__c 
                                where 
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                               ];
            lstCustomization = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM Customization__c 
                                where 
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                               ];
            
            lstDataMigration = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM Data_Migration__c 
                                where
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                               ];
            
            lstIntegrationBatch = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM Integration_Batch__c 
                                where
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                                  ];
            
            lstIntegrationRealTime = [SELECT Id,Name,Business_Modelling__c,System_Design__c,Implementation__c,Testing__c,Deployment__c,
                                Offering__C,Capability__c,Configuration__c,Estimate__c,Estimating_Factor__c 
                                FROM Integration_Real_Time__c 
                                where
                                //Offering__C =: est.offering__c and
                                Capability__c=:est.Capability_Work_Stream__c
                               ];
 
            system.debug('____ConfigLst_____ ' + lstConfiguration.size());
            system.debug('____ReportDashLst_____ ' + lstReportDashboard.size());
            system.debug('____UserAdminLst_____ ' + lstUserAdministration.size());
            system.debug('____WorkflowAppLst_____ ' + lstWorkflowAndApproval.size());
            
            system.debug('____CustomizationLst_____ ' + lstCustomization.size());
            system.debug('____DataMigrationLst_____ ' + lstDataMigration.size());            
            system.debug('____IntegrationBatch_____ ' + lstIntegrationBatch.size());            
            system.debug('____IntegrationRealTime_____ ' + lstIntegrationRealTime.size());            

         
            WrapperOuterClass woc = new WrapperOuterClass();
            
            woc.capability = est.Capability_Work_Stream__c;
            
            if(lstConfiguration.size() > 0){
                for(Configuration__c lstCon :lstConfiguration ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }

            if(lstReportDashboard.size() > 0){
                for(Report_and_Dashboard__c lstCon :lstReportDashboard ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }

            if(lstUserAdministration.size() > 0){
                for(User_Administration__c lstCon :lstUserAdministration ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }

            if(lstWorkflowAndApproval.size() > 0){
                for(Workflow_and_Approval__c lstCon :lstWorkflowAndApproval ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }

            if(lstCustomization.size() > 0){
                for(Customization__c lstCon :lstCustomization ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }

            if(lstDataMigration.size() > 0){
                for(Data_Migration__c lstCon :lstDataMigration ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }

            if(lstIntegrationBatch.size() > 0){
                for(Integration_Batch__c lstCon :lstIntegrationBatch ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }

            if(lstIntegrationRealTime.size() > 0){
                for(Integration_Real_Time__c lstCon :lstIntegrationRealTime ){
                    WrapperInnerClass wic = new WrapperInnerClass();
                    wic.Component = lstCon.Configuration__c;
                    wic.BusinessModelling = lstCon.Business_Modelling__c;
                    wic.SystemDesign = lstCon.System_Design__c;
                    wic.Implementation = lstCon.Implementation__c;
                    wic.Testing = lstCon.Testing__c;
                    wic.Deployment = lstCon.Deployment__c;
                    wic.HorizentalTotal = lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;
                    
                    tempTotalBusinessModelling = tempTotalBusinessModelling + lstCon.Business_Modelling__c;
                    tempTotalSystemDesign = tempTotalSystemDesign + lstCon.System_Design__c;
                    tempTotalImplementation = tempTotalImplementation + lstCon.Implementation__c;
                    tempTotalTesting = tempTotalTesting + lstCon.Testing__c;
                    tempTotalDeployment = tempTotalDeployment + lstCon.Deployment__c;
                    tempGrandTotal = tempGrandTotal + lstCon.Business_Modelling__c + lstCon.System_Design__c 
                        + lstCon.Implementation__c + lstCon.Testing__c + lstCon.Deployment__c;

                    woc.wrapperInnerClassLst.add(wic);
                    Show = true;
                }
            }
            
            if( lstConfiguration.size() > 0 || lstReportDashboard.size() > 0 
             || lstUserAdministration.size() > 0 || lstWorkflowAndApproval.size() > 0 
             || lstCustomization.size() > 0 || lstDataMigration.size() > 0 
             || lstIntegrationBatch.size() > 0 || lstIntegrationRealTime.size() > 0 ){
                wrapperOuterClassLst.add(woc);
            }
        }
        WrapperBottomTotalClass wrapperBottomTotalClassObj = new WrapperBottomTotalClass();
        wrapperBottomTotalClassObj.TotalCapability = 'Total Effort (Hours)';
        wrapperBottomTotalClassObj.TotalBusinessModelling = tempTotalBusinessModelling;
        wrapperBottomTotalClassObj.TotalSystemDesign = tempTotalSystemDesign;
        wrapperBottomTotalClassObj.TotalImplementation = tempTotalImplementation;
        wrapperBottomTotalClassObj.TotalTesting = tempTotalTesting;
        wrapperBottomTotalClassObj.TotalDeployment = tempTotalDeployment;
        wrapperBottomTotalClassObj.GrandTotal = tempGrandTotal;
        
        wrapperBottomTotalClassLst.add(wrapperBottomTotalClassObj);
        
        Show = true;         
    }  

    public class WrapperOuterClass {
        public string capability {get; set;}
    
        public List<WrapperInnerClass> wrapperInnerClassObj = new List<WrapperInnerClass>();
        public List<WrapperInnerClass> wrapperInnerClassLst { get{return wrapperInnerClassObj;} set{wrapperInnerClassObj = value;}}        
    }
    
    public class WrapperInnerClass {
        public string Component {get; set;}
        public decimal BusinessModelling {get; set;}
        public decimal SystemDesign {get; set;}
        public decimal Implementation {get; set;}
        public decimal Testing {get; set;}
        public decimal Deployment {get; set;}
        public decimal HorizentalTotal {get; set;}        
    }

    public class WrapperBottomTotalClass
    {
        public string  TotalCapability { get ; set; }
        public decimal TotalBusinessModelling {get; set;}
        public decimal TotalSystemDesign {get; set;}
        public decimal TotalImplementation {get; set;}
        public decimal TotalTesting {get; set;}
        public decimal TotalDeployment {get; set;}
        public decimal GrandTotal{ get ; set; }
    }    
}