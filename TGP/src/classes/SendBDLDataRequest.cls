/*
@Author : Apoorva Sharma
@name : SendBDLDataRequest
@CreateDate : 6/23/2015
@Description : Wraper class for SendBDLDataRequest
*/
public with sharing class SendBDLDataRequest {
    public String opportunityid,LstBDLGeneratedVrNm,LstBDLGeneratedScNm,LstBDLGeneratedUserNm,ServiceGroup;
    public DateTime BDLGeneratedUTCDateTime;
    
    public class SendBDLDataResponse{
        public Boolean status;
    }

}