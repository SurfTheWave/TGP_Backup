/******************
@author : Ezdhan Hussain S K
@description : This class will hold OppID and Istansuccess boolean 
value and a inner class to hold response
@usage : used to deserialize and store JSON value for finalise transaction method
*******************/
public with sharing class FinalizeTransaction {
    public string Opportunityid;
    public boolean isTransactionSuccessful;
    public integer RowCount,CDRRowCount; 
    /*****************************************************************/
    //added on 24/07/2015
    public String  SSMVersion ,ScenarioNm, VersionNm,MRDBVersion,LstBDLGeneratedScNm,LstBDLGeneratedVrNm,LstBDLGeneratedUserNm;
    public String ScenarioContractStartDate,ScenarioContractEndDate,ScenarioGoLiveDate,MRDBDate,ServiceGroup;
    public datetime BDLGeneratedUTCDateTime;
    public String VersionID;
    public String BPOSETemplateVersion;
    public Boolean HasMasterDataBeenCustomizedForDeal;
    public string enterpriseid;
    public class FinalizeTransResponse{
        public integer status;
    }
}