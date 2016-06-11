/*****************
@author : Sumalatha Ganga
@description : This class handles the auto- populating Fields functionality for Action object.

*******************/
/******************
 * @class name : actionUpdateController
 * 
 * @purpose :
******************/
public with sharing class actionUpdateController {
  
   
    List<Action__c> action = new List<Action__c>();
    public String CLASS_NAME = UtilConstants.Actionupdatecontroller_CLASS;
    String sql;
    
    
    public void populateFieldsAfterInsert(List<Action__c> actionFieldList){
        set<Id> actionId=new set<Id>();
        Map<Id, Action__c> actionMap = new Map<Id, Action__c>();
    
        System.debug('action ' + actionFieldList);
       try{
           for(Action__c actionUpd: actionFieldList){
               
               if(actionUpd.kt_trac__c != null){
                     KT_Trac__c  actionList = new KT_Trac__c ();
                     actionList = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c FROM  KT_Trac__c WHERE Id = : actionUpd.kt_trac__c LIMIT 1 ];
                     actionUpd.Wave__c = actionList.Wave__c;
                     actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                     actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
                }
                else if(actionUpd.Recruit_Tracker__c != null){
                    Recruit_Tracker__c  actionList = new Recruit_Tracker__c ();
                    actionList = [SELECT Id, Wave__c, Mobilization_Plan__c, Mobilization_Plan__r.Deal__c FROM Recruit_Tracker__c WHERE ID = : actionUpd.Recruit_Tracker__c LIMIT 1 ];
                    actionUpd.Wave__c = actionList.Wave__c;
                    actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                    actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
                }
                else if(actionUpd.Tech_WE_Tracker__c != null){
                    Tech_WE_Tracker__c  actionList = new Tech_WE_Tracker__c();
                    actionList = [SELECT ID, Wave__c, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Tech_WE_Tracker__c WHERE Id= :actionUpd.Tech_WE_Tracker__c LIMIT 1];
                    actionUpd.Wave__c = actionList.Wave__c;
                    actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                    actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
                }
               else if(actionUpd.opex_tracker__c != null){
                   OPEX_Tracker__c actionList = new OPEX_Tracker__c();
                   actionList  = [SELECT ID, Wave__c,Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM  OPEX_TRacker__c WHERE Id = :actionUpd.opex_tracker__c LIMIT 1 ];
                   actionUpd.Wave__c = actionList.Wave__c;
                   actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                   actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
               } 
              else if(actionUpd.srat_tracker__c != null){
                 SRAT_TRacker__c  actionList = new SRAT_Tracker__c();
                 actionList  = [SELECT ID, Wave__c,Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM  SRAT_TRacker__c WHERE Id = :actionUpd.srat_tracker__c LIMIT 1 ];
                 actionUpd.Wave__c = actionList.Wave__c;
                 actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                 actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;  
              } 
              else if(actionUpd.Procurement_General_Activity_Item__c != null){
                  Procurement_General_Activity_Item__c  actionList = new Procurement_General_Activity_Item__c ();
                  actionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM  Procurement_General_Activity_Item__c  WHERE Id = :actionUpd.Procurement_General_Activity_Item__c LIMIT 1 ];
                  actionUpd.Wave__c = actionList.Wave__c;
                  actionUpd.Mobilization_Plan__c = actionList.wave__r.Mobilization_Plan__c;
                  actionUpd.Deal__c = actionList.wave__r.Mobilization_Plan__r.Deal__c;
              }
              else if(actionUpd.Procurement_Quarter_Wise_Activity_Item__c != null){
                  Procurement_Quarter_Wise_Activity_Item__c  actionList = new Procurement_Quarter_Wise_Activity_Item__c ();
                  actionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM  Procurement_Quarter_Wise_Activity_Item__c WHERE Id = :actionUpd.Procurement_Quarter_Wise_Activity_Item__c LIMIT 1 ];
                  actionUpd.Wave__c = actionList.Wave__c;
                    actionUpd.Mobilization_Plan__c = actionList.wave__r.Mobilization_Plan__c;
                    actionUpd.Deal__c = actionList.wave__r.Mobilization_Plan__r.Deal__c;
              }
              else if(actionUpd.Procurement_Region_Wise_Activity_Item__c != null){
                  Procurement_Region_Wise_Activity_Item__c  actionList = new Procurement_Region_Wise_Activity_Item__c();
                  actionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM Procurement_Region_Wise_Activity_Item__c WHERE Id = :actionUpd.Procurement_Region_Wise_Activity_Item__c LIMIT 1];
                  actionUpd.Wave__c = actionList.Wave__c;
                  actionUpd.Mobilization_Plan__c = actionList.wave__r.Mobilization_Plan__c;
                  actionUpd.Deal__c = actionList.wave__r.Mobilization_Plan__r.Deal__c;
           }
           else if(actionUpd.Procurement_Wave_Region__c != null){
                Procurement_Wave_Region__c  actionList = new Procurement_Wave_Region__c ();
                actionList  = [SELECT ID, Wave__c, Wave__r.Mobilization_Plan__c, wave__r.Mobilization_Plan__r.Deal__c FROM Procurement_Wave_Region__c  WHERE ID= : actionUpd.Procurement_Wave_Region__c LIMIT 1 ];
               actionUpd.Wave__c = actionList.Wave__c;
               actionUpd.Mobilization_Plan__c = actionList.wave__r.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.wave__r.Mobilization_Plan__r.Deal__c;
           }
           else if(actionUpd.Budget_Trac__c != null){
               Budget_Trac__c actionList = new Budget_Trac__c();
               actionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Budget_Trac__c WHERE ID = : actionUpd.Budget_Trac__c LIMIT 1 ];
               actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
               //action.add(actionUpd);                 
           }
           else if(actionUpd.Contract_Legal_Tracker__c <> null){
               Contract_Legal_Tracker__c  actionList = new Contract_Legal_Tracker__c ();
               actionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Contract_Legal_Tracker__c  WHERE ID = : actionUpd.Contract_Legal_Tracker__c LIMIT 1 ];
               actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
           }
           else if(actionUpd.BCP_Tracker__c <> null){
               BCP_Tracker__c actionList = new BCP_Tracker__c ();
               actionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM BCP_Tracker__c WHERE ID = : actionUpd.BCP_Tracker__c LIMIT 1 ];
               actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
           }
           else if(actionUpd.Service_Mgmt_Tracker__c <> null){
               Service_Management_Tracker__c  actionList = new Service_Management_Tracker__c ();
               actionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Service_Management_Tracker__c WHERE ID = : actionUpd.Service_Mgmt_Tracker__c LIMIT 1 ];
               actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
           }
           else if(actionUpd.Journey_Management_Tracker__c <> null){
               Journey_Management_Tracker__c actionList = new Journey_Management_Tracker__c();
               actionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM Journey_Management_Tracker__c WHERE ID = : actionUpd.Journey_Management_Tracker__c LIMIT 1 ];
               actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
           }
           else if(actionUpd.wave_proc__c <> null){
               wave_proc__c  actionList = new wave_proc__c ();
               actionList=[SELECT Id, Wave__c, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM wave_proc__c WHERE ID = : actionUpd.wave_proc__c LIMIT 1 ];
               actionUpd.Wave__c = actionList.Wave__c;
               actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
           }
           else if(actionUpd.wave__c <> null){
               wave__c  actionList = new wave__c ();
               actionList=[SELECT Id, Mobilization_Plan__c,Mobilization_Plan__r.Deal__c FROM wave__c WHERE ID = : actionUpd.wave__c LIMIT 1 ];
               actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
           }
            else if(actionUpd.Mobilization_Plan__c <> null){
               Mobilization_Plan__c  actionList = new Mobilization_Plan__c ();
               actionList=[SELECT Id, Deal__c FROM Mobilization_Plan__c WHERE ID = : actionUpd.Mobilization_Plan__c LIMIT 1 ];
               //actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
               actionUpd.Deal__c = actionList.Deal__c;
           }
            else if(actionUpd.Risks__c <> null && actionUpd.Deal__c == null){
              Risks__c  actionList = new Risks__c ();
              actionList = [SELECT ID, BCP_Tracker__c, Budget_Trac__c, Contract_Legal_Tracker__c, Deal__c, 
                          Journey_Management_Tracker__c, KT_Trac__c, Mobilization_Plan__c, OPEX_Tracker__c, 
                          Procurement_General_Activity_Item__c, Procurement_Quarter_Wise_Activity_Item__c, 
                          Procurement_Region_Wise_Activity_Item__c, Procurement_Wave_Region__c, Recruit_Tracker__c, 
                          Service_Mgmt_Tracker__c, SRAT_Tracker__c, Tech_WE_Tracker__c, Wave__c, Wave_Proc__c 
                          FROM Risks__c WHERE Id = :actionUpd.Risks__c LIMIT 1];
                    actionUpd.BCP_Tracker__c = actionList.BCP_Tracker__c;
                    actionUpd.Budget_Trac__c = actionList.Budget_Trac__c;
                    actionUpd.Contract_Legal_Tracker__c = actionList.Contract_Legal_Tracker__c;
                    actionUpd.Deal__c = actionList.Deal__c;
                    actionUpd.Journey_Management_Tracker__c = actionList.Journey_Management_Tracker__c;
                    actionUpd.KT_Trac__c = actionList.KT_Trac__c;
                    actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                    actionUpd.OPEX_Tracker__c = actionList.OPEX_Tracker__c;
                    actionUpd.Procurement_General_Activity_Item__c = actionList.Procurement_General_Activity_Item__c;
                    actionUpd.Procurement_Quarter_Wise_Activity_Item__c = actionList.Procurement_Quarter_Wise_Activity_Item__c;
                    actionUpd.Procurement_Region_Wise_Activity_Item__c = actionList.Procurement_Region_Wise_Activity_Item__c;
                    actionUpd.Procurement_Wave_Region__c = actionList.Procurement_Wave_Region__c;
                    actionUpd.Recruit_Tracker__c = actionList.Recruit_Tracker__c;
                    actionUpd.Service_Mgmt_Tracker__c = actionList.Service_Mgmt_Tracker__c;
                    actionUpd.SRAT_Tracker__c = actionList.SRAT_Tracker__c;
                    actionUpd.Tech_WE_Tracker__c = actionList.Tech_WE_Tracker__c;
                    actionUpd.Wave__c = actionList.Wave__c;
                    actionUpd.Wave_Proc__c = actionList.Wave_Proc__c;
            }
            else if(actionUpd.Issue__c <> null && actionUpd.Deal__c == null){
                Issues__c  actionList  = new Issues__c  ();
               actionList  = [SELECT Id, BCP_Tracker__c,Budget_Trac__c,Contract_Legal_Tracker__c,Deal__c,Journey_Management_Tracker__c,
                                    KT_Trac__c,Mobilization_Plan__c,OPEX_Tracker__c,Procurement_General_Activity_Item__c,
                                    Procurement_Quarter_Wise_Activity_Item__c,Procurement_Region_Wise_Activity_Item__c,
                                    Procurement_Wave_Region__c,Recruit_Tracker__c,Service_Mgmt_Tracker__c,SRAT_Tracker__c,
                                Tech_WE_Tracker__c,Wave__c,Wave_Proc__c FROM Issues__c WHERE Id = :actionUpd.Issue__c LIMIT 1];
                   actionUpd.BCP_Tracker__c = actionList.BCP_Tracker__c;
                    actionUpd.Budget_Trac__c = actionList.Budget_Trac__c;
                    actionUpd.Contract_Legal_Tracker__c = actionList.Contract_Legal_Tracker__c;
                    actionUpd.Deal__c = actionList.Deal__c;
                    actionUpd.Journey_Management_Tracker__c = actionList.Journey_Management_Tracker__c;
                    actionUpd.KT_Trac__c = actionList.KT_Trac__c;
                    actionUpd.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                    actionUpd.OPEX_Tracker__c = actionList.OPEX_Tracker__c;
                    actionUpd.Procurement_General_Activity_Item__c = actionList.Procurement_General_Activity_Item__c;
                    actionUpd.Procurement_Quarter_Wise_Activity_Item__c = actionList.Procurement_Quarter_Wise_Activity_Item__c;
                    actionUpd.Procurement_Region_Wise_Activity_Item__c = actionList.Procurement_Region_Wise_Activity_Item__c;
                    actionUpd.Procurement_Wave_Region__c = actionList.Procurement_Wave_Region__c;
                    actionUpd.Recruit_Tracker__c = actionList.Recruit_Tracker__c;
                    actionUpd.Service_Mgmt_Tracker__c = actionList.Service_Mgmt_Tracker__c;
                    actionUpd.SRAT_Tracker__c = actionList.SRAT_Tracker__c;
                    actionUpd.Tech_WE_Tracker__c = actionList.Tech_WE_Tracker__c;
                    actionUpd.Wave__c = actionList.Wave__c;
                    actionUpd.Wave_Proc__c = actionList.Wave_Proc__c;
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
     // method End
   }  

