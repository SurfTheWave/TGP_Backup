/*
@name:oppSVMCompliance
@author: Vaishnavi
@createdDate: 3/10/2016
*/
public class oppSVMComplianceController
{
    /*
    @name:deactivateOtherSVM
    @author: Vaishnavi
    @createdDate: 3/10/2016
    */
    public static void deactivateOtherSVM(List<Opportunity_SVM_Compliance__c> oppSVMCompList)
    {
        
        
        //Set<ID> appStageID = new Set<ID>();
        Set<ID> oppID = new Set<ID>();
        List<Opportunity_SVM_Compliance__c> oppSVMCList = new List<Opportunity_SVM_Compliance__c>();
        List<Opportunity_SVM_Compliance__c> oppSVMListToUpdate = new List<Opportunity_SVM_Compliance__c>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Approval_Stage__c> appStageRecListStg23 = new List<Approval_Stage__c>();
        for(Opportunity_SVM_Compliance__c oppSVMRec : oppSVMCompList)
        {
            if(oppSVMRec.Opportunity__c != null)
            {
                oppID.add(oppSVMRec.Opportunity__c);
            }
        }
        System.debug('Opportunity ID size-->'+oppID.size());
        
        appStageRecListStg23 = [Select ID, (Select ID from Opportunity_SVM_Compliances__r) from Approval_Stage__c where Opportunity__c IN : oppID and 
                        (approval_stage_type__c = 'Stage 2 - Solution Approval' OR approval_stage_type__c = 'Stage 3 - Solution Approval') ];
        System.debug('Approval Stage List size-->'+appStageRecListStg23.size());                
        for(Approval_Stage__c appStg : appStageRecListStg23)
        {
            System.debug('Inside first for');
            for(Opportunity_SVM_Compliance__c oppSVMRec : appStg.Opportunity_SVM_Compliances__r)
            {
                System.debug('Inside second for');
                oppSVMRec.Active__c = FALSE;
                oppSVMListToUpdate.add(oppSVMRec);
            }
        }
        System.debug('Opportunity SVM Update List-->'+oppSVMListToUpdate.size());
        
        try
        {
            
            if(oppSVMListToUpdate.size()>0)
            {
                System.debug('Opportunity SVM Update List Inside if-->'+oppSVMListToUpdate.size());
                update oppSVMListToUpdate;
            }
        }
        catch(Exception e)
        {
            System.debug('Exception-->'+e);
        }
        
        
        
    }
    
