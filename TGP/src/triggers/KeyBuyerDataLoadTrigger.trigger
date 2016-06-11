/*@Author:Shivraj
 *@CreateDate: 04 November,2015
 * @Description: This trigger is used to insert keu buyer records from temporary objects
 */
trigger KeyBuyerDataLoadTrigger on Opportuntiy_Key_Buyer_Temporary_Object__c (after insert) {
    List<Opportuntiy_Key_Buyer_Temporary_Object__c> keyBuyerList=trigger.new;
    try{
        if(trigger.isInsert && trigger.isAfter){
            KeyBuyerValueShare.insertKeyBuyer(keyBuyerList);
        }
    }catch(Exception e){
        system.debug('Trace' +e.getStackTraceString());
    }
    
}