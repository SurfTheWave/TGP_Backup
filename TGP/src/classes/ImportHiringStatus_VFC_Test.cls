@isTest
/*
  @Author: 
  @Name: ImportHiringStatus_VFc
  @Created Date: 10 Feb 2016
  @Description: This is a test class for importing hiring status
  @version: 3.5
*/
private class ImportHiringStatus_VFC_Test{
   /*
  @Author: 
  @Name: deal
  @Created Date: 10 Feb 2016
  @Description: insert new deal
  @version: 3.5
  */
   public static Deal__c deal(){       
        Deal__c strDeal = new Deal__c(Name='DealTest123');
        insert strDeal;
		return strDeal;
   }
   
   /*
  @Author: 
  @Name: mobPlan
  @Created Date: 10 Feb 2016
  @Description: insert new mobilization plan
  @version: 3.5
  */
   public static Mobilization_Plan__c mobPlan(String dealId){              
        Mobilization_Plan__c strmobplan = new Mobilization_Plan__c(Name ='planTest123', Deal__c = dealId, Active__c =True);
        insert strmobplan;
    	return strmobplan;		
   }
   
   /*
  @Author: 
  @Name: ImportHiringStatus_VFc
  @Created Date: 10 Feb 2016
  @Description: insert new wave under mob plan
  @version: 3.5
  */
   public static Wave__c wave(String mobId){ 
        Wave__c wave = new Wave__c(Name='Wave 1',Mobilization_Plan__c=mobId,Active__c=True);
        insert wave;
		return wave;
   }
  
  /*
  @Author: 
  @Name: ImportHiringStatus_VFc
  @Created Date: 10 Feb 2016
  @Description: insert new hiring status under mob plan
  @version: 3.5
  */
   public static Hiring_Status__c hiringStatus(String waveId){
	   Hiring_Status__c hiringStatus = new Hiring_Status__c(Wave__c=waveId,Name='test');
	   insert hiringStatus;
	   return hiringStatus;
   }
  
  /*
  @Author: 
  @Name: ImportHiringStatus_VFc
  @Created Date: 10 Feb 2016
  @Description: validate the test data
  @version: 3.5
  */
   public static void testdata(){    
     	Deal__c deal = deal();
		Mobilization_Plan__c mobPlan = mobPlan(deal.Id);        
        Wave__c wave = wave(mobPlan.Id);		
		Hiring_Status__c hiringStatus = hiringStatus(wave.id);
   }    
   
}