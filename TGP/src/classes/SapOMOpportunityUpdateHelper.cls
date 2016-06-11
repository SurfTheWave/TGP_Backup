public class SapOMOpportunityUpdateHelper{

    private static boolean hasAlreadyExecuted = false;

    public static boolean hasAlreadyTriggerExecuted(){
        return hasAlreadyExecuted ;
    }
    
    public static void setHasAlreadyExecuted() {
        hasAlreadyExecuted = true;
    }

    //public static String getFollowUpSubject(String subject) {
      //  return 'Follow Up: ' + subject;
    //}
}