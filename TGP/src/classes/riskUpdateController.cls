/*****************
@author : Sumalatha Ganga
@description : This class handles the auto- populating Fields functionality for Risk object.

*******************/
public with sharing class riskUpdateController {
  
    private List<Risks__c> risk = new List<Risks__c>();
    private String CLASS_NAME = 'riskUpdateController';
    private String sql;
    
    /*****************
    @description : This method will auto - populate fields on RISK Object
      
   **/
    
       
 /****
 Document 
 ***/      
 public void populateFieldsAfterInsert(List<Risks__c> riskFieldList){
        set<Id> riskId=new set<Id>();
        Map<Id, Risks__c> riskMap = new Map<Id, Risks__c>();
    
        System.debug('Risk ' + riskFieldList);
       try{
            KT_Trac__c  riskList1 = new KT_Trac__c ();
            Recruit_Tracker__c  riskList2 = new Recruit_Tracker__c ();
            Tech_WE_Tracker__c  riskList3 = new Tech_WE_Tracker__c();
            OPEX_Tracker__c riskList4 = new OPEX_Tracker__c();
            SRAT_TRacker__c  riskList5 = new SRAT_TRacker__c();
            Procurement_General_Activity_Item__c  riskList6 = new Procurement_General_Activity_Item__c ();
            Procurement_Quarter_Wise_Activity_Item__c  riskList7 = new Procurement_Quarter_Wise_Activity_Item__c ();
            Procurement_Region_Wise_Activity_Item__c  riskList8 = new Procurement_Region_Wise_Activity_Item__c();
            Procurement_Wave_Region__c  riskList9 = new Procurement_Wave_Region__c ();
            Budget_Trac__c riskList10 = new Budget_Trac__c();
            Contract_Legal_Tracker__c  riskList11 = new Contract_Legal_Tracker__c ();
            BCP_Tracker__c riskList12 = new BCP_Tracker__c ();
             Service_Management_Tracker__c  riskList13 = new Service_Management_Tracker__c ();
             Journey_Management_Tracker__c riskList14 = new Journey_Management_Tracker__c();
             wave_proc__c  riskList15 = new wave_proc__c ();
             wave__c  riskList16 = new wave__c ();
             Mobilization_Plan__c  riskList17 = new Mobilization_Plan__c ();
           for(Risks__c riskUpd: riskFieldList){
               
               if(riskUpd.kt_trac__c != null){
                     
                     riskList1 = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                 FROM  KT_Trac__c WHERE Id = : riskUpd.kt_trac__c LIMIT 1 ];
                     riskUpd.Wave__c = riskList1.Wave__c;
                     riskUpd.Mobilization_Plan__c = riskList1.Mobilization_Plan__c;
                     riskUpd.Deal__c = riskList1.Mobilization_Plan__r.Deal__c;
                }
                else if(riskUpd.Recruit_Tracker__c != null){
                    
                    riskList2 = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c 
                                FROM Recruit_Tracker__c WHERE ID = : riskUpd.Recruit_Tracker__c LIMIT 1 ];
                    riskUpd.Wave__c = riskList2.Wave__c;
                    riskUpd.Mobilization_Plan__c = riskList2.Mobilization_Plan__c;
                    riskUpd.Deal__c = riskList2.Mobilization_Plan__r.Deal__c;
                }
                else if(riskUpd.Tech_WE_Tracker__c != null){
                    
                    riskList3 = [SELECT ID, Wave__c, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c 
                                FROM Tech_WE_Tracker__c WHERE Id= :riskUpd.Tech_WE_Tracker__c LIMIT 1];
                    riskUpd.Wave__c = riskList3.Wave__c;
                    riskUpd.Mobilization_Plan__c = riskList3.Mobilization_Plan__c;
                    riskUpd.Deal__c = riskList3.Mobilization_Plan__r.Deal__c;
                }
               else if(riskUpd.opex_tracker__c != null){
                   
                   riskList4  = [SELECT ID, Wave__c,Mobilization_Plan__c,Mobilization_Plan__r.Deal__c 
                               FROM  OPEX_TRacker__c WHERE Id = :riskUpd.opex_tracker__c LIMIT 1 ];
                   riskUpd.Wave__c = riskList4.Wave__c;
                   riskUpd.Mobilization_Plan__c = riskList4.Mobilization_Plan__c;
                   riskUpd.Deal__c = riskList4.Mobilization_Plan__r.Deal__c;
               } 
              else if(riskUpd.srat_tracker__c != null){
                 
                 riskList5  = [SELECT ID, Wave__c,Mobilization_Plan__c,Mobilization_Plan__r.Deal__c 
                             FROM  SRAT_TRacker__c WHERE Id = :riskUpd.srat_tracker__c LIMIT 1 ];
                 riskUpd.Wave__c = riskList5.Wave__c;
                 riskUpd.Mobilization_Plan__c = riskList5.Mobilization_Plan__c;
                 riskUpd.Deal__c = riskList5.Mobilization_Plan__r.Deal__c;  
              } 
              else if(riskUpd.Procurement_General_Activity_Item__c != null){
                  
                  riskList6  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                              FROM  Procurement_General_Activity_Item__c  
                              WHERE Id = :riskUpd.Procurement_General_Activity_Item__c LIMIT 1 ];
                  riskUpd.Wave__c = riskList6.Wave__c;
                  riskUpd.Mobilization_Plan__c = riskList6.wave__r.Mobilization_Plan__c;
                  riskUpd.Deal__c = riskList6.wave__r.Mobilization_Plan__r.Deal__c;
              }
              else if(riskUpd.Procurement_Quarter_Wise_Activity_Item__c != null){
                  
                  riskList7  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                                  FROM  Procurement_Quarter_Wise_Activity_Item__c 
                                  WHERE Id = :riskUpd.Procurement_Quarter_Wise_Activity_Item__c LIMIT 1 ];
                  riskUpd.Wave__c = riskList7.Wave__c;
                    riskUpd.Mobilization_Plan__c = riskList7.wave__r.Mobilization_Plan__c;
                    riskUpd.Deal__c = riskList7.wave__r.Mobilization_Plan__r.Deal__c;
              }
              else if(riskUpd.Procurement_Region_Wise_Activity_Item__c != null){
                  
                  riskList8  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                              FROM Procurement_Region_Wise_Activity_Item__c 
                              WHERE Id = :riskUpd.Procurement_Region_Wise_Activity_Item__c LIMIT 1];
                  riskUpd.Wave__c = riskList8.Wave__c;
                  riskUpd.Mobilization_Plan__c = riskList8.wave__r.Mobilization_Plan__c;
                  riskUpd.Deal__c = riskList8.wave__r.Mobilization_Plan__r.Deal__c;
           }
           else if(riskUpd.Procurement_Wave_Region__c != null){
                
                riskList9  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c 
                                FROM Procurement_Wave_Region__c  WHERE ID= : riskUpd.Procurement_Wave_Region__c LIMIT 1 ];
               riskUpd.Wave__c = riskList9.Wave__c;
               riskUpd.Mobilization_Plan__c = riskList9.wave__r.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList9.wave__r.Mobilization_Plan__r.Deal__c;
           }
           else if(riskUpd.Budget_Trac__c != null){
               
               riskList10=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Budget_Trac__c 
                           WHERE ID = : riskUpd.Budget_Trac__c LIMIT 1 ];
               riskUpd.Mobilization_Plan__c = riskList10.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList10.Mobilization_Plan__r.Deal__c;
               //risk.add(riskUpd);                 
           }
           else if(riskUpd.Contract_Legal_Tracker__c <> null){
               
               riskList11=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Contract_Legal_Tracker__c  
                       WHERE ID = : riskUpd.Contract_Legal_Tracker__c LIMIT 1 ];
               riskUpd.Mobilization_Plan__c = riskList11.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList11.Mobilization_Plan__r.Deal__c;
           }
           else if(riskUpd.BCP_Tracker__c <> null){
               
               riskList12=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM BCP_Tracker__c 
                       WHERE ID = : riskUpd.BCP_Tracker__c LIMIT 1 ];
               riskUpd.Mobilization_Plan__c = riskList12.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList12.Mobilization_Plan__r.Deal__c;
           }
           else if(riskUpd.Service_Mgmt_Tracker__c <> null){
               
               riskList13=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Service_Management_Tracker__c 
                       WHERE ID = : riskUpd.Service_Mgmt_Tracker__c LIMIT 1 ];
               riskUpd.Mobilization_Plan__c = riskList13.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList13.Mobilization_Plan__r.Deal__c;
           }
           else if(riskUpd.Journey_Management_Tracker__c <> null){
               
               riskList14=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Journey_Management_Tracker__c 
                       WHERE ID = : riskUpd.Journey_Management_Tracker__c LIMIT 1 ];
               riskUpd.Mobilization_Plan__c = riskList14.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList14.Mobilization_Plan__r.Deal__c;
           }
           else if(riskUpd.wave_proc__c <> null){
               
               riskList15=[SELECT Id, Wave__c, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM wave_proc__c 
                       WHERE ID = : riskUpd.wave_proc__c LIMIT 1 ];
               riskUpd.Wave__c = riskList15.Wave__c;
               riskUpd.Mobilization_Plan__c = riskList15.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList15.Mobilization_Plan__r.Deal__c;
           }
           else if(riskUpd.wave__c <> null){
               
               riskList16=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM wave__c 
                           WHERE ID = : riskUpd.wave__c LIMIT 1 ];
               riskUpd.Mobilization_Plan__c = riskList16.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList16.Mobilization_Plan__r.Deal__c;
           }
            else if(riskUpd.Mobilization_Plan__c <> null){
               
               riskList17=[SELECT Id, Deal__c FROM Mobilization_Plan__c WHERE ID = : riskUpd.Mobilization_Plan__c LIMIT 1 ];
               //riskUpd.Mobilization_Plan__c = riskList.Mobilization_Plan__c;
               riskUpd.Deal__c = riskList17.Deal__c;
           }else{
               
           }
          
          }
        }       
    catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);
            
       }
    }
     // method End
}