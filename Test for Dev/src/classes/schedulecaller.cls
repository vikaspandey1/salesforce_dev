global class schedulecaller implements Schedulable{
     global void execute(SchedulableContext sc) {
       
   
   //LicenseOptimizer_BatchClass2 sch = new LicenseOptimizer_BatchClass2();
   Database.executeBatch(new LicenseOptimizer_BatchClass2());
        
     }
  }