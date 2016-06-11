/*
Description : Webservice methods of this class gets executed from New Version button on Wave Plan Version.
              This class will create clone of old wave plan version and mark as active.
              This will inactivate entire tree of the old wave plan version.

Author : Nilesh Adkar
Story no. : MOB_037

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------

              
*/

global class Mob_CloneMECVersionAndQns
{


/*
Description :  Called by Clone version button on Wave Plan vesrion creates clone of entire wave plan version tree and 
                enables disables tracking and wave plan version
Returns: Id of new wave plan version

*/
    webservice static String cloneMECVersionAndQns(String oldMECVersionId)
    {
        MEC_Post_Contract_Version__c clonedMECVersion;
        try
        {
            List<MEC_Post_Contract_Version__c> lstMECPostContractVersion = [ select id, cloned_from__c,Active__c,Version_Name__c
                                                                             from MEC_Post_Contract_Version__c 
                                                                             where id = :oldMECVersionId 
                                                                 ];
        if(lstMECPostContractVersion.size()>0)
        {
             clonedMECVersion = lstMECPostContractVersion.get(0).clone(false,true);
             clonedMECVersion.Active__c = false;
             clonedMECVersion.cloned_from__c = lstMECPostContractVersion.get(0).id;
             insert clonedMECVersion;
        }

        List<MEC_Post_Contract_Questionnaire_Master__c> lstMECPostContractQns = [ select Category_Name__c,Criteria__c,
                                                                                  Is_Mandatory__c , MEC_Post_Contract_Version__c
                                                                                  from MEC_Post_Contract_Questionnaire_Master__c
                                                                                  where MEC_Post_Contract_Version__c = :oldMECVersionId order by createddate asc
                                                                                ];
                                                                                
        List<MEC_Post_Contract_Questionnaire_Master__c> lstMECPostContractQnsCloned = new List<MEC_Post_Contract_Questionnaire_Master__c>();
        MEC_Post_Contract_Questionnaire_Master__c tempContractQns;
        
        for(MEC_Post_Contract_Questionnaire_Master__c qns : lstMECPostContractQns)
        {
            tempContractQns = new MEC_Post_Contract_Questionnaire_Master__c();
            tempContractQns = qns.clone(false,true);
            tempContractQns.Cloned_From__c = qns.id;
            tempContractQns.MEC_Post_Contract_Version__c = clonedMECVersion.id;    // put new parent version's id in children
            lstMECPostContractQnsCloned.add(tempContractQns);
        }
        
        if(lstMECPostContractQnsCloned.size()>0)
            insert lstMECPostContractQnsCloned;
            
        return clonedMECVersion.id;
        }
        catch(Exception ex)
        {
            return 'error';
        }          
    }
}