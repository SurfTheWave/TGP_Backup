/**
 * @author     ::Apoorva Sharma
 * @Method     ::taskComplete
 * @Description::This class changes the task status to complete
 * @Date       ::1/5/2015
 * @Version    ::<1.0>
 */
public with sharing class UtilTaskComplete {
    /**
     * @description       This method delete the task from the queue of the user by setting status as completed
     * @param             objid: Object ID details realted to Task standard object
     * @return            void 
     * @throws            NA
     */
    public static void taskComplete(String objid) {
        try {
            List < Task > tasklist = [SELECT id, Status FROM task 
                                        WHERE what.id = : objid limit 5000];
            for (Task t: tasklist) {
                integer i = 0;
                tasklist[i].status = UtilConstantsforSWB.COMPLETED;
                i++;
            }
            database.update(tasklist, false);
        } catch (Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //System.debug(''+e);
        }
    }

    /**
     * @description       This method Delete all previous tasks 
     * @param             set<ID> of Object Id: Object ID details realted to Task standard object
     * @return            void 
     * @throws            NA
     */
    public static void taskCompleteList(set < ID > objid) {
        List < Task > tasklist = [SELECT id, Status FROM task
                                    WHERE what.id in : objid and IsRecurrence = true limit 5000];
        try {
            database.delete(tasklist, false);
        } catch (Exception e) {
            String ErrorMsg = e.getMessage() + e.getStackTraceString(); throw (e);
            //System.debug(''+e);
        }
    }
}