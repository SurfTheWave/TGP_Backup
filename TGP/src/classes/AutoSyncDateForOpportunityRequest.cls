/*****************
    @author : SWB
    @description : This class holds data for autosyncdate method of BPOSE integration
    *******************/
    public with sharing class AutoSyncDateForOpportunityRequest {
    public String opportunityid;
    public DateTime ContractStartDate,ContractEndDate,GoLiveDate;
    
    /*****************
    @author : SWB
    @description : This class holds data for autosyncdate method of BPOSE integration
    *******************/
    public class AutoSyncDateForOpportunityResponse{
        public Boolean status;
    }    
}