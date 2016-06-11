global class scheduledMonthlyGoLiveFTEUpdate implements Schedulable {
   global void execute(SchedulableContext sc) {
      MonthlyGoLiveFTEUpdate b = new MonthlyGoLiveFTEUpdate();
      database.executebatch(b,10);
      
   }
}