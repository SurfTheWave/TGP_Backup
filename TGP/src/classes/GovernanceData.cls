public class GovernanceData {
    public static void updateGoveraceDate(List<SD_Governance_Data__c> govDataList){
        Map<String,boolean> alpha=new Map<String,boolean>();
        List<Critical_Milestone__c> mileStoneList=new List<Critical_Milestone__c>();
            List<Risk_And_Action_Log__c> riskList=new List<Risk_And_Action_Log__c>();
        for(SD_Governance_Data__c govData:[select id,name,(select id,name from Critical_Milestones__r),(select id,name from Risk_And_Action_Logs__r) from SD_Governance_Data__c where id in:govDataList]){
            mileStoneList=govData.Critical_Milestones__r;
            riskList=govData.Risk_And_Action_Logs__r;
            
            if(mileStoneList.isEmpty() || riskList.isEmpty()){
                alpha.put(govData.id,true);
            }
        }
        
        for(SD_Governance_Data__c govDatOne:govDataList){
            String gama='</br>';
            Boolean beta=alpha.get(govDatOne.id);
            if(beta!=null){
               if(beta && !govDatOne.Save_the_Record__c){
                    govDatOne.addError('<span>"Risk/Action Log & Critical Milestone Information" has not been updated . Click Cancel to go back, </br> If you want to still save the record select "Save Data" checkBox and Click on "Save"</span>',false);
                                 
                } 
            }
            
        }
    }
}