    /*
    @name:deactivateOtherSVM
    @author: Vaishnavi
    @createdDate: 3/10/2016
    */
    public static void updateDelvApprSVM(List<approval_request__c> appReqList)
    {
        Set<ID> appStageID = new Set<ID>();
        Map<ID, Opportunity_SVM_Compliance__c> mapOfAppStgSVM = new Map<ID, Opportunity_SVM_Compliance__c>();
        List<Opportunity_SVM_Compliance__c> oppSVMList = new List<Opportunity_SVM_Compliance__c>();
        List<Opportunity_SVM_Compliance__c> oppSVMListToUpdate = new List<Opportunity_SVM_Compliance__c>();
        Opportunity_SVM_Compliance__c svmRecs = new Opportunity_SVM_Compliance__c();
        Map<ID, List<approval_request__c>> mapOfAprStgAprReq = new Map<ID,  List<approval_request__c>>();
        Map<ID, List<approval_request__c>> mapOfAprStgAprReqBPO = new Map<ID,  List<approval_request__c>>();
        Map<ID, List<approval_request__c>> mapOfAprStgAprReqIO = new Map<ID,  List<approval_request__c>>();
        Map<ID, List<approval_request__c>> mapOfAprStgAprReqBPO2 = new Map<ID,  List<approval_request__c>>();
        Map<ID, List<approval_request__c>> mapOfAprStgAprReqIO2 = new Map<ID,  List<approval_request__c>>();
        List<approval_request__c> appReList = new List<approval_request__c>();
        List<approval_request__c> appReList2 = new List<approval_request__c>();
        List<approval_request__c> appReqSubList = new List<approval_request__c>();
        approval_request__c appReq1 = new approval_request__c();
        approval_request__c appReq2 = new approval_request__c();
        approval_request__c appReq3 = new approval_request__c();
        approval_request__c appReq4 = new approval_request__c();
        Boolean stageHasBPODelvApproved = False;
        Boolean stageHasBPODelvApprovedMulti = False;
        Boolean stageHasIODelvApproved = False;
        Boolean stageHasIODelvApprovedMulti = False;
        
        for(approval_request__c appReqRec : appReqList)
        {
            if(appReqRec.approval_request_status__c == 'Approved')
            {
                appStageID.add(appReqRec.Approval_Stage__c);
            }
        }
        System.debug('Approval Stage size-->'+appStageID.size());
        
        appReqSubList = [Select ID, Approval_Stage__c, approval_request_type__c, approval_request_status__c, Approver__r.Name,
                        Approval_Stage__r.Opportunity__r.Service_Grp__c, Approval_Stage__r.Opportunity__r.BPO_Opportunity__c, Approval_Stage__r.Opportunity__r.IO_Opportunity__c,
                        Approval_Stage__r.Opportunity__r.IC_Opportunity__c, Approval_Stage__r.Opportunity__r.Prime_SDO_Lead_dev__c, Approval_Stage__r.Opportunity__r.Prime_SDO_Lead_IO_dev__c, response_received_date__c
                        from approval_request__c where (approval_request_type__c = 'BPO Delivery Approval' OR approval_request_type__c = 'IO Delivery Approval') AND (Approval_Stage__c IN : appStageID)];
        oppSVMList = [Select ID, Approval_Id__c from Opportunity_SVM_Compliance__c where Approval_Id__c IN : appStageID];
        System.debug('Approval Request Sub List size-->'+appReqSubList.size());
        System.debug('Opportunity SVM size-->'+oppSVMList.size());
        
        for(approval_request__c appReq : appReqSubList)
        {
           
            if(appReq.Approval_Stage__r.Opportunity__r.Service_Grp__c == 'BPO' || ((appReq.Approval_Stage__r.Opportunity__r.Service_Grp__c == 'BPO + IS') && appReq.Approval_Stage__r.Opportunity__r.IO_Opportunity__c == FALSE) ) 
            {
                if(appReq.approval_request_type__c == 'BPO Delivery Approval')
                {
                    if(!mapOfAprStgAprReqBPO.containsKey(appReq.Approval_Stage__c))
                    {
                        mapOfAprStgAprReqBPO.put(appReq.Approval_Stage__c, new List<approval_request__c>{appReq});
                    }
                    else
                    {
                        mapOfAprStgAprReqBPO.get(appReq.Approval_Stage__c).add(appReq);
                    }
                }
            }else if(appReq.Approval_Stage__r.Opportunity__r.Service_Grp__c == 'IO' ||(appReq.Approval_Stage__r.Opportunity__r.Service_Grp__c == 'IO + IC')) 
            {
                if(appReq.approval_request_type__c == 'IO Delivery Approval')
                {
                    if(!mapOfAprStgAprReqIO.containsKey(appReq.Approval_Stage__c))
                    {
                        mapOfAprStgAprReqIO.put(appReq.Approval_Stage__c, new List<approval_request__c>{appReq});
                    }
                    else
                    {
                        mapOfAprStgAprReqIO.get(appReq.Approval_Stage__c).add(appReq);
                    }
                }
            }else if(appReq.Approval_Stage__r.Opportunity__r.Service_Grp__c == 'BPO + IS' && appReq.Approval_Stage__r.Opportunity__r.IO_Opportunity__c == TRUE)
            {
                    if(appReq.approval_request_type__c == 'BPO Delivery Approval')
                    {
                        if(!mapOfAprStgAprReqBPO2.containsKey(appReq.Approval_Stage__c))
                        {
                            mapOfAprStgAprReqBPO2.put(appReq.Approval_Stage__c, new List<approval_request__c>{appReq});
                        }
                        else
                        {
                            mapOfAprStgAprReqBPO2.get(appReq.Approval_Stage__c).add(appReq);
                        }
                    }else if(appReq.approval_request_type__c == 'IO Delivery Approval')
                    {
                        if(!mapOfAprStgAprReqIO2.containsKey(appReq.Approval_Stage__c))
                        {
                            mapOfAprStgAprReqIO2.put(appReq.Approval_Stage__c, new List<approval_request__c>{appReq});
                        }
                        else
                        {
                            mapOfAprStgAprReqIO2.get(appReq.Approval_Stage__c).add(appReq);
                        }
                    }
                        
                    
                    
            }else{}
            
        }
        System.debug('Map BPO size-->'+mapOfAprStgAprReq.size());
        System.debug('Map IO size-->'+mapOfAprStgAprReqIO.size());
        
        for(Opportunity_SVM_Compliance__c svmRec : oppSVMList)
        {
            if(!mapOfAppStgSVM.containsKey(svmRec.Approval_Id__c))
            {
                mapOfAppStgSVM.put(svmRec.Approval_Id__c, svmRec);
            }
        }
        System.debug('Map size 2-->'+mapOfAppStgSVM.size());
        
        for(Approval_Stage__c appStgRec : [Select ID, Opportunity__r.Service_Grp__c, Opportunity__r.BPO_Opportunity__c, Opportunity__r.IO_Opportunity__c, Opportunity__r.IC_Opportunity__c, Opportunity__r.Prime_SDO_Lead_IO_dev__c, Opportunity__r.Prime_SDO_Lead_dev__c  from Approval_Stage__c where ID IN : appStageID])
        {
            if(appStgRec.Opportunity__r.Service_Grp__c == 'BPO' || ((appStgRec.Opportunity__r.Service_Grp__c == 'BPO + IS') && appStgRec.Opportunity__r.IO_Opportunity__c == FALSE) )
            {
                System.debug('BPO or BPO + IC Opportunity');
                System.debug('mapOfAprStgAprReqBPO-->'+mapOfAprStgAprReqBPO);
                if(!(mapOfAprStgAprReqBPO.isEmpty() || mapOfAprStgAprReqBPO ==NULL))
                {
                    appReList = mapOfAprStgAprReqBPO.get(appStgRec.ID);
                    if(appReList.size() > 1)
                    {
                        System.debug('Multiple BPO approval requests');
                        for(approval_request__c appReqRec : appReList)
                        {
                            if(appReqRec.approval_request_type__c == 'BPO Delivery Approval' && appReqRec.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_dev__c && appReqRec.approval_request_status__c == 'Approved')
                            {
                                System.debug('BPODelApr PrimeSDO Approved');
                                svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                                svmRecs.Delivery_Approval_Received__c = TRUE;
                                svmRecs.Delivery_Approval_Received_Date_BPO__c = appReqRec.response_received_date__c;
                                svmRecs.Prime_Delivery_Lead_BPO__c = appReqRec.Approver__r.Name;
                                oppSVMListToUpdate.add(svmRecs);
                                break;
                            }
                        }
                    }else if(appReList.size() == 1)
                    {
                        System.debug('Single BPO approval requests');
                        if(appReList[0].approval_request_type__c == 'BPO Delivery Approval' && appReList[0].approval_request_status__c == 'Approved')
                        {
                            System.debug('BPODelApr No PrimeSDO Approved');
                            svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                            svmRecs.Delivery_Approval_Received__c = TRUE;
                            if(appReList[0].Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_dev__c)
                            {
                                svmRecs.Prime_Delivery_Lead_BPO__c = appReList[0].Approver__r.Name;
                            }
                            svmRecs.Delivery_Approval_Received_Date_BPO__c = appReList[0].response_received_date__c;
                            oppSVMListToUpdate.add(svmRecs);
                        }
                    }
                }
                
            }
            else if(appStgRec.Opportunity__r.Service_Grp__c == 'IO' || (appStgRec.Opportunity__r.Service_Grp__c == 'IO + IC'))
            {
                System.debug('IO or IO + IC opportunity');
                System.debug('mapOfAprStgAprReqIO-->'+mapOfAprStgAprReqIO);
                if(!(mapOfAprStgAprReqIO.isEmpty() || mapOfAprStgAprReqIO ==NULL))
                {
                    appReList2 = mapOfAprStgAprReqIO.get(appStgRec.ID);
                    if(appReList2.size() > 1)
                    {
                        system.debug('Multiple IO approval requests');
                        for(approval_request__c appReqRec : appReList2)
                        {
                            if(appReqRec.approval_request_type__c == 'IO Delivery Approval' && appReqRec.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_IO_dev__c && appReqRec.approval_request_status__c == 'Approved')
                            {
                                System.debug('IODelApr PrimeSDO Approved');
                                svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                                svmRecs.Delivery_Approval_Received__c = TRUE;
                                svmRecs.Delivery_Approval_Received_Date_IO__c = appReqRec.response_received_date__c;
                                svmRecs.Prime_Delivery_Lead_IO__c = appReqRec.Approver__r.Name;
                                oppSVMListToUpdate.add(svmRecs);
                            }
                        }
                    }else if(appReList2.size() == 1)
                    {
                        System.debug('Single IO approval requests');
                        if(appReList2[0].approval_request_type__c == 'IO Delivery Approval' && appReList2[0].approval_request_status__c == 'Approved')
                        {
                            System.debug('Single IO Approved');
                            svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                            svmRecs.Delivery_Approval_Received__c = TRUE;
                            if(appReList2[0].Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_IO_dev__c)
                            {
                                svmRecs.Prime_Delivery_Lead_IO__c = appReList2[0].Approver__r.Name;
                            }
                            svmRecs.Delivery_Approval_Received_Date_IO__c = appReList2[0].response_received_date__c;
                            oppSVMListToUpdate.add(svmRecs);
                        }
                    }
                }
                
            }
            else if(appStgRec.Opportunity__r.Service_Grp__c == 'BPO + IS' && appStgRec.Opportunity__r.IO_Opportunity__c == TRUE)
            {
                System.debug('BPO + IO or BPO + IO + IC Opportunity');
                System.debug('mapOfAprStgAprReqBPO2-->'+mapOfAprStgAprReqBPO2);
                System.debug('mapOfAprStgAprReqIO2-->'+mapOfAprStgAprReqIO2);
                
                if(!(mapOfAprStgAprReqBPO2.isEmpty() || mapOfAprStgAprReqBPO2 ==NULL))
                {
                    if(!(mapOfAprStgAprReqIO2.isEmpty() || mapOfAprStgAprReqIO2 == NULL))
                    {
                        //BPO
                        appReList = mapOfAprStgAprReqBPO2.get(appStgRec.ID);
                        if(appReList.size() > 1)
                        {
                            System.debug('Multiple BPO approval requests');
                            for(approval_request__c appReqRec : appReList)
                            {
                                if(appReqRec.approval_request_type__c == 'BPO Delivery Approval' && appReqRec.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_dev__c && appReqRec.approval_request_status__c == 'Approved')
                                {
                                    System.debug('BPODelApr PrimeSDO Approved');
                                    stageHasBPODelvApprovedMulti = TRUE;
                                    appReq1 = appReqRec;
                                    break;
                                }
                            }
                        }else if(appReList.size() == 1)
                        {
                            System.debug('Single BPO approval requests');
                            if(appReList[0].approval_request_type__c == 'BPO Delivery Approval' && appReList[0].approval_request_status__c == 'Approved')
                            {
                                System.debug('BPODelApr No PrimeSDO Approved');
                                stageHasBPODelvApproved = TRUE;
                                appReq2 = appReList[0];
                            }
                        }else{}
                        
                        //IO
                        appReList2 = mapOfAprStgAprReqIO2.get(appStgRec.ID);
                        if(appReList2.size() > 1)
                        {
                            system.debug('Multiple IO approval requests');
                            for(approval_request__c appReqRec : appReList2)
                            {
                                if(appReqRec.approval_request_type__c == 'IO Delivery Approval' && appReqRec.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_IO_dev__c && appReqRec.approval_request_status__c == 'Approved')
                                {
                                    System.debug('IODelApr PrimeSDO Approved');
                                    stageHasIODelvApprovedMulti = TRUE;
                                    appReq3 = appReqRec;
                                    break;
                                }
                            }
                        }else if(appReList2.size() == 1)
                        {
                            System.debug('Single IO approval requests');
                            if(appReList2[0].approval_request_type__c == 'IO Delivery Approval' && appReList2[0].approval_request_status__c == 'Approved')
                            {
                                System.debug('Single IO Approved');
                                stageHasIODelvApproved = TRUE;
                                appReq4 = appReList2[0];
                            }
                        }else{}
                        
                        //CheckBPOIO
                        if(stageHasBPODelvApproved && stageHasIODelvApproved)
                        {
                            System.debug('Both Single');
                            svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                            svmRecs.Delivery_Approval_Received__c = TRUE;
                            if(appReq2.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_dev__c)
                            {
                                svmRecs.Prime_Delivery_Lead_BPO__c = appReq2.Approver__r.Name;
                            }
                            if(appReq4.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_IO_dev__c)
                            {
                                svmRecs.Prime_Delivery_Lead_IO__c = appReq4.Approver__r.Name;
                            }
                            svmRecs.Delivery_Approval_Received_Date_BPO__c = appReq2.response_received_date__c;
                            svmRecs.Delivery_Approval_Received_Date_IO__c = appReq4.response_received_date__c;
                            oppSVMListToUpdate.add(svmRecs);
                            
                            
                        }else if(stageHasBPODelvApproved && stageHasIODelvApprovedMulti)
                        {
                            System.debug('Single Multi');
                            svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                            svmRecs.Delivery_Approval_Received__c = TRUE;
                            if(appReq2.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_dev__c)
                            {
                                svmRecs.Prime_Delivery_Lead_BPO__c = appReq2.Approver__r.Name;
                            }
                            svmRecs.Delivery_Approval_Received_Date_BPO__c = appReq2.response_received_date__c;
                            svmRecs.Delivery_Approval_Received_Date_IO__c = appReq3.response_received_date__c;
                            svmRecs.Prime_Delivery_Lead_IO__c = appReq3.Approver__r.Name;
                            oppSVMListToUpdate.add(svmRecs);
                            
                        }else if(stageHasBPODelvApprovedMulti && stageHasIODelvApproved)
                        {
                            System.debug('Mulit Single');
                            svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                            svmRecs.Delivery_Approval_Received__c = TRUE;
                            if(appReq4.Approver__r.Name == appStgRec.Opportunity__r.Prime_SDO_Lead_IO_dev__c)
                            {
                                svmRecs.Prime_Delivery_Lead_IO__c = appReq4.Approver__r.Name;
                            }
                            svmRecs.Delivery_Approval_Received_Date_BPO__c = appReq1.response_received_date__c;
                            svmRecs.Delivery_Approval_Received_Date_IO__c = appReq4.response_received_date__c;
                            svmRecs.Prime_Delivery_Lead_BPO__c = appReq1.Approver__r.Name;
                            oppSVMListToUpdate.add(svmRecs);
                            
                        }else if(stageHasBPODelvApprovedMulti && stageHasIODelvApprovedMulti)
                        {
                            System.debug('Both Multi');
                            svmRecs = mapOfAppStgSVM.get(appStgRec.ID);
                            svmRecs.Delivery_Approval_Received__c = TRUE;
                            svmRecs.Delivery_Approval_Received_Date_BPO__c = appReq1.response_received_date__c;
                            svmRecs.Delivery_Approval_Received_Date_IO__c = appReq3.response_received_date__c;
                            svmRecs.Prime_Delivery_Lead_BPO__c = appReq1.Approver__r.Name;
                            svmRecs.Prime_Delivery_Lead_IO__c = appReq3.Approver__r.Name;
                            oppSVMListToUpdate.add(svmRecs);
                            
                        }else{}
                    }
                    
                }
                
            }
        }
        
        if(oppSVMListToUpdate.size()>0)
        {
            System.debug('List to update greater than 0');
            try
            {
                update oppSVMListToUpdate;
            }catch(Exception e)
            {
                System.debug('Exception-->'+ e);
            }
        }
        
        /*for(Approval_Stage__c appStgRec : appStageList)
        {
            mapOfAppStgOpp.put(appStgRec.ID, Opportunity__r.Service_Grp__c);
        }
        for(approval_request__c appReq : appReqList)
        {
            if(appReq.approval_request_status__c == 'Approved')
            {
                
            }
        }*/
        
    }
}