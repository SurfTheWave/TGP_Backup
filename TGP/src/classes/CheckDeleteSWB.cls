/**
 *
 *    ClassName:
 *
 *    Purpose:
 *
 *
 */
public without sharing class CheckDeleteSWB{

    public Id RecordId {get;set;}
    public Id parentId {get;set;}
    public String urlPeram {get; set;}

    public CheckDeleteSWB(ApexPages.StandardController strController) { 
        
        RecordId = strController.getId();
       parentId = ApexPages.currentPage().getParameters().get('id');
       urlPeram  = ApexPages.currentPage().getParameters().get('retURL');
       String[] cd = urlPeram.split('/');
       urlPeram =cd[1];
       //System.debug('url =======>>>'+cd[1]);
    }
    
    public PageReference CheckDeleteSWB(){
   
        Boolean isUserFound=false;
        String strUserId = UserInfo.getUserId();


        String userProfileName = [select u.Profile.Name from User u where u.id = :strUserId].Profile.Name; //Get users with Profile Name

        if(userProfileName.equalsIgnoreCase('Solution Operations')){
            isUserFound=true;
        }        
        if(isUserFound==false){
        Boolean shareValue = [SELECT  RecordId,MaxAccessLevel,HasEditAccess  FROM UserRecordAccess where UserId =: strUserId and RecordId =: RecordId].HasEditAccess;
            if(shareValue){
                isUserFound=true;
            }          
        }           
        //System.debug('isUserFound=======>>>'+isUserFound);
        if(isUserFound){
            Schema.SObjectType sobj = RecordId.getSobjectType();
            String objectAPIName = string.valueof(sobj);
            string query = 'SELECT id FROM '+ objectAPIName +' where id = '+ '\''+ RecordId  + '\'' ;
            //System.debug('query =======>>>'+query );
            list<sobject> getshareRecords = database.query(query);
            List<Database.deleteResult> performdelete = Database.delete(getshareRecords,false);
            //System.debug('performdelete =======>>>'+performdelete);
            for (Database.DeleteResult sr : performdelete) {
                        if (sr.isSuccess()) {
                             PageReference ref =  new PageReference('/'+urlPeram);
                             return ref ;
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                        //System.debug('The following error has occurred.');                    
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //System.debug('Account fields that affected this error: ' + err.getFields());
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,err.getMessage()));
                        return null;
                    }
                }
            }
            //PageReference ref =  new PageReference('/'+urlPeram);
            //return ref ; 
        }else{
        //System.debug('Insufficient Privileges=======>>>'+urlPeram);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient Privileges'));
            return null;
        }   
         return null;
    }
}