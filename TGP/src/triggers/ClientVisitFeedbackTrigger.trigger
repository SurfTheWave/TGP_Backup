trigger ClientVisitFeedbackTrigger on Client_Visit_Feedback__c (after insert) {

    if(trigger.isAfter){

        If(trigger.isInsert){
        ClientVisitFeedback feedback=new ClientVisitFeedback();
        feedback.updateCentertobeVisited(trigger.new);
        ClientVisitFeedback.sendEmailonCreate(trigger.new);
        }    

}


}