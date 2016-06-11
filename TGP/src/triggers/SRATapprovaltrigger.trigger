trigger SRATapprovaltrigger on SRAT_Tracker__c (After insert,After update) {

    Boolean flag=false;
    if(Test.isRunningTest()){
        flag=true;
    }else{
        List<FlagCheck__c> flagCheckList=FlagCheck__c.getAll().values();
        flag=flagCheckList[0].FieldOne__c; 
    }
    
    if(flag) {
        
    if(UTILMobClasses.SRATapprovaltriggerFlag) {
                
        UTILMobClasses.SRATapprovaltriggerFlag = FALSE;   

   Set<Id> mobPlanIds = new Set<Id>();
   Set<Id> DealIds = new Set<Id>();
   List<RecordType> RecId= new List<RecordType>(); 
   List<Mobilization_Plan__c> mobplanList = new List<Mobilization_Plan__c>();
   List<Deal__c> DealList = new List<Deal__c>();
   List<Mobilization_Team__c> mobteamList = new List<Mobilization_Team__c>();
   List<Mobilization_Team__c> mtList = new List<Mobilization_Team__c>();
   //list of new instance of object to update. by suma
    SRAT_Tracker__c [] sratList = new SRAT_Tracker__c []{};
    try{
        if((trigger.isAfter && trigger.isinsert) || (trigger.isAfter && trigger.isupdate)) {
            for(SRAT_Tracker__c srat:trigger.new){
                mobPlanIds.add(srat.Mobilization_Plan__c);
            }
            
            mobplanList=[Select id,name,Deal__c,Deal__r.Name From Mobilization_Plan__c where Id in :mobPlanIds];
            for(Mobilization_Plan__c mobPlanRec : mobplanList){
                DealIds.add(mobPlanRec.Deal__c);        
            }
            
            system.debug('######-------DealIds----#########' +DealIds);
            DealList=[Select id,name, (Select id,name, Role__c, Primary_Lead__c,Deal__c From Mobilization_Teams__r where Role__c =: 'Governance Lead') From Deal__c where id in :DealIds];
            
            system.debug('######-------DealIds----#########' +Mobilization_Team__c.Role__c);
                for(Deal__C d:DealList){
                    for(Mobilization_Team__c mteam : d.Mobilization_Teams__r){ 
                        mtList.add(mteam);  
                    }
                    
                }
            System.debug('MTEAMMember List@@ ' + mtList );
            for(SRAT_Tracker__c scheck : trigger.new){
                for(Mobilization_Team__c mteamrec :mtList){
                    //if(scheck.Checklist_Reviewer__c != NULL){
                        //if((scheck.Checklist_Reviewer__c).equals(mteamrec.id)){
                            if((scheck.Send_Checklist_for_Review__c) && (!scheck.Checklist_Reviewed__c)){
                                  System.debug('IfSCHECK--SaveRecord-*-*-*-*-*-' + SCHECK );
                                  SRATApprovalProcessController s = new SRATApprovalProcessController();
                                  s.submitForApproval(scheck,mtList);
                            }
                            
                         /*   else if((scheck.Send_Checklist_for_Review__c)&& (scheck.Checklist_Reviewed__c)){
                                 System.debug('SCHECK-*-*-*-*-*-' + SCHECK );
                                 SRATApprovalProcessController s = new SRATApprovalProcessController();
                                 s.approveRecord(scheck);
                                 }        */
                         //}
                   /* }else{
                            scheck.adderror('Approver Cannnot be Other Than Global Transition Role');       
                            } */
                        }
            }
      }
    }catch(Exception e){
         System.debug('Error occured in SRATapprovaltrigger.');       
     }
     
    }
     
    }
}