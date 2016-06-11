/*****************
@author : Sumalatha Ganga
@description : This class handles the auto- populating Fields functionality for Decision object.

*******************/
public with sharing class DecisionUpdateController {
  
    List<Decision__c> decision = new List<Decision__c>();
    public String CLASS_NAME = UtilConstants.DEC_UPD_CNTRL;
    private String sql;

    public void populateFieldsAfterInsert(List<Decision__c> decisionFieldList){
        set<Id> decisionId=new set<Id>();
        Map<Id, Decision__c> decisionMap = new Map<Id, Decision__c>();
    
        System.debug('decision ' + decisionFieldList);
       try{
           for(Decision__c decisionUpd: decisionFieldList){
               
               if(decisionUpd.kt_trac__c != null){
                     KT_Trac__c  decisionList = new KT_Trac__c ();
                     decisionList = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c FROM  KT_Trac__c WHERE Id = : decisionUpd.kt_trac__c LIMIT 1 ];
                     decisionUpd.Wave__c = decisionList.Wave__c;
                     decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
                     decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
                }
                else if(decisionUpd.Recruit_Tracker__c != null){
                    Recruit_Tracker__c  decisionList = new Recruit_Tracker__c ();
                    decisionList = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c FROM Recruit_Tracker__c WHERE ID = : decisionUpd.Recruit_Tracker__c LIMIT 1 ];
                    decisionUpd.Wave__c = decisionList.Wave__c;
                    decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
                    decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
                }
                else if(decisionUpd.Tech_WE_Tracker__c != null){
                    Tech_WE_Tracker__c  decisionList = new Tech_WE_Tracker__c();
                    decisionList = [SELECT ID, Wave__c, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Tech_WE_Tracker__c WHERE Id= :decisionUpd.Tech_WE_Tracker__c LIMIT 1];
                    decisionUpd.Wave__c = decisionList.Wave__c;
                    decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
                    decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
                }
               else if(decisionUpd.opex_tracker__c != null){
                   OPEX_Tracker__c decisionList = new OPEX_Tracker__c();
                   decisionList  = [SELECT ID, Wave__c,Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM  OPEX_TRacker__c WHERE Id = :decisionUpd.opex_tracker__c LIMIT 1 ];
                   decisionUpd.Wave__c = decisionList.Wave__c;
                   decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
                   decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
               } 
              else if(decisionUpd.srat_tracker__c != null){
                 SRAT_TRacker__c  decisionList = new SRAT_Tracker__c();
                 decisionList  = [SELECT ID, Wave__c,Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM  SRAT_TRacker__c WHERE Id = :decisionUpd.srat_tracker__c LIMIT 1 ];
                 decisionUpd.Wave__c = decisionList.Wave__c;
                 decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
                 decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;  
              } 
              else if(decisionUpd.Procurement_General_Activity_Item__c != null){
                  Procurement_General_Activity_Item__c  decisionList = new Procurement_General_Activity_Item__c ();
                  decisionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM  Procurement_General_Activity_Item__c  WHERE Id = :decisionUpd.Procurement_General_Activity_Item__c LIMIT 1 ];
                  decisionUpd.Wave__c = decisionList.Wave__c;
                  decisionUpd.Mobilization_Plan__c = decisionList.wave__r.Mobilization_Plan__c;
                  decisionUpd.Deal__c = decisionList.wave__r.Mobilization_Plan__r.Deal__c;
              }
              else if(decisionUpd.Procurement_Quarter_Wise_Activity_Item__c != null){
                  Procurement_Quarter_Wise_Activity_Item__c  decisionList = new Procurement_Quarter_Wise_Activity_Item__c ();
                  decisionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM  Procurement_Quarter_Wise_Activity_Item__c WHERE Id = :decisionUpd.Procurement_Quarter_Wise_Activity_Item__c LIMIT 1 ];
                  decisionUpd.Wave__c = decisionList.Wave__c;
                    decisionUpd.Mobilization_Plan__c = decisionList.wave__r.Mobilization_Plan__c;
                    decisionUpd.Deal__c = decisionList.wave__r.Mobilization_Plan__r.Deal__c;
              }
              else if(decisionUpd.Procurement_Region_Wise_Activity_Item__c != null){
                  Procurement_Region_Wise_Activity_Item__c  decisionList = new Procurement_Region_Wise_Activity_Item__c();
                  decisionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM Procurement_Region_Wise_Activity_Item__c WHERE Id = :decisionUpd.Procurement_Region_Wise_Activity_Item__c LIMIT 1];
                  decisionUpd.Wave__c = decisionList.Wave__c;
                  decisionUpd.Mobilization_Plan__c = decisionList.wave__r.Mobilization_Plan__c;
                  decisionUpd.Deal__c = decisionList.wave__r.Mobilization_Plan__r.Deal__c;
           }
           else if(decisionUpd.Procurement_Wave_Region__c != null){
                Procurement_Wave_Region__c  decisionList = new Procurement_Wave_Region__c ();
                decisionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM Procurement_Wave_Region__c  WHERE ID= : decisionUpd.Procurement_Wave_Region__c LIMIT 1 ];
               decisionUpd.Wave__c = decisionList.Wave__c;
               decisionUpd.Mobilization_Plan__c = decisionList.wave__r.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.wave__r.Mobilization_Plan__r.Deal__c;
           }
           else if(decisionUpd.Budget_Trac__c != null){
               Budget_Trac__c decisionList = new Budget_Trac__c();
               decisionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Budget_Trac__c WHERE ID = : decisionUpd.Budget_Trac__c LIMIT 1 ];
               decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
               //decision.add(decisionUpd);                 
           }
           else if(decisionUpd.Contract_Legal_Tracker__c <> null){
               Contract_Legal_Tracker__c  decisionList = new Contract_Legal_Tracker__c ();
               decisionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Contract_Legal_Tracker__c  WHERE ID = : decisionUpd.Contract_Legal_Tracker__c LIMIT 1 ];
               decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
           }
           else if(decisionUpd.BCP_Tracker__c <> null){
               BCP_Tracker__c decisionList = new BCP_Tracker__c ();
               decisionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM BCP_Tracker__c WHERE ID = : decisionUpd.BCP_Tracker__c LIMIT 1 ];
               decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
           }
           else if(decisionUpd.Service_Mgmt_Tracker__c <> null){
               Service_Management_Tracker__c  decisionList = new Service_Management_Tracker__c ();
               decisionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Service_Management_Tracker__c WHERE ID = : decisionUpd.Service_Mgmt_Tracker__c LIMIT 1 ];
               decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
           }
           else if(decisionUpd.Journey_Management_Tracker__c <> null){
               Journey_Management_Tracker__c decisionList = new Journey_Management_Tracker__c();
               decisionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Journey_Management_Tracker__c WHERE ID = : decisionUpd.Journey_Management_Tracker__c LIMIT 1 ];
               decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
           }
           else if(decisionUpd.wave_proc__c <> null){
               wave_proc__c  decisionList = new wave_proc__c ();
               decisionList=[SELECT Id, Wave__c, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM wave_proc__c WHERE ID = : decisionUpd.Journey_Management_Tracker__c LIMIT 1 ];
               decisionUpd.Wave__c = decisionList.Wave__c;
               decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
           }
           else if(decisionUpd.wave__c <> null){
               wave__c  decisionList = new wave__c ();
               decisionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM wave__c WHERE ID = : decisionUpd.wave__c LIMIT 1 ];
               decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
           }
            else if(decisionUpd.Mobilization_Plan__c <> null){
               Mobilization_Plan__c  decisionList = new Mobilization_Plan__c ();
               decisionList=[SELECT Id, Deal__c FROM Mobilization_Plan__c WHERE ID = : decisionUpd.Mobilization_Plan__c LIMIT 1 ];
               //decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
               decisionUpd.Deal__c = decisionList.Deal__c;
           }
            else if(decisionUpd.Risks__c <> null && decisionUpd.Deal__c == null){
              Risks__c  decisionList = new Risks__c ();
              decisionList = [SELECT ID, BCP_Tracker__c, Budget_Trac__c, Contract_Legal_Tracker__c, Deal__c, 
                          Journey_Management_Tracker__c, KT_Trac__c, Mobilization_Plan__c, OPEX_Tracker__c, 
                          Procurement_General_Activity_Item__c, Procurement_Quarter_Wise_Activity_Item__c, 
                          Procurement_Region_Wise_Activity_Item__c, Procurement_Wave_Region__c, Recruit_Tracker__c, 
                          Service_Mgmt_Tracker__c, SRAT_Tracker__c, Tech_WE_Tracker__c, Wave__c, Wave_Proc__c 
                          FROM Risks__c WHERE Id = :decisionUpd.Risks__c LIMIT 1];
                    decisionUpd.BCP_Tracker__c = decisionList.BCP_Tracker__c;
                    decisionUpd.Budget_Trac__c = decisionList.Budget_Trac__c;
                    decisionUpd.Contract_Legal_Tracker__c = decisionList.Contract_Legal_Tracker__c;
                    decisionUpd.Deal__c = decisionList.Deal__c;
                    decisionUpd.Journey_Management_Tracker__c = decisionList.Journey_Management_Tracker__c;
                    decisionUpd.KT_Trac__c = decisionList.KT_Trac__c;
                    decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
                    decisionUpd.OPEX_Tracker__c = decisionList.OPEX_Tracker__c;
                    decisionUpd.Procurement_General_Activity_Item__c = decisionList.Procurement_General_Activity_Item__c;
                    decisionUpd.Procurement_Quarter_Wise_Activity_Item__c = decisionList.Procurement_Quarter_Wise_Activity_Item__c;
                    decisionUpd.Procurement_Region_Wise_Activity_Item__c = decisionList.Procurement_Region_Wise_Activity_Item__c;
                    decisionUpd.Procurement_Wave_Region__c = decisionList.Procurement_Wave_Region__c;
                    decisionUpd.Recruit_Tracker__c = decisionList.Recruit_Tracker__c;
                    decisionUpd.Service_Mgmt_Tracker__c = decisionList.Service_Mgmt_Tracker__c;
                    decisionUpd.SRAT_Tracker__c = decisionList.SRAT_Tracker__c;
                    decisionUpd.Tech_WE_Tracker__c = decisionList.Tech_WE_Tracker__c;
                    decisionUpd.Wave__c = decisionList.Wave__c;
                    decisionUpd.Wave_Proc__c = decisionList.Wave_Proc__c;
            }
            else if(decisionUpd.Issue__c <> null && decisionUpd.Deal__c == null){
                Issues__c  decisionList  = new Issues__c  ();
               decisionList  = [SELECT Id, BCP_Tracker__c,Budget_Trac__c,Contract_Legal_Tracker__c,Deal__c,Journey_Management_Tracker__c,
                                    KT_Trac__c,Mobilization_Plan__c,OPEX_Tracker__c,Procurement_General_Activity_Item__c,
                                    Procurement_Quarter_Wise_Activity_Item__c,Procurement_Region_Wise_Activity_Item__c,
                                    Procurement_Wave_Region__c,Recruit_Tracker__c,Service_Mgmt_Tracker__c,SRAT_Tracker__c,
                                Tech_WE_Tracker__c,Wave__c,Wave_Proc__c FROM Issues__c WHERE Id = :decisionUpd.Issue__c LIMIT 1];
                   decisionUpd.BCP_Tracker__c = decisionList.BCP_Tracker__c;
                    decisionUpd.Budget_Trac__c = decisionList.Budget_Trac__c;
                    decisionUpd.Contract_Legal_Tracker__c = decisionList.Contract_Legal_Tracker__c;
                    decisionUpd.Deal__c = decisionList.Deal__c;
                    decisionUpd.Journey_Management_Tracker__c = decisionList.Journey_Management_Tracker__c;
                    decisionUpd.KT_Trac__c = decisionList.KT_Trac__c;
                    decisionUpd.Mobilization_Plan__c = decisionList.Mobilization_Plan__c;
                    decisionUpd.OPEX_Tracker__c = decisionList.OPEX_Tracker__c;
                    decisionUpd.Procurement_General_Activity_Item__c = decisionList.Procurement_General_Activity_Item__c;
                    decisionUpd.Procurement_Quarter_Wise_Activity_Item__c = decisionList.Procurement_Quarter_Wise_Activity_Item__c;
                    decisionUpd.Procurement_Region_Wise_Activity_Item__c = decisionList.Procurement_Region_Wise_Activity_Item__c;
                    decisionUpd.Procurement_Wave_Region__c = decisionList.Procurement_Wave_Region__c;
                    decisionUpd.Recruit_Tracker__c = decisionList.Recruit_Tracker__c;
                    decisionUpd.Service_Mgmt_Tracker__c = decisionList.Service_Mgmt_Tracker__c;
                    decisionUpd.SRAT_Tracker__c = decisionList.SRAT_Tracker__c;
                    decisionUpd.Tech_WE_Tracker__c = decisionList.Tech_WE_Tracker__c;
                    decisionUpd.Wave__c = decisionList.Wave__c;
                    decisionUpd.Wave_Proc__c = decisionList.Wave_Proc__c;
            }
            else {
            }
         }
      }       
    catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);
          }
    }

    /*****************
    @description : This method will auto - populate fields on Decision Object

    public void populateFieldsAfterInsert(List<Decision__c> decisionFieldList){
        set<Id> decisionId=new set<Id>();
        
        for(Decision__c decisionList:decisionFieldList){
            decisionId.add(decisionList.id);
        }
       try{
           for(Decision__c decisionList:  [SELECT id,Module__c,kt_trac__c,bcp_tracker__c,KT_Trac__r.Wave__c,KT_Trac__r.Mobilization_Plan__c,KT_Trac__r.Mobilization_Plan__r.Deal__c,
                                    Recruit_Tracker__r.Wave__c,Recruit_Tracker__r.Mobilization_Plan__c,Recruit_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Tech_WE_Tracker__r.Wave__c,Tech_WE_Tracker__r.Mobilization_Plan__c,Tech_WE_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    srat_tracker__r.Wave__c,srat_tracker__r.Mobilization_Plan__c,srat_tracker__r.Mobilization_Plan__r.Deal__c,
                                    opex_tracker__r.Wave__c,opex_tracker__r.Mobilization_Plan__c,opex_tracker__r.Mobilization_Plan__r.Deal__c,
                                    
                                    Procurement_General_Activity_Item__r.wave__c,Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__c,
                                       Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    Procurement_Quarter_Wise_Activity_Item__r.wave__c,Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c,
                                       Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    Procurement_Region_Wise_Activity_Item__r.wave__c,Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c,
                                       Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    Procurement_Wave_Region__r.wave__c,Procurement_Wave_Region__r.wave__r.Mobilization_Plan__c,
                                       Procurement_Wave_Region__r.wave__r.Mobilization_Plan__r.Deal__c,
                                    
                                    Deal__c, Risks__c, Issue__c,
                                    
                                    Risks__r.BCP_Tracker__c,Risks__r.Budget_Trac__c,Risks__r.Contract_Legal_Tracker__c,Risks__r.Deal__c,
                                    Risks__r.Journey_Management_Tracker__c,Risks__r.KT_Trac__c,Risks__r.Mobilization_Plan__c,Risks__r.OPEX_Tracker__c,
                                    Risks__r.Procurement_General_Activity_Item__c,Risks__r.Procurement_Quarter_Wise_Activity_Item__c,Risks__r.Recruit_Tracker__c,
                                    Risks__r.Procurement_Region_Wise_Activity_Item__c,Risks__r.Procurement_Wave_Region__c,Risks__r.Wave_Proc__c,
                                    Risks__r.Service_Mgmt_Tracker__c,Risks__r.SRAT_Tracker__c,Risks__r.Tech_WE_Tracker__c,Risks__r.Wave__c,
                                    
                                    Issue__r.BCP_Tracker__c,Issue__r.Budget_Trac__c,Issue__r.Contract_Legal_Tracker__c,Issue__r.Deal__c,
                                    Issue__r.Journey_Management_Tracker__c,Issue__r.KT_Trac__c,Issue__r.Mobilization_Plan__c,Issue__r.OPEX_Tracker__c,
                                    Issue__r.Procurement_General_Activity_Item__c,Issue__r.Procurement_Quarter_Wise_Activity_Item__c,
                                    Issue__r.Procurement_Region_Wise_Activity_Item__c,Issue__r.Procurement_Wave_Region__c,Issue__r.Recruit_Tracker__c,
                                    Issue__r.Service_Mgmt_Tracker__c,Issue__r.SRAT_Tracker__c,Issue__r.Tech_WE_Tracker__c,Issue__r.Wave__c,Issue__r.Wave_Proc__c,
                                    
                                    Budget_Trac__r.Mobilization_Plan__c,Budget_Trac__r.Mobilization_Plan__r.Deal__c,
                                    Contract_Legal_Tracker__r.Mobilization_Plan__c,Contract_Legal_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    BCP_Tracker__r.Mobilization_Plan__c,BCP_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Service_Mgmt_Tracker__r.Mobilization_Plan__c,Service_Mgmt_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Journey_Management_Tracker__r.Mobilization_Plan__c,Journey_Management_Tracker__r.Mobilization_Plan__r.Deal__c,
                                    Wave_proc__r.Wave__c,Wave_proc__r.Mobilization_Plan__c,wave_proc__r.Mobilization_Plan__r.Deal__c,
                                    wave__r.Mobilization_Plan__c,wave__r.Mobilization_Plan__r.Deal__c,
                                    Mobilization_Plan__r.Deal__c from Decision__c where id in: decisionId limit 5000] ){
           
                if(decisionList.kt_trac__c != null){
                     decisionList.Wave__c = decisionList.KT_Trac__r.Wave__c;
                     decisionList.Mobilization_Plan__c = decisionList.KT_Trac__r.Mobilization_Plan__c;
                     decisionList.Deal__c = decisionList.KT_Trac__r.Mobilization_Plan__r.Deal__c;
                     decision.add(decisionList);
                    }else if(decisionList.Recruit_Tracker__c != null){                  
                    decisionList.Wave__c = decisionList.Recruit_Tracker__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.Recruit_Tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Recruit_Tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);
                }else if(decisionList.Tech_WE_Tracker__c != null){
                    decisionList.Wave__c = decisionList.Tech_WE_Tracker__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.Tech_WE_Tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Tech_WE_Tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.opex_tracker__c != null){                 
                    decisionList.Wave__c = decisionList.opex_tracker__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.opex_tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.opex_tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);
                }else if(decisionList.srat_tracker__c != null){
                    decisionList.Wave__c = decisionList.srat_tracker__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.srat_tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.srat_tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Procurement_General_Activity_Item__c != null){
                    decisionList.Wave__c = decisionList.Procurement_General_Activity_Item__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Procurement_Quarter_Wise_Activity_Item__c != null){
                    decisionList.Wave__c = decisionList.Procurement_Quarter_Wise_Activity_Item__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Procurement_Region_Wise_Activity_Item__c != null){
                    decisionList.Wave__c = decisionList.Procurement_Region_Wise_Activity_Item__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Procurement_Wave_Region__c != null){
                    decisionList.Wave__c = decisionList.Procurement_Wave_Region__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.Procurement_Wave_Region__r.wave__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Procurement_Wave_Region__r.wave__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Budget_Trac__c != null){
                    decisionList.Mobilization_Plan__c = decisionList.Budget_Trac__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Budget_Trac__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Contract_Legal_Tracker__c != null){
                    decisionList.Mobilization_Plan__c = decisionList.Contract_Legal_Tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Contract_Legal_Tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.BCP_Tracker__c != null){
                    decisionList.Mobilization_Plan__c = decisionList.BCP_Tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.BCP_Tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Service_Mgmt_Tracker__c != null){
                    decisionList.Mobilization_Plan__c = decisionList.Service_Mgmt_Tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Service_Mgmt_Tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.Journey_Management_Tracker__c != null){
                    decisionList.Mobilization_Plan__c = decisionList.Journey_Management_Tracker__r.Mobilization_Plan__c;
                    decisionList.Deal__c = decisionList.Journey_Management_Tracker__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                 
                }else if(decisionList.wave_proc__c != null){
                    decisionList.Wave__c = decisionList.Wave_proc__r.Wave__c;
                    decisionList.Mobilization_Plan__c = decisionList.Wave_proc__r.Mobilization_Plan__c;              
                    decisionList.Deal__c = decisionList.wave_proc__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);  
                }else if(decisionList.wave__c != null){
                    decisionList.Mobilization_Plan__c = decisionList.wave__r.Mobilization_Plan__c;              
                    decisionList.Deal__c = decisionList.wave__r.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                     
                }else if(decisionList.Mobilization_Plan__c != null){
                    decisionList.Deal__c = decisionList.Mobilization_Plan__r.Deal__c;
                    decision.add(decisionList);                     
                }else if(decisionList.Risks__c <> null && decisionList.Deal__c == null){
                    decisionList.BCP_Tracker__c = decisionList.Risks__r.BCP_Tracker__c;
                    decisionList.Budget_Trac__c = decisionList.Risks__r.Budget_Trac__c;
                    decisionList.Contract_Legal_Tracker__c = decisionList.Risks__r.Contract_Legal_Tracker__c;
                    decisionList.Deal__c = decisionList.Risks__r.Deal__c;
                    decisionList.Journey_Management_Tracker__c = decisionList.Risks__r.Journey_Management_Tracker__c;
                    decisionList.KT_Trac__c = decisionList.Risks__r.KT_Trac__c;
                    decisionList.Mobilization_Plan__c = decisionList.Risks__r.Mobilization_Plan__c;
                    decisionList.OPEX_Tracker__c = decisionList.Risks__r.OPEX_Tracker__c;
                    decisionList.Procurement_General_Activity_Item__c = decisionList.Risks__r.Procurement_General_Activity_Item__c;
                    decisionList.Procurement_Quarter_Wise_Activity_Item__c = decisionList.Risks__r.Procurement_Quarter_Wise_Activity_Item__c;
                    decisionList.Procurement_Region_Wise_Activity_Item__c = decisionList.Risks__r.Procurement_Region_Wise_Activity_Item__c;
                    decisionList.Procurement_Wave_Region__c = decisionList.Risks__r.Procurement_Wave_Region__c;
                    decisionList.Recruit_Tracker__c = decisionList.Risks__r.Recruit_Tracker__c;
                    decisionList.Service_Mgmt_Tracker__c = decisionList.Risks__r.Service_Mgmt_Tracker__c;
                    decisionList.SRAT_Tracker__c = decisionList.Risks__r.SRAT_Tracker__c;
                    decisionList.Tech_WE_Tracker__c = decisionList.Risks__r.Tech_WE_Tracker__c;
                    decisionList.Wave__c = decisionList.Risks__r.Wave__c;
                    decisionList.Wave_Proc__c = decisionList.Risks__r.Wave_Proc__c;
                    decision.add(decisionList); 
               }else if(decisionList.Issue__c <> null && decisionList.Deal__c == null){
                    decisionList.BCP_Tracker__c = decisionList.Issue__r.BCP_Tracker__c;
                    decisionList.Budget_Trac__c = decisionList.Issue__r.Budget_Trac__c;
                    decisionList.Contract_Legal_Tracker__c = decisionList.Issue__r.Contract_Legal_Tracker__c;
                    decisionList.Deal__c = decisionList.Issue__r.Deal__c;
                    decisionList.Journey_Management_Tracker__c = decisionList.Issue__r.Journey_Management_Tracker__c;
                    decisionList.KT_Trac__c = decisionList.Issue__r.KT_Trac__c;
                    decisionList.Mobilization_Plan__c = decisionList.Issue__r.Mobilization_Plan__c;
                    decisionList.OPEX_Tracker__c = decisionList.Issue__r.OPEX_Tracker__c;
                    decisionList.Procurement_General_Activity_Item__c = decisionList.Issue__r.Procurement_General_Activity_Item__c;
                    decisionList.Procurement_Quarter_Wise_Activity_Item__c = decisionList.Issue__r.Procurement_Quarter_Wise_Activity_Item__c;
                    decisionList.Procurement_Region_Wise_Activity_Item__c = decisionList.Issue__r.Procurement_Region_Wise_Activity_Item__c;
                    decisionList.Procurement_Wave_Region__c = decisionList.Issue__r.Procurement_Wave_Region__c;
                    decisionList.Recruit_Tracker__c = decisionList.Issue__r.Recruit_Tracker__c;
                    decisionList.Service_Mgmt_Tracker__c = decisionList.Issue__r.Service_Mgmt_Tracker__c;
                    decisionList.SRAT_Tracker__c = decisionList.Issue__r.SRAT_Tracker__c;
                    decisionList.Tech_WE_Tracker__c = decisionList.Issue__r.Tech_WE_Tracker__c;
                    decisionList.Wave__c = decisionList.Issue__r.Wave__c;
                    decisionList.Wave_Proc__c = decisionList.Issue__r.Wave_Proc__c;
                    decision.add(decisionList); 
                }
                else{
                }
            
           }
           Database.SaveResult[] srList = Database.update(decision,false);           
    
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                  //  System.debug('Successfully inserted Decision. Decision ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                       // System.debug('The following error has occurred.');                    
                       // System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('decision fields that affected this error: ' + err.getFields());
                    }
                }       
            }
       }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);
            
       }
        
       }
       *****/
    }