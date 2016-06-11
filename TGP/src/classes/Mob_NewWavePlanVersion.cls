/*
Description : 

Author : Varsha Chougule.
Story no. : MOB-016

Updated by        Story no                Update Date        Update details
------------    -----------------        --------------    -------------------------------------------------------------
             
*/
global class Mob_NewWavePlanVersion
{
     webservice static Decimal newVersion(String dealID)
     {
         Decimal versionNo=1;
         List<Wave_Plan_Version__c> listOfWavePlanVersion=[select id,Version__c from Wave_Plan_Version__c where Deal__c=:dealID];
         if(listOfWavePlanVersion.size()>0)
         {
             for(Wave_Plan_Version__c temp : listOfWavePlanVersion)
             {
                if(temp.Version__c > versionNo) 
                {
                    versionNo=temp.Version__c;
                }
             }
             versionNo=versionNo+1;
             return versionNo;
         }
         else
         {
             return versionNo;
         }
     }
}