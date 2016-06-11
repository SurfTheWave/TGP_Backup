/*
  @Author: Reena Thakre
  @Name: Util Constants for SWB
  @Created Date: 29 January 2015
  @Description: This class defines all Constants required as part of Solution  Workbench development 
  @version: 1.0  
  ----------------------------------------------------------
  @modified by : Ezdhan Hussain
  @description : changed code to remove hardcoding of ID's of profiles
*/
public class UtilConstantsforSWB {
    public static final String CHILD_OPPORTUNITY_CREATED = 'Child Opportunity Created';
    public static final string zerotwo ='02';
    public static final String COMPLETED = 'Completed';
    public static final String BPO_SOLUTION_WORKBENCH = 'BPOSolutionWorkbench';
    public static final String IO_SOLUTION_WORKBENCH = 'BPOSolutionWorkbench';
    public static final String IC_SOLUTION_WORKBENCH = 'BPOSolutionWorkbench';
    public static final String PIPELINE = 'Pipeline';
    public static final String UNQUALIFIED = 'Unqualified';
    public static final String TRAINING = 'Training';
    public static final String OTHER_DEAL_SUPPORT = 'Other Deal Support';
    public static final String OTHER_UNAVAILABLE = 'Other Unavailable';
    public static final String OUT_OF_OFFICE = 'Out Of Office';
    public static final String DAY_FORMAT = 'EEEE';
    public static final String SUNDAY = 'Sunday';
    public static final String IST = 'IST';
    public static final String MONDAY = 'Monday';
    public static final String TUESDAY = 'Tuesday';
    public static final String WEDNESDAY = 'Wednesday';
    public static final String THURSDAY = 'Thursday';
    public static final String FRIDAY = 'Friday';
    public static final String DATEFORMAT = 'dd-MMM';
    public static final String MONDAYDATECS = 'MondayDate';
    public static final String MONDAYDATE1CS = 'MondayDate+1';
    public static final String MONDAYDATE2CS = 'MondayDate+2';
    public static final String MONDAYDATE3CS = 'MondayDate+3';
    public static final String MONDAYDATE4CS = 'MondayDate+4';
    public static final String TEMPOPP1 = 'Total Allocated Time';
    public static final String TEMPOPP2 = 'Available For Staffing';
    public static final String TEMPOPP3 = 'Out Of Office(In %)';
    public static final String RELATIVEURL = '/apex/VFP_Utilization';
    public static final String TEMPCLIENT = '.';
    public static final String UTILIZATION_ERROR_MSG = 'You cannot insert negative values';
    public static String SystemAdmin;
    public static String SolutionOperation;
    public static string SolutionEditor;
    public static string IOSolutionEditor;
    public static string ICSolutionEditor;
    public static final string ApprovalMailBPO = 'Approval Mail BPO';
    public static final string FinalApprovalBPO = 'Final Approval BPO';
    public static final string FinalApproval='Final Approval';
    public static final String FIN_APPRBPO='BPO Final Approval';//by diwanshu and anamika  
    public static final String FIN_APPRIO='IO Final Approval';//by diwanshu and anamika
    public static final String FIN_APPRIC='IC Final Approval';//by diwanshu and anamika
    public static final String FinalApprovalOps='Operations Approval';//by diwanshu and anamika
    public static final String Opscannotbeapproved='Operations cant be approved';//by diwanshu and anamika
    public static final String FinalApprovalIO='Final Approval IO';//by diwanshu and anamika
    public static final String FinalApprovalIC='Final Approval IC';//by diwanshu and anamika
    public static final String StageApproved ='App req cant approve as stage approved';//by diwanshu and anamika
    public static final string ServiceGroupBPO = 'BPO';
    public static final string approved = '<approved>';
    public static final string rework = '<rework>';
    public static final string readyforreview = '<ready for review>';
    public static final string reject = '<reject>';
    public static final string approved1 = 'Approved';
    public static final string rework1 = 'Rework';
    public static final string readyforreview1 = 'Ready For Review';
    public static final string reject1 = 'Reject';
    public static final string PendingwithApprover = 'Pending';//updated by diwanshu
    public static final string completed1 = '<completed>';
    public static final string onhold1 = '<on hold>';
    public static final string nextstage1 = '<next stage>';
    public static final string notstarted1 = '<not started>';
    public static final string InProgress1 = '<In Progress>';
    public static final string onhold = 'on hold';
    public static final string nextstage = 'next stage';
    public static final string notstarted = 'not started';
    public static final string InProgress = 'In Progress';
    public static final string ApprovalMailIC = 'Approval Mail IC';
    public static final string ApprovalMailIO = 'Approval Mail IO';
    public static final string ResponseNotRec = 'Response not recorded in the System';
    public static final string UnauthorizedMailApproval = 'Unauthorized Mail Approval';
    public static final string ActionMailBPO = 'Action_Items';
    public static final string ActionItemCompleted = 'Completed';
    public static final string CLIENT_VISIT_TEMPLATE = 'New Client Visit Request Notification';
    public static final string CLIENT_VISIT_FEEDBACK_TEMPLATE = 'Visit Feedback Request Notification';
    public static final string CLIENT_VISIT_FEEDBACK_UPDATE_TEMPLATE = 'Visit Feedback Update Notification';
     public static final string ApprReqCannotBeApproved = 'Approval Request can not be approved';// by Anamika & Diwanshu
    public static final string CONTACT_CENTER_GROUP ='Contact Centre Group';
    public static final string CAPABILITY_TEAM_EDIT='Capability_Team_Edit';
    public static final string Supporting_Tech_Architect ='Supporting Tech Architect';
     public static final string ERROR_MSG_SupportingTech='Only the Tech Architect Are allowed to add Supporting Tech Resources';
     public static final string ERROR_MSG_TechArchLead='Only the PMO/Offering Lead Are allowed to add Tech Arch Lead';
     public static final string Tech_Architect_Lead ='Technical Architect Lead';
     public static final string PUBLIC_GROUP = 'Child Opportunity Handler';
     public static final string CHILD = 'Child';
     public static final string STANDALONE = 'Standalone';
    public static final string PARENT = 'Parent';
     public static final string SEMICOLON =';';
     public static final string NEW_OPPORTUNITY_CIRCLE_REQ ='New Opportunity Circle request';
    /******************
      Constructor
     ********************
    public UtilConstantsforSWB() {
        //utilmethod();
    }
    ********/
    /**************
        @dummy method to execute profile query on class invocation and assign values to static variables.
        @ method is written to avoid novasuite error "Avoid query in Constructor" & "Avoid Hardcoding of Ids"
    ******************/
    /*public void utilmethod(){
        for(Profile pro : [select id,name from profile limit 100]){
            if(pro.name.equalsignorecase(Label.System_Admin_Profile)){
                SystemAdmin = pro.id;
            }
            else if(pro.name.equalsignorecase(Label.Solution_Operations_Profile_Name)){
                SolutionOperation = pro.id;
            }
            else if(pro.name.equalsignorecase(Label.solution_editor_profile)){
                SolutionEditor = pro.id;
            }
            else if(pro.name.equalsignorecase(Label.IOSolutionEditor_profile)){
                IOSolutionEditor = pro.id;
            }
            else if(pro.name.equalsignorecase(Label.IC_solution_editor_profile)){
                ICSolutionEditor = pro.id;
            }
            else{
                
            }
        }
    }*/
    /**
     * @Description : This utility method generate profile details
     * @param : profileName: String parameter for Profile Name 
     * @return parameter : ID 
     * @throws exception: NA
     */
    public static ID utilMethod(String profileName) {
        try {
            Profile prof = [Select id from Profile where Name = : profileName limit 1];
            return prof.id;
        } Catch(QueryException e) {
            //System.debug('E==='+e);
        }
        return null;
    }

    /**
     * @Description : This method maps the list of Id's with Profile detail
     * @param : list String for the Profile details
     * @return parameter : map<id,profile> ID details
     * @throws exception: NA
     */
    public static map < id, profile > queryProfiles(list < String > profileName) {
        try {
            map < id, Profile > prof = new map < id, profile > ([Select id, name from Profile where Name IN: profileName limit 20]);
            return prof;
        } Catch(QueryException e) {
            //System.debug('E==='+e);
        }
        return null;
    }
}