global class GetOpportunityDataForUserRequest{
        public String opportunityid;
        public String enterpriseid;
        public string ServiceGroup;
public class GetOpportunityDataForUserResponse{
        public boolean IsUserPresentInSystem,IsDealCustomizable,CanOpportunityBeCheckedOut,isDealEditableForUser,whatif;
        public String enterpriseid,ClientName,OpportunityName,OG,SalesGeography/*,ServiceGroup*/;
        public long SAPOMID;
        public Integer IsSyncInProgress,IsSyncInProgressForIO;
        public DateTime ContractStartDate,ContractEndDate,GoLiveDate;        
        public Set<String> Offerings = new Set<String>();
        public List<String> CountriesInScope=new List<String>();
        
        
    } 
}