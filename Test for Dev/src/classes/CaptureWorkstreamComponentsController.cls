public class CaptureWorkstreamComponentsController{

    public Estimate__C objEstimate {get; set;}
    public Estimating_Factor__c objEstimatingFactor {get; set;}
    String ids;
    
    public Boolean rend{get;set;}

    String strProjectName {get; set;}
    String strOffering {get; set;}
    String strCapabilityWorkStream {get; set;}
    String strMethodology {get; set;}
    String strCustomObjectName {get; set;}
    String[] lstComponents {get; set;}

    public Configuration__c objConfiguration{get;set;}
    public Workflow_and_Approval__C objWorkflowAndApproval {get; set;}
    public User_Administration__C objUserAdministration {get; set;}
    public Report_And_Dashboard__C objReportAndDashboard {get; set;}
    public Customization__C objCustomization {get; set;}
    public Data_Migration__C objDataMigration {get; set;}
    public Integration_Batch__c objIntegrationBatch {get; set;}
    public Integration_Real_Time__c objIntegrationRealTime {get; set;}
    
    public String strCapabilityConfiguration;   
    public String strCapabilityWorkflowAndApproval;   
    public String strCapabilityUserAdministration;   
    public String strCapabilityReportAndDashboard;   
    public String strCapabilityCustomization;   
    public String strCapabilityDataMigration;   
    public String strCapabilityIntegrationBatch;   
    public String strCapabilityIntegrationRealTime;  
    
    public CaptureWorkstreamComponentsController(ApexPages.StandardController controller){
        objEstimate = (Estimate__C)controller.getRecord();
        ids = apexpages.currentPage().getParameters().get('retURL');
    }
    
    public PageReference FillDetails(){
        rend=true;
        strProjectName = objEstimate.Project__c;
        
        if(strProjectName != '' && strProjectName != null){
        
            strCapabilityWorkStream = objEstimate.Capability_Work_Stream__c;
            strMethodology = objEstimate.Methodology__c;
            strOffering = objEstimate.Offering__c;
			strCustomObjectName = objEstimate.Custom_Object_Name__c;
			
            List<Estimate__C> lstEstimate = [SELECT Offering__c, Capability_Work_Stream__c, Components__c, Methodology__c, Custom_Object_Name__c, Id, Name, Project__c FROM Estimate__c where Project__c =: strProjectName and offering__c =: strOffering and Capability_Work_Stream__c =: strCapabilityWorkStream and Methodology__c =: strMethodology];            

            
            if(lstEstimate.size() == 0){
				if(strCapabilityWorkStream == 'Custom Object (Other)'){
                    if((strCustomObjectName != null && strCustomObjectName != '')){
                    	insert objEstimate;   
                    }else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter the Custom Object Name '); 
                        ApexPages.addMessage(myMsg);
                        rend = false;
                        return null;
                    }
                }
                insert objEstimate;
			}
			
                
                
			if(objEstimate.Components__c != null){
					lstComponents = objEstimate.Components__c.split(';',0);                 
                if (lstComponents != null && lstComponents.size() > 0){

                    for (integer i = 0; i < lstComponents.size(); i++){
                    
                        if(lstComponents[i].equals('Configuration')){
                            strCapabilityConfiguration = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objConfiguration = new Configuration__c();
                        }
                        if(lstComponents[i].equals('Workflow and Approval')){
                            strCapabilityWorkflowAndApproval = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objWorkflowAndApproval = new Workflow_and_Approval__C();
                        }
                        if(lstComponents[i].equals('User Administration')){
                            strCapabilityUserAdministration = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objUserAdministration = new User_Administration__C();
                        }
                        if(lstComponents[i].equals('Report and Dashboard')){
                            strCapabilityReportAndDashboard = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objReportAndDashboard = new Report_And_Dashboard__C();
                        }
                        if(lstComponents[i].equals('Customization')){
                            strCapabilityCustomization = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objCustomization = new Customization__C();
                        }
                        if(lstComponents[i].equals('Data Migration')){
                            strCapabilityDataMigration = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objDataMigration = new Data_Migration__C();
                        }
                        if(lstComponents[i].equals('Integration (Batch)')){
                            strCapabilityIntegrationBatch = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objIntegrationBatch = new Integration_Batch__c();
                        }
                        if(lstComponents[i].equals('Integration (Real Time)')){
                            strCapabilityIntegrationRealTime = strOffering + '_' + strCapabilityWorkStream + '_' + lstComponents[i] + '_'+ strMethodology;
                            objIntegrationRealTime = new Integration_Real_Time__c();
                        }
                    }
                }
				
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Capability : ' + strCapabilityWorkStream +' exists for this Project. '); 
                
                rend = false;
                ApexPages.addMessage(myMsg); 
            }
        }
        //strCapabilityWorkStream = objEstimate.Capability_Work_Stream__c;
        //strCustomObjectName = objEstimate.Custom_Object_Name__c;
        return null;
    }

	//method is invoked on click of CANCEL button
    public PageReference Cancel(){
         return new PageReference('/'+ApexPages.currentPage().getParameters().get('retURL').substring(1,16));
    }

    
    public PageReference save() {
        try{
            if(objEstimate != null){
            
                List<Estimating_Factor__c> EstimatingFactor = null;
                
                if(objConfiguration != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityConfiguration ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objConfiguration.Estimating_Factor__c = EstimatingFactor[0].id;
                        objConfiguration.configuration__c = EstimatingFactor[0].component__c;
                        objConfiguration.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objConfiguration.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objConfiguration.Definition_Complex__c = EstimatingFactor[0].Complex__c;
                        EstimatingFactor = null;
                        objConfiguration.Estimate__c = objEstimate.id;
                        objConfiguration.Offering__c = objEstimate.Offering__c;
                        objConfiguration.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objConfiguration.Methodology__c = objEstimate.Methodology__c;
                        insert objConfiguration;
                    }
                }   

                if(objWorkflowAndApproval != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityWorkflowAndApproval ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objWorkflowAndApproval.Estimating_Factor__c = EstimatingFactor[0].id;
                        objWorkflowAndApproval.configuration__c = EstimatingFactor[0].component__c;
                        objWorkflowAndApproval.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objWorkflowAndApproval.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objWorkflowAndApproval.Definition_Complex__c = EstimatingFactor[0].Complex__c;                      
                        EstimatingFactor = null;
                        objWorkflowAndApproval.Estimate__c = objEstimate.id;
                        objWorkflowAndApproval.Offering__c = objEstimate.Offering__c;
                        objWorkflowAndApproval.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objWorkflowAndApproval.Methodology__c = objEstimate.Methodology__c;

                        insert objWorkflowAndApproval;
                    }
                }   

                if(objUserAdministration != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityUserAdministration ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objUserAdministration.Estimating_Factor__c = EstimatingFactor[0].id;
                        objUserAdministration.configuration__c = EstimatingFactor[0].component__c;
                        objUserAdministration.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objUserAdministration.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objUserAdministration.Definition_Complex__c = EstimatingFactor[0].Complex__c;                       
                        EstimatingFactor = null;
                        objUserAdministration.Estimate__c = objEstimate.id;
                        objUserAdministration.Offering__c = objEstimate.Offering__c;
                        objUserAdministration.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objUserAdministration.Methodology__c = objEstimate.Methodology__c;

                        insert objUserAdministration;
                    }
                }               

                if(objReportAndDashboard != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityReportAndDashboard ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objReportAndDashboard.Estimating_Factor__c = EstimatingFactor[0].id;
                        objReportAndDashboard.configuration__c = EstimatingFactor[0].component__c;
                        objReportAndDashboard.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objReportAndDashboard.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objReportAndDashboard.Definition_Complex__c = EstimatingFactor[0].Complex__c;   
                        EstimatingFactor = null;
                        objReportAndDashboard.Estimate__c = objEstimate.id;
                        objReportAndDashboard.Offering__c = objEstimate.Offering__c;
                        objReportAndDashboard.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objReportAndDashboard.Methodology__c = objEstimate.Methodology__c;

                        insert objReportAndDashboard;
                    }
                } 

                if(objCustomization != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityCustomization ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objCustomization.Estimating_Factor__c = EstimatingFactor[0].id;
                        objCustomization.configuration__c = EstimatingFactor[0].component__c;
                        objCustomization.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objCustomization.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objCustomization.Definition_Complex__c = EstimatingFactor[0].Complex__c;                            
                        EstimatingFactor = null;
                        objCustomization.Estimate__c = objEstimate.id;
                        objCustomization.Offering__c = objEstimate.Offering__c;
                        objCustomization.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objCustomization.Methodology__c = objEstimate.Methodology__c;
                        insert objCustomization;
                    }
                }               

                if(objDataMigration != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityDataMigration ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objDataMigration.Estimating_Factor__c = EstimatingFactor[0].id;
                        objDataMigration.configuration__c = EstimatingFactor[0].component__c;
                        objDataMigration.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objDataMigration.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objDataMigration.Definition_Complex__c = EstimatingFactor[0].Complex__c;                        
                        EstimatingFactor = null;
                        objDataMigration.Estimate__c = objEstimate.id;
                        objDataMigration.Offering__c = objEstimate.Offering__c;
                        objDataMigration.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objDataMigration.Methodology__c = objEstimate.Methodology__c;

                        insert objDataMigration;
                    }
                } 

                if(objIntegrationBatch != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityIntegrationBatch ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objIntegrationBatch.Estimating_Factor__c = EstimatingFactor[0].id;
                        objIntegrationBatch.configuration__c = EstimatingFactor[0].component__c;
                        objIntegrationBatch.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objIntegrationBatch.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objIntegrationBatch.Definition_Complex__c = EstimatingFactor[0].Complex__c;                     
                        EstimatingFactor = null;
                        objIntegrationBatch.Estimate__c = objEstimate.id;
                        objIntegrationBatch.Offering__c = objEstimate.Offering__c;
                        objIntegrationBatch.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objIntegrationBatch.Methodology__c = objEstimate.Methodology__c;

                        insert objIntegrationBatch;
                    }
                } 

                if(objIntegrationRealTime != null){
                    EstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C from Estimating_Factor__c where Estimating_Factor_ExternalID__c = :strCapabilityIntegrationRealTime ];
                   
                    if(EstimatingFactor != null && EstimatingFactor.size() > 0){
                        objIntegrationRealTime.Estimating_Factor__c = EstimatingFactor[0].id;
                        objIntegrationRealTime.configuration__c = EstimatingFactor[0].component__c;
                        objIntegrationRealTime.Definition_Simple__c = EstimatingFactor[0].Simple__c;
                        objIntegrationRealTime.Definition_Medium__c = EstimatingFactor[0].Medium__c;
                        objIntegrationRealTime.Definition_Complex__c = EstimatingFactor[0].Complex__c;                      
                        EstimatingFactor = null;
                        objIntegrationRealTime.Estimate__c = objEstimate.id;
                        objIntegrationRealTime.Offering__c = objEstimate.Offering__c;
                        objIntegrationRealTime.Capability__c = objEstimate.Capability_Work_Stream__c;
                        objIntegrationRealTime.Methodology__c = objEstimate.Methodology__c;

                        insert objIntegrationRealTime;
                    }
                }               
            }
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        PageReference p=new PageReference('/'+ids);
        return p;
    }
    
}