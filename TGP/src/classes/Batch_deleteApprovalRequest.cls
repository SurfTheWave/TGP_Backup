/*
*@Author : Vaishnavi
*@CreatedDate : 12/17/2015
*@Description : This batch will do batch update on Approval Request
*/
global class Batch_deleteApprovalRequest implements Database.Batchable<sObject>, Database.Stateful
{
    global List<approval_request__c> appReqToDelete = new List<approval_request__c>();
    global Database.QueryLocator start(Database.BatchableContext context)
    {
        String query = 'Select Id, approval_request_status__c, approval_request_type__c, Approval_Stage__c, Approval_Stage__r.approval_stage_status__c, Service_Group__c, Approval_Stage__r.of_Approval_Request_IC__c from approval_request__c where (approval_request_type__c = \'IO Final Approval\' OR approval_request_type__c = \'IC Final Approval\')  and (approval_request_status__c = \'Not Sent\' OR approval_request_status__c = \'Pending\' OR approval_request_status__c =\'Approved\') and Approval_Stage__c != NULL ORDER BY approval_request_status__c DESC';
        
                        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext context, List<approval_request__c> appReqList)
    {
        //List<approval_request__c> appReqList = new List<approval_request__c>();
        List<approval_request__c> appReqInApprovalStageList1 = new List<approval_request__c>();
        List<approval_request__c> appReqInApprovalStageList2 = new List<approval_request__c>();
        List<approval_request__c> appReqToUpdate = new List<approval_request__c>();
        //List<approval_request__c> appReqToDelete = new List<approval_request__c>();
        List<approval_request__c> appReqToDeleteTemp = new List<approval_request__c>();
        List<Approval_Stage__c> appStageToUpdate = new List<Approval_Stage__c>();
        Set<ID> stageID = new Set<ID>();
        Map<ID, Set<approval_request__c>> appStageToRequestMap = new Map<ID, Set<approval_request__c>>();
        Map<ID, Set<approval_request__c>> appStageToRequestMapIO = new Map<ID, Set<approval_request__c>>();
        Map<ID, Set<approval_request__c>> appStageToRequestMapIC = new Map<ID, Set<approval_request__c>>();
        Boolean stageContainsFinal = False;
        Boolean stageContainsNA = False;
        
        for(approval_request__c appReq : appReqList)
        {
            if((appReq.approval_request_type__c == 'IO Final Approval') || appReq.approval_request_type__c == 'IC Final Approval')
            {
                if(appReq.approval_request_status__c == 'Approved')
                {
                    if(appReq.Approval_Stage__r.approval_stage_status__c != 'Approved')
                    {
                        stageID.add(appReq.Approval_Stage__c);
                    }
                }
            }
                        
        }
        
        appReqInApprovalStageList2 = [Select Id, approval_request_status__c, approval_request_type__c, Approval_Stage__c, Service_Group__c from
                                    approval_request__c where Approval_Stage__c = 'a3q290000007PBe'];
                                    //and NOT(approval_request_type__c = 'Solution Plan Approval')
                                    //OR NOT(approval_request_status__c = 'Approved')];
                                    //and approval_request_type__c != 'IO Final Approval' and approval_request_type__c != 'IC Final Approval'
                                    //and approval_request_status__c != 'Approved'];
                                    
        /*for(approval_request__c appRe : appReqInApprovalStageList1)
        {
            if(appRe.approval_request_type__c == 'Solution Plan Approval')
            {
                if(appRe.approval_request_type__c == 'Approved')
                {
                }
                else
                {
                    appReqInApprovalStageList2.add(appRe);
                }
            }
            else
            {
                appReqInApprovalStageList2.add(appRe);
            }
        }*/
                                    
        for(approval_request__c appRequest : appReqInApprovalStageList2)
        {
            if(!appStageToRequestMap.containsKey(appRequest.Approval_Stage__c))
            {
                appStageToRequestMap.put(appRequest.Approval_Stage__c, new Set<approval_request__c>{appRequest});
            }
            else
            {
                appStageToRequestMap.get(appRequest.Approval_Stage__c).add(appRequest);
            }
            
            if(appRequest.Service_Group__c == 'IO')
            {
                if(!appStageToRequestMapIO.containsKey(appRequest.Approval_Stage__c))
                {
                    appStageToRequestMapIO.put(appRequest.Approval_Stage__c, new Set<approval_request__c>{appRequest});
                }
                else
                {
                    appStageToRequestMapIO.get(appRequest.Approval_Stage__c).add(appRequest);
                }
            }
            
            else if(appRequest.Service_Group__c == 'IC')
            {
                if(!appStageToRequestMapIC.containsKey(appRequest.Approval_Stage__c))
                {
                    appStageToRequestMapIC.put(appRequest.Approval_Stage__c, new Set<approval_request__c>{appRequest});
                }
                else
                {
                    appStageToRequestMapIC.get(appRequest.Approval_Stage__c).add(appRequest);
                }
            }
        }
        
        if(appReqList.size() > 0)
        {
            for(approval_request__c appReqRec : appReqList)
            {
                if(appReqRec.approval_request_type__c == 'IO Final Approval' || appReqRec.approval_request_type__c == 'IC Final Approval')
                {
                                        
                    if(appReqRec.approval_request_status__c == 'Approved')
                    {
                        if(!appStageToRequestMap.containsKey(appReqRec.Approval_Stage__c))
                        {
                            /*if(appReqRec.Service_Group__c == 'IO')
                            {
                                appReqRec.approval_request_type__c = 'IO Final Approval';
                            }
                        
                            else if(appReqRec.Service_Group__c == 'IC')
                            {
                                appReqRec.approval_request_type__c = 'IC Final Approval';
                            }
                            
                            appReqToUpdate.add(appReqRec);*/
                            
                            
                        }
                        else
                        {
                            System.debug('Line 136');
                            if(appReqRec.Service_Group__c == 'IO')
                            {
                                System.debug('Service Group is IO');
                                stageContainsNA = False;
                                stageContainsFinal = False;
                                Set<approval_request__c> appReqSet = appStageToRequestMapIO.get(appReqRec.Approval_Stage__c);
                                for(approval_request__c ar : appReqSet)
                                {
                                    if(ar.approval_request_status__c != 'Approved')
                                    {
                                        if(ar.approval_request_type__c != 'IO Final Approval')
                                        {
                                            stageContainsNA = True;
                                            break;
                                        }
                                        else
                                        {
                                            stageContainsFinal = True;
                                            appReqToDeleteTemp.add(ar);
                                            continue;
                                        }
                                    }
                                    
                                    
                                }
                                if(!stageContainsNA)
                                {                           
                                        appReqRec.approval_request_type__c = 'IO Final Approval';
                                        appReqToUpdate.add(appReqRec);
                                        //if(stageContainsFinal)
                                        //{
                                            appReqToDelete.addAll(appReqToDeleteTemp);
                                        //}
                                    
                                }
                                
                                
                                
                            }
                            
                            else if(appReqRec.Service_Group__c == 'IC')
                            {
                                System.debug('Service Group is IO');
                            
                                stageContainsNA = False;
                                stageContainsFinal = False;
                                Set<approval_request__c> appReqSet = appStageToRequestMapIC.get(appReqRec.Approval_Stage__c);
                                for(approval_request__c ar : appReqSet)
                                {
                                    if(ar.approval_request_status__c != 'Approved')
                                    {
                                        if(ar.approval_request_type__c != 'IC Final Approval')
                                        {
                                            stageContainsNA = True;
                                            break;
                                        }
                                        else
                                        {
                                            stageContainsFinal = True;
                                            appReqToDeleteTemp.add(ar);
                                            continue;
                                        }
                                    }
                                    
                                    
                                }
                                if(!stageContainsNA)
                                {                           
                                        appReqRec.approval_request_type__c = 'IC Final Approval';
                                        appReqToUpdate.add(appReqRec);
                                        //if(stageContainsFinal)
                                        //{
                                            appReqToDelete.addAll(appReqToDeleteTemp);
                                        //}
                                }
                                
                                
                                
                            }
                        }
                        
                    }
                }
            }
            
            try
            {
            //update appReqToUpdate;
            delete appReqToDelete;
            }catch(DMLException dmle)
            {
                System.debug('DMLException-->'+dmle);
            }
            catch(Exception e)
            {
                System.debug('Exception-->'+e);
            }
            
            
        }
    }
    
    global void finish(Database.BatchableContext context)
    {
    }
}