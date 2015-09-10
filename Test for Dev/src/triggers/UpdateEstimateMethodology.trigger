trigger UpdateEstimateMethodology on Estimate__C (after update) {
    If(Trigger.isUpdate){
        Set<ID> ids = Trigger.newMap.keySet();
        List<Estimate__C> updatedEstimate = [SELECT Id, Methodology__C, 
		(select id, Methodology__c from Configuration__r),
		(select id, Methodology__c from Workflow_and_Approval__r),
		(select id, Methodology__c from User_Administrations__r),
		(select id, Methodology__c from Report_and_Dashboards__r),
		(select id, Methodology__c from Customization__r),
		(select id, Methodology__c from Data_Migrations__r ),
		(select id, Methodology__c from Integration_Batch__r),
		(select id, Methodology__c from Integration_Real_Time__r)                                             
 		FROM Estimate__C WHERE Id in :ids];
    
        List<Configuration__C> configurationToUpdate = new List<Configuration__C>();
		List<Workflow_and_Approval__c> WorkflowAndApprovalToUpdate = new List<Workflow_and_Approval__c>();
		List<User_Administration__c> UserAdministrationToUpdate = new List<User_Administration__c>();
		List<Report_and_Dashboard__c> ReportAndDashboardToUpdate = new List<Report_and_Dashboard__c>();
		List<Customization__c> CustomizationToUpdate = new List<Customization__c>();
		List<Data_Migration__c> DataMigrationToUpdate = new List<Data_Migration__c>();
		List<Integration_Batch__c> IntegrationBatchToUpdate = new List<Integration_Batch__c>();
		List<Integration_Real_Time__c> IntegrationRealTimeToUpdate = new List<Integration_Real_Time__c>();
        
        for(Estimate__C est : updatedEstimate){
            for (Configuration__C con : est.Configuration__r){
                if(con.Methodology__c != est.Methodology__C){
                    con.Methodology__c = est.Methodology__C;
                    configurationToUpdate.add(con);
                }
            }
			for (Workflow_and_Approval__c wna : est.Workflow_and_Approval__r){
                if(wna.Methodology__c != est.Methodology__C){
                    wna.Methodology__c = est.Methodology__C;
                    WorkflowAndApprovalToUpdate.add(wna);
                }
            }
			for (User_Administration__c ua : est.User_Administrations__r){
                if(ua.Methodology__c != est.Methodology__C){
                    ua.Methodology__c = est.Methodology__C;
                    UserAdministrationToUpdate.add(ua);
                }
            }
			for (Report_and_Dashboard__c rnd : est.Report_and_Dashboards__r){
                if(rnd.Methodology__c != est.Methodology__C){
                    rnd.Methodology__c = est.Methodology__C;
                    ReportAndDashboardToUpdate.add(rnd);
                }
            }
			for (Customization__c cus : est.Customization__r){
                if(cus.Methodology__c != est.Methodology__C){
                    cus.Methodology__c = est.Methodology__C;
                    CustomizationToUpdate.add(cus);
                }
            }
			for (Data_Migration__c dm : est.Data_Migrations__r){
                if(dm.Methodology__c != est.Methodology__C){
                    dm.Methodology__c = est.Methodology__C;
                    DataMigrationToUpdate.add(dm);
                }
            }
			for (Integration_Batch__c ib : est.Integration_Batch__r){
                if(ib.Methodology__c != est.Methodology__C){
                    ib.Methodology__c = est.Methodology__C;
                    IntegrationBatchToUpdate.add(ib);
                }
            }
			for (Integration_Real_Time__c irt : est.Integration_Real_Time__r){
                if(irt.Methodology__c != est.Methodology__C){
                    irt.Methodology__c = est.Methodology__C;
                    IntegrationRealTimeToUpdate.add(irt);
                }
            }
		}
        if(!configurationToUpdate.isEmpty()){
            update configurationToUpdate;
        }
		if(!WorkflowAndApprovalToUpdate.isEmpty()){
            update WorkflowAndApprovalToUpdate;
        }
		if(!UserAdministrationToUpdate.isEmpty()){
            update UserAdministrationToUpdate;
        }
		if(!ReportAndDashboardToUpdate.isEmpty()){
            update ReportAndDashboardToUpdate;
        }
		if(!CustomizationToUpdate.isEmpty()){
            update CustomizationToUpdate;
        }
		if(!DataMigrationToUpdate.isEmpty()){
            update DataMigrationToUpdate;
        }
		if(!IntegrationBatchToUpdate.isEmpty()){
            update IntegrationBatchToUpdate;
        }
		if(!IntegrationRealTimeToUpdate.isEmpty()){
            update IntegrationRealTimeToUpdate;
        }
    }
}