/*@Author:Shivraj
 *@CreateDate: 04 November,2015
 * @Description: This class is used to store the key buyer records into a temporary object and then insert the records into actual key buyer object with custom flag
 */
public class KeyBuyerValueShare {
    
    public static void shareKeyBuyer(List<Opportunity_key_buyer__c> oppkeyList){
        Map<ID,Opportunity> oppkeymap = new Map<ID,Opportunity>();
        List<ID> oppids = new List<ID>();
        try{
            for(Opportunity_key_buyer__c oppky : oppkeyList){
                oppids.add(oppky.opportunity__c);
            }
            for(Opportunity opp: [SELECT id,AccountID,SAP_OM_Item_Id__c FROM opportunity WHERE id IN: oppids]){
                oppkeymap.put(opp.ID, opp);
            }
            
            for(Opportunity_key_buyer__c op: oppkeyList){
                Opportunity alpha=oppkeymap.get(op.opportunity__c);
                op.Client_Name__c=alpha.AccountId;
                op.MMS_Record__c=alpha.SAP_OM_Item_Id__c;
            }
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                        UtilConstants.BUNDLD_BPO, UtilConstants.BUNDLD_BPO  , null, System.Logginglevel.ERROR);
        }
        
    }
    
    /*@Author:Shivraj
     *@CreateDate: 04 November,2015
     * @Description: This method does all the validation for inserting records into SWB System
     */    
    public static void insertKeyBuyer(List<Opportuntiy_Key_Buyer_Temporary_Object__c > tempKeyBuyerList){
        List<Opportunity_Key_Buyer__c> oppKeyBuyerList=new List<Opportunity_Key_Buyer__c>();
        Opportunity_Key_Buyer__c oppKeyBuyertoBeInserted;
        set<String> sapOMSet=new set<String>();    
        Map<String,Opportunity> opportunityMap=new Map<String,Opportunity>();
       
        List<Opportunity_Key_Buyer__c> oppKeyBuyerListToDelete=new List<Opportunity_Key_Buyer__c>();
        List<Opportuntiy_Key_Buyer_Temporary_Object__c> oppKeyBuyerDataListToDelete=new List<Opportuntiy_Key_Buyer_Temporary_Object__c>();
        List<Opportunity_Key_Buyer__c> tempList=new List<Opportunity_Key_Buyer__c>();
        try{
            RecordType recordType= [select id from RecordType where SobjectType='Opportunity_Key_Buyer__c' and developerName='Opportunity_Key_Buyer_Read'];
            for(Opportuntiy_Key_Buyer_Temporary_Object__c oppTeamBuyer:tempKeyBuyerList){
                sapOMSet.add(oppTeamBuyer.SAP_OM_ID__c);
            }
                    
            for(Opportunity opp:[select id,SAP_OM_ID__c,SAP_OM_Item_Id__c,AccountId from Opportunity where SAP_OM_ID__c IN :sapOMSet]){
                opportunityMap.put(opp.SAP_OM_ID__c,opp);
             }
            
            for(Opportunity_Key_Buyer__c oppBuyer:[select id from Opportunity_Key_Buyer__c where Opportunity__r.SAP_OM_ID__c IN :sapOMSet and Key_Buyer_Flag__c=true]){
                oppKeyBuyerListToDelete.add(oppBuyer);
            }
            
            if(!oppKeyBuyerListToDelete.isEmpty()){
                database.delete(oppKeyBuyerListToDelete);
            }
            for(Opportuntiy_Key_Buyer_Temporary_Object__c oppTempKeyBuyer:tempKeyBuyerList){
                Opportunity keyBuyerOpp=opportunityMap.get(oppTempKeyBuyer.SAP_OM_ID__c);
                
                if(keyBuyerOpp!=null){
                    oppKeyBuyertoBeInserted=new Opportunity_Key_Buyer__c();
                    oppKeyBuyertoBeInserted.Opportunity__c=keyBuyerOpp.id;
                    oppKeyBuyertoBeInserted.Client_Name__c=keyBuyerOpp.AccountId;
                    oppKeyBuyertoBeInserted.MMS_Record__c=keyBuyerOpp.SAP_OM_Item_Id__c;
                    oppKeyBuyertoBeInserted.Category__c=oppTempKeyBuyer.Category__c;
                    oppKeyBuyertoBeInserted.description__c=oppTempKeyBuyer.Key_Buyer_Value_Description__c;
                    oppKeyBuyertoBeInserted.importance_to_the_client__c=oppTempKeyBuyer.Importance_to_the_client__c;
                    oppKeyBuyertoBeInserted.Key_Dependencies__c=oppTempKeyBuyer.Key_Dependencies_Assumptions__c;
                    oppKeyBuyertoBeInserted.Risk_Level__c=oppTempKeyBuyer.Risk_Level__c;
                    oppKeyBuyertoBeInserted.Risk_Tier__c=oppTempKeyBuyer.Risk_Tier__c;
                    oppKeyBuyertoBeInserted.Key_Buyer_Flag__c=true;
                    oppKeyBuyertoBeInserted.description__c=oppTempKeyBuyer.Key_Buyer_Value_Description__c;
                    oppKeyBuyertoBeInserted.solution_component__c=oppTempKeyBuyer.Solution_Component__c;
                    oppKeyBuyertoBeInserted.RecordtypeId=recordType.id;
                    oppKeyBuyertoBeInserted.Success_Measures__c=oppTempKeyBuyer.Success_Measures__c;
                    oppKeyBuyerList.add(oppKeyBuyertoBeInserted);
                 }
                
            }
            oppKeyBuyerDataListToDelete=[select id from Opportuntiy_Key_Buyer_Temporary_Object__c where id in:tempKeyBuyerList];
            system.debug('Test File');
            Database.insert(oppKeyBuyerList,false);
            Database.delete(oppKeyBuyerDataListToDelete,false);
        }catch(Exception e){
            UTIL_LoggingService.logHandledException(e, UTILConstants.ORG_ID, UTILConstants.APPLICATION_SWB,
                        UtilConstants.BUNDLD_BPO, UtilConstants.BUNDLD_BPO  , null, System.Logginglevel.ERROR);
        }
    }
    
}