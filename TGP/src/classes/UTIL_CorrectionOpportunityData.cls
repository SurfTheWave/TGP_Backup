/*
* @Author : Accenture IDC Team
* @Description : This class performs the actions to correction of data for the fields offering, offering solution lead
*               and solution specialist in BPO opportunity w.r.t offering records. 
* @Version : 1.0                
*/
public class UTIL_CorrectionOpportunityData {
    /******************************
    * Method Name: updateOpportunityRecord
    * Description: update the opportunity records with valid data
    * Paramenters: NA
    * Return Value: void
    *******************************/
    public void updateOpportunityRecord(List<Opportunity_TGP__c> oppRecordList) {
        String OfferingNames='';
        String solSpecialistNames='';
        String offSolLeadsNames ='';
        Set<String> solSpecialistUsers;
        Set<String> solLeadUsers;
        List<Opportunity_TGP__c> updatedOppList = new List <Opportunity_TGP__c>();
        for(Opportunity_TGP__c oppRecord : oppRecordList) {
            List<Opportunity_Offering__c> offeringRecordList = [select name, Solution_Lead_New__c, Offering_Master__r.name, Offering_Solution_Lead_Secondary_New__c, 
                                                                Solution_Specialist_New__c,Technical_Architect_New__c, Functional_Architect_Mobilization_New__c, 
                                                                Domain_Expert_Functional_Architect_New__c,Solution_Specialist_New__r.name,Solution_Lead_New__r.name 
                                                                from Opportunity_Offering__c where Opportunity_TGP__c=:oppRecord.id];
                                                                
            OfferingNames='';
            offSolLeadsNames ='';
            solSpecialistNames ='';
            solSpecialistUsers=new Set<String>();
            solLeadUsers = new Set<String>();
            for(Opportunity_Offering__c offRecord : offeringRecordList) {
                OfferingNames=OfferingNames+offRecord.Offering_Master__r.name+' ; ';
                if(offRecord.Solution_Specialist_New__c!=null) {
                    solSpecialistUsers.add(offRecord.Solution_Specialist_New__r.name); 
                }
                if(offRecord.Solution_Lead_New__c!= null)    {
                    solLeadUsers.add(offRecord.Solution_Lead_New__r.name);
                } 
            }
            if(OfferingNames.length()>0){
                OfferingNames= OfferingNames.substring(0,OfferingNames.length()-1);
            }   
            if(solSpecialistUsers.size()>0) {
                for(String solName:solSpecialistUsers) {
                    solSpecialistNames=solSpecialistNames + solName + ' ; ';
                }
                solSpecialistNames= solSpecialistNames.substring(0,solSpecialistNames.length()-1); 
            }
            if(solLeadUsers.size()>0) {
                for(String solName:solLeadUsers) {
                    offSolLeadsNames=offSolLeadsNames + solName + ' ; ';
                }
                offSolLeadsNames= offSolLeadsNames.substring(0,offSolLeadsNames.length()-1); 
            }

            oppRecord.Offerings__c=OfferingNames;          
            oppRecord.Offering_Solution_Specialists__c=solSpecialistNames;
            oppRecord.Offering_Solution_Leads__c = offSolLeadsNames;
            updatedOppList.add(oppRecord);
        }
        Database.update(updatedOppList, false);
    }
}