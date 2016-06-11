public class ProfileMatrix{

    public static string giveAccessLevel(string profilename,string srvgrp,string oppid,string userid){
        string accesslevel = '';
        BPOSE_Matrix__c matrix;
        boolean userHasAccess;
        integer teamcount = 0;
        
        Map<String, BPOSE_Matrix__c> allProfiles= BPOSE_Matrix__c.getAll();
            if(profilename.containsignorecase(SWBBPOSEIntegrationConstants.mobilization)){
                accesslevel=SWBBPOSEIntegrationConstants.NoAccess;
            }
            
            else if(profilename.containsignorecase(SWBBPOSEIntegrationConstants.SolutionEditor)){
                 userHasAccess=UserRecordAccess.getHasEditAccess(userid,oppid);
                 System.debug('---userHasAccess'+userHasAccess);
                 teamcount = [select count() from Opportunity_Teams__c where Opportunity_Team_Member__r.user__c=:userid AND opportunity__c=:oppid limit 1];
                 if(userHasAccess && teamcount > 0){
                    matrix =  allProfiles.get(profilename+' (TM)');
                    if(srvgrp.equals(SWBBPOSEIntegrationConstants.BPO_IS)){
                        if(profilename.contains(SWBBPOSEIntegrationConstants.io)){
                            accesslevel=matrix.Bundled_IO_Deal__c;
                            System.debug('condition 1'+accesslevel);
                            
                        }
                        else{
                            accesslevel=matrix.Bundled_BPO_Deal__c;
                            System.debug('condition 1'+accesslevel);
                        }
                    }
                    else if(srvgrp.equals(SWBBPOSEIntegrationConstants.io) || srvgrp.equals(SWBBPOSEIntegrationConstants.IC)){
                        accesslevel=matrix.IO_Deal__c;
                        System.debug('condition 1'+accesslevel);
                        
                    }
                    else if(srvgrp.equals(SWBBPOSEIntegrationConstants.IO_IC)){
                        accesslevel=matrix.IO_IC_Deal__c;
                        System.debug('condition 1'+accesslevel);
                        
                    }
                    else{
                        accesslevel=matrix.BPO_Deal__c;
                        System.debug('condition 1'+accesslevel);
                    }
                 }            
                 else{
                    matrix =  allProfiles.get(profilename+' (NTM)');
                    if(srvgrp.equals(SWBBPOSEIntegrationConstants.BPO_IS)){
                        if(profilename.contains(SWBBPOSEIntegrationConstants.io)){
                            accesslevel=matrix.Bundled_IO_Deal__c;
                            System.debug('condition 1'+accesslevel);
                        }
                        else{
                            accesslevel=matrix.Bundled_BPO_Deal__c;
                            System.debug('condition 1'+accesslevel);
                        }
                    }
                    else if(srvgrp.equals(SWBBPOSEIntegrationConstants.io) || srvgrp.equals(SWBBPOSEIntegrationConstants.IC)){
                        accesslevel=matrix.IO_Deal__c;
                        System.debug('condition 1'+accesslevel);
                    }
                    else if(srvgrp.equals(SWBBPOSEIntegrationConstants.IO_IC)){
                        accesslevel=matrix.IO_IC_Deal__c;
                        System.debug('condition 1'+accesslevel);
                    }
                    else{
                        accesslevel=matrix.BPO_Deal__c;
                        System.debug('condition 1'+accesslevel);
                    }
                 }
            }
            else{
                matrix = allProfiles.get(profilename);
                if(matrix!=null){
                    if(srvgrp.equals('BPO + IS')){
                        if(profilename.contains(SWBBPOSEIntegrationConstants.io) || profilename.contains(SWBBPOSEIntegrationConstants.IC) || profilename.contains(SWBBPOSEIntegrationConstants.IS)){
                            accesslevel=matrix.Bundled_IO_Deal__c;
                            System.debug('condition 1'+accesslevel);
                        }
                        else{
                            accesslevel=matrix.Bundled_BPO_Deal__c;
                            System.debug('condition 1'+accesslevel);
                        }
                        
                     }
                     else if(srvgrp.equals(SWBBPOSEIntegrationConstants.io) || srvgrp.equals(SWBBPOSEIntegrationConstants.IC)){
                            accesslevel=matrix.IO_Deal__c;
                            System.debug('condition 1'+accesslevel);
                     }
                    else if(srvgrp.equals(SWBBPOSEIntegrationConstants.IO_IC)){
                        accesslevel=matrix.IO_IC_Deal__c;
                        System.debug('condition 1'+accesslevel);
                    }
                    else{
                        accesslevel=matrix.BPO_Deal__c;
                        System.debug('condition 1'+accesslevel);
                    }
                }
                else{
                    accesslevel=SWBBPOSEIntegrationConstants.NoAccess;
                }
                 
            }
        return accesslevel ;
    }
}