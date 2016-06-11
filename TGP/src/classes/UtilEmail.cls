/**
    @Author     : Apoorva Sharma
    @name       : UtilEmail
    @CreateDate : 3 January 2015 
    @Description: Utility code for Email.
    @Version    : 1.0 
*/
public with sharing class UtilEmail {
    /**
     * @Description :
     * @name : emailid
     * @return parameter : string
     * @throws exception: NA
     */
    public static String emailid() {
        try {
            String orgWideEmailAddressID;
            String displayname = UtilConstantsforSWB.BPO_SOLUTION_WORKBENCH;
            OrgwideEmailAddress[] lstOrgWideEmailId = [Select id FROM OrgWideEmailAddress 
                                                    WHERE displayname = : displayname limit 1];
            if (lstOrgWideEmailId.size() == 0) {
            } else {
                orgWideEmailAddressID = lstOrgWideEmailId[0].id;
            }
            return (orgWideEmailAddressID);

        } catch (Exception e) {
            return (e + UtilConstants.EMPTY_STRING);

        }
    }
    /**
     * @Description : This utility method generate the email functionality for IO/IC service group
     * @name : emailidForIO
     * @param : Service Group 
     * @return parameter : orgWide Email Address ID
     * @throws exception: NA
     */
    public static String emailidForIO(string ServiceGroup) {
        try {
            //System.Debug('**********IC UtilMail **************');
            String displayname = UtilConstants.EMPTY_STRING;
            if (ServiceGroup == UtilConstants.IO) {
                displayname = UtilConstantsforSWB.IO_SOLUTION_WORKBENCH;
            } else if(ServiceGroup == UtilConstants.IC) {
                displayname = UtilConstantsforSWB.IC_SOLUTION_WORKBENCH;
            } else { //None
            }            
            String orgWideEmailAddressID = UtilConstants.EMPTY_STRING;
            OrgwideEmailAddress[] lstOrgWideEmailId = [Select id FROM OrgWideEmailAddress 
                                                        WHERE displayname = : displayname limit 1];
            if (lstOrgWideEmailId.size() == 0) {
            } else {
                orgWideEmailAddressID = lstOrgWideEmailId[0].id;
            }
            return (orgWideEmailAddressID);
        } catch (Exception e) {
            return (e + UtilConstants.EMPTY_STRING);
        }
    }
}