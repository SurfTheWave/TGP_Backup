/*
Name :         FindSFDCApprovers
Description :  This class will find the SFDC/Non-SFDC users & ensure the uniqueness of Approver records
Author :       Mayank Tayal
User Story:    SOL_143

Updated by        Update date        User story
-----------    ------------------  --------------

*/
public class FindSFDCApprovers
{
    public static void searchSFDCUser(List<Approver_Master__c> lastApproverMaster)
    {
        if(lastApproverMaster.size()>0)
        {            
            List<Approver_Master__c> approversList=[select id, name, TCV_Range__c, Region__c from Approver_Master__c];
            for(Approver_Master__c appNew: lastApproverMaster)
            {
                if(approversList!=null && approversList.size()>0)
                {
                    for(Approver_Master__c app: approversList)
                    {
                        if(appNew.TCV_Range__c=='100M+' && app.TCV_Range__c=='100M+' && appNew.id!=app.id)
                        {
                            appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+'!');
                        }
                        else if(appNew.TCV_Range__c=='40-100M' && app.TCV_Range__c=='40-100M' && appNew.id!=app.id)
                        {
                            //appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+'!');
                            if(appNew.Region__c=='North America' && app.Region__c=='North America' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                            else if(appNew.Region__c=='APAC' && app.Region__c=='APAC' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                            else if(appNew.Region__c=='EMEA' && app.Region__c=='EMEA' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                            else if(appNew.Region__c=='Latin America' && app.Region__c=='Latin America' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                        }
                        else if(appNew.TCV_Range__c=='10-40M' && app.TCV_Range__c=='10-40M')
                        {
                            if(appNew.Region__c=='North America' && app.Region__c=='North America' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                            else if(appNew.Region__c=='APAC' && app.Region__c=='APAC' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                            else if(appNew.Region__c=='EMEA' && app.Region__c=='EMEA' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                            else if(appNew.Region__c=='Latin America' && app.Region__c=='Latin America' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                        }
                         else if(appNew.TCV_Range__c=='0-10M' && app.TCV_Range__c=='0-10M')
                        {
                            if(appNew.Region__c=='Italy' && app.Region__c=='Italy' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='SPAI' && app.Region__c=='SPAI' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='Gallia' && app.Region__c=='Gallia' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='Japan' && app.Region__c=='Japan' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='Australia' && app.Region__c=='Australia' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='Customer Contact' && app.Region__c=='Customer Contact' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='F&A' && app.Region__c=='F&A' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='HR' && app.Region__c=='HR' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='Health Admin' && app.Region__c=='Health Admin' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }else if(appNew.Region__c=='Other Offering' && app.Region__c=='Other Offering' && appNew.id!=app.id)
                            {
                                appNew.addError('Record already exists for TCV Range: '+appNew.TCV_Range__c+' and Region: '+appNew.Region__c+'!');
                            }
                            
                        }
                    }
                }
            }            
            
            for(Approver_Master__c app: lastApproverMaster)
            {                      
                List<User> userList=[select id, name from User where email=:app.Approver_Mail_ID__c ];
                if(userList.size()>0)
                {
                    app.IS_SFDC_User__c=true;
                    //update app;
                }
                else
                {
                    app.IS_SFDC_User__c=false;
                }
            }            
        }
    }
}