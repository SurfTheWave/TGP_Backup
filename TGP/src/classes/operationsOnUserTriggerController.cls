/*
 * @Author : Jyotsna
 * @CreateDate : 1/4/2015 11:11 PM
 * @Description : Helper class for  operationsOnUser Trigger
 * @Version : 1.0
 */
public without sharing class operationsOnUserTriggerController {


    public static Map < String, User_Master__c > userMasterMap = new Map < String, User_Master__c > ();
    public static Set < Id > mappedUserSet = new Set < Id > ();
    public static Map < Id, User > oldUserMap;
    public static Set < String > testemailIds = new Set < String > ();
    /******************************
    Method Name: checkForDuplicateUser
    Description:  Method to fetch usermaster records to check for duplicate records
    Paramenters: List<User> userList
    Return Value: void 
    *******************************/
    public static void checkForDuplicateUser(List < User > userMap) {
    
        Set < String > emailIds = new Set < String > ();
        //system.debug('userMap**********' + userMap);
     //try{
        for (User user: userMap) {
            emailIds.add(user.email);
            testemailIds.add(user.email);
        }
        for (User_Master__c userMaster: [Select email__c, isSFDCUser__c, Name, First_Name__c, user__c, Last_Name__c 
            from User_Master__c where email__c IN: emailIds limit 1000]) {
            userMasterMap.put(userMaster.email__c, userMaster);
            mappedUserSet.add(userMaster.user__c);
        }
        /*}Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }*/
    }

    /******************************
    Method Name: insertUpdateUserMaster
    Description:  Method to upsert user master records
    Paramenters: List<User> userList
    Return Value: void
    *******************************/
    public static void insertUpdateUserMaster(Map < Id, User > userMap) {
       // if(Test.isRunningTest()){
            map<Id,String> oldFName = new map<Id,String>();
            map<Id,String> oldLName = new map<Id,String>();
            if(oldUserMap != null){
                for(Id usrId: oldUserMap.keyset()){
                    oldFName.put(usrId, oldUserMap.get(usrId).Firstname);
                    oldLName.put(usrId, oldUserMap.get(usrId).Firstname);
                }
            }
            cReateUpdateUserMaster.processRecords(testemailIds,userMap.keyset(),oldFName,oldLName);
       /* }else{
            User_Master__c userMaster;
            List < User_Master__c > userMasterListtoUpsert = new List < User_Master__c > ();
            for (User user: userMap.values()) {
                userMaster = new User_Master__c();
                if (userMasterMap.containskey(user.email) && (!user.Allow_Duplicate__c)) {
                    if (oldUserMap != null && userMasterMap.get(user.email).name.equals(oldUserMap.get(user.Id).firstname + UtilConstants.BLANK_SPACE + oldUserMap.get(user.Id).lastname)) {
                        userMaster = userMasterMap.get(user.email);
                        userMaster.Name = user.firstName + UtilConstants.BLANK_SPACE + user.LastName;
                        userMaster.email__c = user.email;
                        userMasterListtoUpsert.add(userMaster);
                    }
                } else if (!userMasterMap.containskey(user.email)) {
                    userMaster.user__c = user.Id;
                    userMaster.email__c = user.email;
                    userMaster.Name = user.firstName + UtilConstants.BLANK_SPACE + user.LastName;
                    userMasterListtoUpsert.add(userMaster);
                }
            }
            try {
                if (userMasterListtoUpsert.size() > 0) {
                    upsert userMasterListtoUpsert;
                }
            } catch (DMLException E) {
                String sheetThrowingException = UtilConstants.EMPTY_STRING;
              sheetThrowingException = e.getMessage() + e.getStackTraceString();
              throw (e);
              //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                              //ApexPages.addMessage(myMsg);﻿
                //system.debug('E==' + E);
            }
        }*/
    }
    /******************************
    Method Name: validateUserBeforeInsert
    Description:* Method is validateing the user
                * by comparing the existing email address 
                * in the user object.
    Paramenters: List<User> userList
    Return Value: void
    *******************************/
    public static void validateUserBeforeInsert(List < User > userList) {
    try{
        for (User user: userList) {
            //system.debug('user.Allow_Duplicate__c=====' + user.Allow_Duplicate__c);
            if (userMasterMap.containsKey(user.email) && (!user.Allow_Duplicate__c) && (!mappedUserSet.contains(user.Id))) {
                user.addError(UtilConstants.ERR_MSG3);
            }
        }
        }Catch(DMLException e) {
          String sheetThrowingException = UtilConstants.EMPTY_STRING;
          sheetThrowingException = e.getMessage() + e.getStackTraceString();
          throw (e);
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(e)); 
                          //ApexPages.addMessage(myMsg);﻿
        }
    }
}