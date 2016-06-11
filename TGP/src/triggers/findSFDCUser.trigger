/*
Name : findSFDCUser 
Description : This trigger will automatically find the User Type (SFDC/Non-SFDC) from Users
Author :  Mayank Tayal
User Story:    SOL_143

Updated by        Update date        User story
-----------    ------------------  --------------

*/
trigger findSFDCUser on Approver_Master__c (before insert, before update) {
    try{
        FindSFDCApprovers.searchSFDCUser(Trigger.new);
    }
    catch(Exception e)
    {
        Trigger.New[0].addError(e.getMessage());
    }
}