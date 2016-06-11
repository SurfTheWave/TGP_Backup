/*
@Author : 
@name : RecursiveTriggerHelper
@CreateDate :  12/29/2014 12:49 AM
@Description : 
@Version : 
*/

public with sharing class RecursiveTriggerHelper {
 
    // initialize a variable to hold state  
    /*private static boolean alreadyModified = false;
    
    // get the state
    public static boolean isAlreadyModified() {
        return alreadyModified;
    }
    
    // set this to true to keep track of and avoid recursive updates.  Generally set after first time through
    // a trigger.  We can access this in the trigger and avoid recursive updates...
    public static void setAlreadyModified() {
        alreadyModified = true;
    }*/
    
/*
@Author : 
@name : RecursiveTriggerHelper
@CreateDate :  12/29/2014 12:49 AM
@Description : 
@Version : 
*/
   public static boolean run = true;
    public static boolean runOnce() {
        if (run) {
            run = false;
            return true;
        } else {
            return run;
        }
        return null;
    }
}