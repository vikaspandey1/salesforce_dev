trigger UpdateConfigurationMethodology on Configuration__C (before update, after update, before insert, after insert) {

    if (Trigger.isBefore) {

    }
    
    if (Trigger.isAfter) {
        If(Trigger.isUpdate){
           // if(checkRecursive.runOnce()){
                String strOfferingCapabilityConfigurationMethodology;
                List<Configuration__c> lstConfigurationToUpdate = new List<Configuration__c>();
                Set<ID> ids = Trigger.newMap.keySet();
				List<Configuration__c> lstChangedConfiguration = [SELECT Id, Methodology__C FROM Configuration__c WHERE Id in :ids];
    
                for(Configuration__c chCon : lstChangedConfiguration){
                    if(Trigger.oldMap.get(chCon.Id) != Trigger.newMap.get(chCon.Id)){
                        lstConfigurationToUpdate.add(chCon);
                    }
                }
                
                if (lstConfigurationToUpdate.isEmpty() == false) {
                    Database.update(lstConfigurationToUpdate);

                    List<Estimate__c> lstEstimate = new List<Estimate__c>();
                    List<Estimating_Factor__c> lstEstimatingFactor = new List<Estimating_Factor__c>();                
                    
                    Estimate__c objEstimate;
                    Configuration__c objConfiguration;
                    Estimating_Factor__c objEstimatingFactor;
                    
                    List<Configuration__c> lstObjToBeInserted = new List<Configuration__c>();
                    List<Configuration__c> lstObjToBeDeleted = new List<Configuration__c>();
                    
                    List<Configuration__c> lstUpdatedConfiguration = [SELECT Id, Name, 
                                                                      Offering__C, Capability__C, Configuration__C, Methodology__C,
                                                                      Number_Of_Components_Simple__c, Number_Of_Components_Medium__c, Number_Of_Components_Complex__c,
                                                                      Contingency_Simple__c, Contingency_Medium__c, Contingency_Complex__c,
                                                                      Definition_Simple__c, Definition_Medium__c, Definition_Complex__c,
                                                                      Scope_Simple__c, Scope_Medium__c, Scope_Complex__c,
                                                                      Estimating_Factor__r.id, Estimating_Factor__r.name, Estimating_Factor__r.Estimating_Factor_ExternalID__c, 
                                                                      Estimate__r.id, Test_Me__c 
                                                                      FROM Configuration__c WHERE Id in :lstConfigurationToUpdate];
                    
                    for(Configuration__c con : lstUpdatedConfiguration){
                        strOfferingCapabilityConfigurationMethodology = con.Offering__C + '_' + con.Capability__C + '_' + con.Configuration__C + '_'+ con.Methodology__C;

                        if(strOfferingCapabilityConfigurationMethodology != con.Estimating_Factor__r.Estimating_Factor_ExternalID__c){
                            
                            objEstimate = new Estimate__c();
                            objEstimatingFactor = new Estimating_Factor__c();
                            
                            lstEstimate = [select id, Offering__c,Capability_Work_Stream__c from Estimate__c where id =: con.Estimate__r.id];
                            lstEstimatingFactor = [select id, component__c, Estimating_Factor_ExternalID__c, name, Simple__c, Medium__c, Complex__C 
                                                   from Estimating_Factor__c 
                                                   where Estimating_Factor_ExternalID__c = :strOfferingCapabilityConfigurationMethodology];
                            
                            if(lstEstimate !=null && lstEstimate.size() > 0 && lstEstimatingFactor !=null && lstEstimatingFactor.size() > 0 ){
                                objEstimate = lstEstimate[0];
                                objEstimatingFactor = lstEstimatingFactor[0];

                                objConfiguration = new Configuration__c();
                                objConfiguration.Number_Of_Components_Simple__c = con.Number_Of_Components_Simple__c;
                                objConfiguration.Number_Of_Components_Medium__c = con.Number_Of_Components_Medium__c;
                                objConfiguration.Number_Of_Components_Complex__c = con.Number_Of_Components_Complex__c;
                                objConfiguration.Contingency_Simple__c = con.Contingency_Simple__c;
                                objConfiguration.Contingency_Medium__c = con.Contingency_Medium__c;
                                objConfiguration.Contingency_Complex__c = con.Contingency_Complex__c;
                                objConfiguration.Definition_Simple__c = con.Definition_Simple__c;
                                objConfiguration.Definition_Medium__c = con.Definition_Medium__c;
                                objConfiguration.Definition_Complex__c = con.Definition_Complex__c;
                                objConfiguration.Scope_Simple__c = con.Scope_Simple__c;
                                objConfiguration.Scope_Medium__c = con.Scope_Medium__c;
                                objConfiguration.Scope_Complex__c = con.Scope_Complex__c;
                                objConfiguration.Offering__c = con.Offering__c;
                                objConfiguration.Capability__c = con.Capability__c;
                                objConfiguration.Configuration__c = con.Configuration__c;
                                objConfiguration.Methodology__c = con.Methodology__c;
                                objConfiguration.Estimate__c = objEstimate.id;
                                objConfiguration.Estimating_Factor__c = objEstimatingFactor.id;
                                
                                lstObjToBeInserted.add(objConfiguration);
                                lstObjToBeDeleted.add(con);
                            }
                        }
                    }
					if(lstObjToBeInserted !=null && lstObjToBeInserted.size() > 0 && lstObjToBeDeleted !=null && lstObjToBeDeleted.size() > 0 ){
						insert lstObjToBeInserted;
						delete lstObjToBeDeleted;
					}
                }
            //}
        }
	}
}