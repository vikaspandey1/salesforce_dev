global class ProcessAccs implements Schedulable{

  global void execute(SchedulableContext sc) {
  
  
 LicenseOptimizer_BatchClass pa= new LicenseOptimizer_BatchClass();
//String cronStr = '0 0,0 * * * *';
//System.schedule('Process Accs Job', cronStr, pa);
   database.executebatch(pa);
  }
  
  }