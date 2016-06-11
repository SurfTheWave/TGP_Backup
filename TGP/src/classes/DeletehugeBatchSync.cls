/**   @Author Ezhdan
   @name   DeleteBatchSync
   @CreateDate 14 Augest 2015
   @Description DeleteBatchSync
   @Version
  */
global class DeletehugeBatchSync implements Database.batchable<list<sobject>>,database.stateful{
global list<list<sobject>> records_todelete;
global id oppid;
global id costrecid;
global string type;
global Integer errorIndex;
@testvisible 
    private String isTestvariable='hello';
    /**
   *  @name : DeletehugeBatchSync
   *  @Description : constructor
   *  @param : Opportunityid
   *  @return parameter - NA
   *  @throws exception- NA
   */
    global DeletehugeBatchSync(id Opportunityid,id costid,string servicegroup){
       oppid = Opportunityid;
       costrecid = costid;
       list<fte_details__C> ftelist= new list<fte_details__c>();
       list<other_cost_details__c> ocdlist = new list<other_cost_details__c>();
       list<Payroll__c> payrolldata= new List<Payroll__c>();
	   list<Volume_Detail__c> volumedata= new List<Volume_Detail__c>();
	   list<Cross_Deal__c> crossdealdata= new List<Cross_Deal__c>();
	   if(servicegroup.equalsIgnoreCase('BPO')){
	       ftelist = [select id from fte_details__C where Opportunity__C=:oppid AND is_transient__c = true and Service_Group__c='BPO' limit 5000];
	       if(! ftelist.isempty()){
	            records_todelete.add((List<sObject>)ftelist);
	       }
	       ocdlist = [select id from other_cost_details__c where Opportunity__c=:oppid AND is_transient__c=true and Service_Group__c='BPO' limit 5000];
	       if(! ocdlist.isempty()){
	            records_todelete.add((List<sObject>)ocdlist);
	       }
	   }
	   else{
	   		ftelist = [select id from fte_details__C where Opportunity__C=:oppid AND is_transient__c = true and Service_Group__c='IO' limit 5000];
	       if(! ftelist.isempty()){
	            records_todelete.add((List<sObject>)ftelist);
	       }
	       ocdlist = [select id from other_cost_details__c where Opportunity__c=:oppid AND is_transient__c=true and Service_Group__c='IO' limit 5000];
	       if(! ocdlist.isempty()){
	            records_todelete.add((List<sObject>)ocdlist);
	       }
	       payrolldata =[select id from Payroll__c where Opportunity__c=:oppid AND is_transient__c=true and Service_Group__c='IO' limit 5000];
	       if(!payrolldata.isEmpty()){
	       		records_todelete.add((List<sObject>)payrolldata);
	       }
	       volumedata =[select id from Volume_Detail__c where Opportunity__c=:oppid AND is_transient__c=true and Service_Group__c='IO' limit 5000];
	       if(!volumedata.isEmpty()){
	       		records_todelete.add((List<sObject>)volumedata);
	       }
	       crossdealdata =[select id from Cross_Deal__c where Opportunity__c=:oppid AND is_transient__c=true limit 5000];
	       if(!crossdealdata.isEmpty()){
	       		records_todelete.add((List<sObject>)crossdealdata);
	       }
	   }
       errorIndex = 0;
       ftelist.clear();
       ocdlist.clear();
       payrolldata.clear();
       volumedata.clear();
       crossdealdata.clear();
    } 
    /**
   *  @name : start
   *  @Description : start
   *  @param : BatchableContext
   *  @return parameter - NA
   *  @throws exception- NA
   */
    global Iterable<list<sObject>> start(Database.BatchableContext info){ 
       return records_todelete; 
   }     
    /**
   *  @name : execute
   *  @Description : execute
   *  @param : BatchableContext,scope
   *  @return parameter - void
   *  @throws exception- NA
   */   
   global void execute(Database.BatchableContext bc, List<list<sObject>> scope){
       try{
            list<fte_details__c> ftelist = new list<fte_details__c>();
            list<Other_cost_details__c> ocdlist = new list<Other_cost_details__c>();
            list<Payroll__c> payrolldata= new List<Payroll__c>();
			list<Volume_Detail__c> volumedata= new List<Volume_Detail__c>();
			list<Cross_Deal__c> crossdealdata= new List<Cross_Deal__c>();
            system.debug('combined list-->'+scope);
            if(scope[0].size()>0 ){
                if(scope[0] instanceof list<fte_details__c>){
                    ftelist  = ((list<fte_details__c>)scope[0]);
                }
                if(scope[0] instanceof list<Other_cost_details__c>){
                    ocdlist = ((list<Other_cost_details__c>)scope[0]);
                }
                if(scope[0] instanceof list<Payroll__c>){
                    payrolldata = ((list<Payroll__c>)scope[0]);
                }
                if(scope[0] instanceof list<Volume_Detail__c>){
                    volumedata = ((list<Volume_Detail__c>)scope[0]);
                }
                if(scope[0] instanceof list<Cross_Deal__c>){
                    crossdealdata = ((list<Cross_Deal__c>)scope[0]);
                }
            }
            if(scope.size()>1){
                if(scope[1].size()>0 ){
                    if(scope[1] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[1]);
                    }
                    if(scope[1] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[1]);
                    }
                    if(scope[1] instanceof list<Payroll__c>){
                    	payrolldata = ((list<Payroll__c>)scope[1]);
                	}
	                if(scope[1] instanceof list<Volume_Detail__c>){
	                    volumedata = ((list<Volume_Detail__c>)scope[1]);
	                }
	                if(scope[1] instanceof list<Cross_Deal__c>){
	                    crossdealdata = ((list<Cross_Deal__c>)scope[1]);
	                }
                }
            }
            if(scope.size()>2){
                if(scope[2].size()>0){
                    if(scope[2] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[2]);
                    }
                    if(scope[2] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[2]);
                    }
                    if(scope[2] instanceof list<Payroll__c>){
                    	payrolldata = ((list<Payroll__c>)scope[2]);
                	}
	                if(scope[2] instanceof list<Volume_Detail__c>){
	                    volumedata = ((list<Volume_Detail__c>)scope[2]);
	                }
	                if(scope[2] instanceof list<Cross_Deal__c>){
	                    crossdealdata = ((list<Cross_Deal__c>)scope[2]);
	                }
                }
            }
            
           if(scope.size()>3){
                if(scope[3].size()>0){
                    if(scope[3] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[3]);
                    }
                    if(scope[3] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[3]);
                    }
                    if(scope[3] instanceof list<Payroll__c>){
                    	payrolldata = ((list<Payroll__c>)scope[3]);
                	}
	                if(scope[3] instanceof list<Volume_Detail__c>){
	                    volumedata = ((list<Volume_Detail__c>)scope[3]);
	                }
	                if(scope[3] instanceof list<Cross_Deal__c>){
	                    crossdealdata = ((list<Cross_Deal__c>)scope[3]);
	                }
                }
            }
            if(scope.size()>4){
                if(scope[4].size()>0){
                    if(scope[4] instanceof list<fte_details__c>){
                        ftelist  = ((list<fte_details__c>)scope[4]);
                    }
                    if(scope[4] instanceof list<Other_cost_details__c>){
                        ocdlist = ((list<Other_cost_details__c>)scope[4]);
                    }
                    if(scope[4] instanceof list<Payroll__c>){
                    	payrolldata = ((list<Payroll__c>)scope[4]);
                	}
	                if(scope[4] instanceof list<Volume_Detail__c>){
	                    volumedata = ((list<Volume_Detail__c>)scope[4]);
	                }
	                if(scope[4] instanceof list<Cross_Deal__c>){
	                    crossdealdata = ((list<Cross_Deal__c>)scope[4]);
	                }
                }
            }
            if(!ftelist.isEmpty()){
            	database.delete(ftelist,true);
            }
            if(!ocdlist.isEmpty()){
            	database.delete(ocdlist,true);
            }
            if(!payrolldata.isEmpty()){
            	database.delete(payrolldata,true);
            }
            if(!volumedata.isEmpty()){
            	database.delete(volumedata,true);
            }
            if(!crossdealdata.isEmpty()){
            	database.delete(crossdealdata,true);
            }
       }
       catch(exception e){
         ExceptionClass.logException('DeletehugeBatchSync','execute method failed',e,UtilConstants.SWB,UtilConstants.BPOSE);
         errorindex++;
       }
   } 
   /**
   *  @name : finish
   *  @Description : finish
   *  @param : BatchableContext
   *  @return parameter - void
   *  @throws exception- NA
   */       
   global void finish(Database.BatchableContext info){
   Costing_request__C cost = new costing_request__c(id = costrecid);
      if(errorindex!= 0){
            cost.Sync_Failed_At__c = 'Rollback';
            cost.Data_Cleaning_dev__c=true;
            cost.in_progress__c ='2';
            cost.calculation__C = false;
            cost.in_sync__C = false; 
      }
      else{
           cost.Sync_Failed_At__c = '';
           cost.Data_Cleaning_dev__c=false;
           cost.in_progress__c ='0';
           cost.calculation__C = false;
           cost.in_sync__C = false;
      }
      database.update (cost,false);
   } 
}