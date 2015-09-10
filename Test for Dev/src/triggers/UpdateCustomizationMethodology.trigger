trigger UpdateCustomizationMethodology on Customization__c (before update, after update, before insert, after insert) {

    if (Trigger.isBefore) {
    }
    
    if (Trigger.isAfter) {
        If(Trigger.isUpdate){
            //if(checkRecursive.runOnce()){
                String strOfferingCapabilityConfigurationMethodology;
                List<Customization__c> lstObjToUpdate = new List<Customization__c>();
                Set<ID> ids = Trigger.newMap.keySet();
				List<Customization__c> lstCangedConfiguration = [SELECT Id, Methodology__C FROM Customization__c WHERE Id in :ids];
                for(Customization__c chCon : lstCangedConfiguration){
                    if(Trigger.oldMap.get(chCon.Id) != Trigger.newMap.get(chCon.Id)){
                        lstObjToUpdate.add(chCon);
                    }
                }
                if (lstObjToUpdate.isEmpty() == false) {
                    Database.update(lstObjToUpdate);

                    List<Estimate__c> lstEstimate = new List<Estimate__c>();
                    List<Estimating_Factor__c> lstEstimatingFactor = new List<Estimating_Factor__c>();                
                    
                    Estimate__c objEstimate;
                    Estimating_Factor__c objEstimatingFactor;
                    Customization__c obj;
                    
                    List<Customization__c> lstObjToBeInserted = new List<Customization__c>();
                    List<Customization__c> lstObjToBeDeleted = new List<Customization__c>();
                    
                    List<Customization__c> lstUpdatedConfiguration = [SELECT Id, Name, 
                                                                      Offering__C, Capability__C, Configuration__C, Methodology__C,
                                                                      Number_Of_Components_Simple__c, Number_Of_Components_Medium__c, Number_Of_Components_Complex__c,
                                                                      Contingency_Simple__c, Contingency_Medium__c, Contingency_Complex__c,
                                                                      Definition_Simple__c, Definition_Medium__c, Definition_Complex__c,
                                                                      Scope_Simple__c, Scope_Medium__c, Scope_Complex__c,
                                                                      Estimating_Factor__r.id, Estimating_Factor__r.name, Estimating_Factor__r.Estimating_Factor_ExternalID__c, 
                                                                      Estimate__r.id
                                                                      FROM Customization__c WHERE Id in :lstObjToUpdate];
                    
                    for(Customization__c con : lstUpdatedConfiguration){
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

                                obj = new Customization__c();
                                obj.Number_Of_Components_Simple__c = con.Number_Of_Components_Simple__c;
                                obj.Number_Of_Components_Medium__c = con.Number_Of_Components_Medium__c;
                                obj.Number_Of_Components_Complex__c = con.Number_Of_Components_Complex__c;
                                obj.Contingency_Simple__c = con.Contingency_Simple__c;
                                obj.Contingency_Medium__c = con.Contingency_Medium__c;
                                obj.Contingency_Complex__c = con.Contingency_Complex__c;
                                obj.Definition_Simple__c = con.Definition_Simple__c;
                                obj.Definition_Medium__c = con.Definition_Medium__c;
                                obj.Definition_Complex__c = con.Definition_Complex__c;
                                obj.Scope_Simple__c = con.Scope_Simple__c;
                                obj.Scope_Medium__c = con.Scope_Medium__c;
                                obj.Scope_Complex__c = con.Scope_Complex__c;
                                obj.Offering__c = con.Offering__c;
                                obj.Capability__c = con.Capability__c;
                                obj.Configuration__c = con.Configuration__c;
                                obj.Methodology__c = con.Methodology__c;
                                obj.Estimate__c = objEstimate.id;
                                obj.Estimating_Factor__c = objEstimatingFactor.id;
                                
                                lstObjToBeInserted.add(obj);
                                lstObjToBeDeleted.add(con);
                            }
                        }
                    }
					if(lstObjToBeInserted !=null && lstObjToBeInserted.size() > 0 && lstObjToBeDeleted !=null && lstObjToBeDeleted.size() > 0 ){
						insert lstObjToBeInserted;
						delete lstObjToBeDeleted;
					}
                }
           // }
        }
	}
}