/*****************
 * @method :populateFieldsAfterInsert
 
 * @purpose : This method will auto - populate fields on Action Object

    public void populateFieldsAfterInsert(List<Action__c> actionFieldList){
        set<Id> actionId=new set<Id>();
        
        for(Action__c actionList:actionFieldList){
            actionId.add(actionList.id);
       
        }
        
       try{
           for(Action__c actionList:  [SELECT id,Module__c,kt_trac__c,bcp_tracker__c,KT_Trac__r.Wave__c,KT_Trac__r.Mobilization_Plan__c,KT_Trac__r.Mobilization_Plan__r.Deal__c,
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
                                    Mobilization_Plan__r.Deal__c from Action__c where id in: actionId LIMIT 5000] ){
           
                if(actionList.kt_trac__c != null){
                     actionList.Wave__c = actionList.KT_Trac__r.Wave__c;
                     actionList.Mobilization_Plan__c = actionList.KT_Trac__r.Mobilization_Plan__c;
                     actionList.Deal__c = actionList.KT_Trac__r.Mobilization_Plan__r.Deal__c;
                     action.add(actionList);
                    }else if(actionList.Recruit_Tracker__c != null){                
                    actionList.Wave__c = actionList.Recruit_Tracker__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.Recruit_Tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Recruit_Tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);
                }else if(actionList.Tech_WE_Tracker__c != null){
                    actionList.Wave__c = actionList.Tech_WE_Tracker__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.Tech_WE_Tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Tech_WE_Tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.opex_tracker__c != null){                   
                    actionList.Wave__c = actionList.opex_tracker__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.opex_tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.opex_tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);
                }else if(actionList.srat_tracker__c != null){
                    actionList.Wave__c = actionList.srat_tracker__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.srat_tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.srat_tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Procurement_General_Activity_Item__c != null){
                    actionList.Wave__c = actionList.Procurement_General_Activity_Item__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Procurement_General_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Procurement_Quarter_Wise_Activity_Item__c != null){
                    actionList.Wave__c = actionList.Procurement_Quarter_Wise_Activity_Item__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Procurement_Quarter_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Procurement_Region_Wise_Activity_Item__c != null){
                    actionList.Wave__c = actionList.Procurement_Region_Wise_Activity_Item__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Procurement_Region_Wise_Activity_Item__r.wave__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Procurement_Wave_Region__c != null){
                    actionList.Wave__c = actionList.Procurement_Wave_Region__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.Procurement_Wave_Region__r.wave__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Procurement_Wave_Region__r.wave__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Budget_Trac__c != null){
                    actionList.Mobilization_Plan__c = actionList.Budget_Trac__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Budget_Trac__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Contract_Legal_Tracker__c != null){
                    actionList.Mobilization_Plan__c = actionList.Contract_Legal_Tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Contract_Legal_Tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.BCP_Tracker__c != null){
                    actionList.Mobilization_Plan__c = actionList.BCP_Tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.BCP_Tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Service_Mgmt_Tracker__c != null){
                    actionList.Mobilization_Plan__c = actionList.Service_Mgmt_Tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Service_Mgmt_Tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.Journey_Management_Tracker__c != null){
                    actionList.Mobilization_Plan__c = actionList.Journey_Management_Tracker__r.Mobilization_Plan__c;
                    actionList.Deal__c = actionList.Journey_Management_Tracker__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                 
                }else if(actionList.wave_proc__c != null){
                    actionList.Wave__c = actionList.Wave_proc__r.Wave__c;
                    actionList.Mobilization_Plan__c = actionList.Wave_proc__r.Mobilization_Plan__c;              
                    actionList.Deal__c = actionList.wave_proc__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);  
                }else if(actionList.wave__c != null){
                    actionList.Mobilization_Plan__c = actionList.wave__r.Mobilization_Plan__c;              
                    actionList.Deal__c = actionList.wave__r.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                     
                }else if(actionList.Mobilization_Plan__c != null){
                    actionList.Deal__c = actionList.Mobilization_Plan__r.Deal__c;
                    action.add(actionList);                     
                }else if(actionList.Risks__c <> null && actionList.Deal__c == null){
                    actionList.BCP_Tracker__c = actionList.Risks__r.BCP_Tracker__c;
                    actionList.Budget_Trac__c = actionList.Risks__r.Budget_Trac__c;
                    actionList.Contract_Legal_Tracker__c = actionList.Contract_Legal_Tracker__c;
                    actionList.Deal__c = actionList.Deal__c;
                    actionList.Journey_Management_Tracker__c = actionList.Journey_Management_Tracker__c;
                    actionList.KT_Trac__c = actionList.KT_Trac__c;
                    actionList.Mobilization_Plan__c = actionList.Mobilization_Plan__c;
                    actionList.OPEX_Tracker__c = actionList.OPEX_Tracker__c;
                    actionList.Procurement_General_Activity_Item__c = actionList.Procurement_General_Activity_Item__c;
                    actionList.Procurement_Quarter_Wise_Activity_Item__c = actionList.Procurement_Quarter_Wise_Activity_Item__c;
                    actionList.Procurement_Region_Wise_Activity_Item__c = actionList.Procurement_Region_Wise_Activity_Item__c;
                    actionList.Procurement_Wave_Region__c = actionList.Procurement_Wave_Region__c;
                    actionList.Recruit_Tracker__c = actionList.Recruit_Tracker__c;
                    actionList.Service_Mgmt_Tracker__c = actionList.Service_Mgmt_Tracker__c;
                    actionList.SRAT_Tracker__c = actionList.SRAT_Tracker__c;
                    actionList.Tech_WE_Tracker__c = actionList.Tech_WE_Tracker__c;
                    actionList.Wave__c = actionList.Wave__c;
                    actionList.Wave_Proc__c = actionList.Wave_Proc__c;
                    action.add(actionList); 
               }else if(actionList.Issue__c <> null && actionList.Deal__c == null){
                    actionList.BCP_Tracker__c = actionList.Issue__r.BCP_Tracker__c;
                    actionList.Budget_Trac__c = actionList.Issue__r.Budget_Trac__c;
                    actionList.Contract_Legal_Tracker__c = actionList.Issue__r.Contract_Legal_Tracker__c;
                    actionList.Deal__c = actionList.Issue__r.Deal__c;
                    actionList.Journey_Management_Tracker__c = actionList.Issue__r.Journey_Management_Tracker__c;
                    actionList.KT_Trac__c = actionList.Issue__r.KT_Trac__c;
                    actionList.Mobilization_Plan__c = actionList.Issue__r.Mobilization_Plan__c;
                    actionList.OPEX_Tracker__c = actionList.Issue__r.OPEX_Tracker__c;
                    actionList.Procurement_General_Activity_Item__c = actionList.Issue__r.Procurement_General_Activity_Item__c;
                    actionList.Procurement_Quarter_Wise_Activity_Item__c = actionList.Issue__r.Procurement_Quarter_Wise_Activity_Item__c;
                    actionList.Procurement_Region_Wise_Activity_Item__c = actionList.Issue__r.Procurement_Region_Wise_Activity_Item__c;
                    actionList.Procurement_Wave_Region__c = actionList.Issue__r.Procurement_Wave_Region__c;
                    actionList.Recruit_Tracker__c = actionList.Issue__r.Recruit_Tracker__c;
                    actionList.Service_Mgmt_Tracker__c = actionList.Issue__r.Service_Mgmt_Tracker__c;
                    actionList.SRAT_Tracker__c = actionList.Issue__r.SRAT_Tracker__c;
                    actionList.Tech_WE_Tracker__c = actionList.Issue__r.Tech_WE_Tracker__c;
                    actionList.Wave__c = actionList.Issue__r.Wave__c;
                    actionList.Wave_Proc__c = actionList.Issue__r.Wave_Proc__c;
                    action.add(actionList); 
                }
                else{
                
                }
            
           }
           Database.SaveResult[] srList = Database.update(action,false);         
    
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully inserted Action. Action ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Action fields that affected this error: ' + err.getFields());
                    }
                }       
            }
       }catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, UTILConstants.ORG_ID, UTILConstants.APPLICATION_MWB,CLASS_NAME, CLASS_NAME, 
                   null, System.Logginglevel.ERROR);
            
       }
        
       }.
       *****************/