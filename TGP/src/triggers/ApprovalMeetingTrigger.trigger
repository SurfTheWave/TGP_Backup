/*****************
@author : Ezdhan Hussain S.K
@description : Trigger to handle All Automation Logic on Approval Meeting Sobject


*******************/
trigger ApprovalMeetingTrigger on Approval_Meeting__c(after insert, after update, after delete) {
static string runtriggerstring = label.runapprovalmeetintrigger;
boolean runtrigger = boolean.valueof(runtriggerstring);
    //creating handler to invoke logic in class
    if(runtrigger ){
    ApprovalMeetingScheduling meet_handler = new ApprovalMeetingScheduling();
    if (trigger.isafter) {
        if (trigger.isinsert) {
            meet_handler.populateFieldsonInsert(trigger.new);
            //Below invocation is not bulkified as per the requirement
            meet_handler.populateMeetingApprover(trigger.new[0]);
        }
        if (ApprovalMeetingScheduling.runOnce()) {
            if (trigger.isupdate) {
                meet_handler.reSubmitApprovalMeeting(trigger.new, trigger.oldmap);
                // meet_handler.sendMailWhenSubmitted(trigger.new,trigger.oldmap);
                //meet_handler.checkMeetingStatus(trigger.new, trigger.oldmap);
            }
        } else {
            //Empty Else Statement?
            // system.debug('Recursive Trigger is stopped'); 
        }
        if (trigger.isdelete) {
            meet_handler.DeleteApprovalcalendarevents(trigger.old);
        }
    }
    }
}