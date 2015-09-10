trigger UpdateProjectMethodology on Projects__c (after update) {
    If(Trigger.isUpdate){
        Set<ID> ids = Trigger.newMap.keySet();
        List<Projects__C> updatedProject = [SELECT Id, Methodology__C, (select id, Methodology__c from Estimates__r) FROM Projects__C WHERE Id in :ids];
    
        List<Estimate__C> estimateToUpdate = new List<Estimate__C>();
        
        for(Projects__C prj : updatedProject){
            for (Estimate__C est : prj.Estimates__r){
                if(est.Methodology__c != prj.Methodology__C){
                    est.Methodology__c = prj.Methodology__C;
                    estimateToUpdate.add(est);
                }
            }
        }
        if(!estimateToUpdate.isEmpty()){
            update estimateToUpdate;
        }
    }
}