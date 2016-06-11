@isTest
private class triggeronDMAT_Test{
  static testMethod void operationOnDMAT(){
        Operating_Groups_Master__c testOpGrpMstr = new Operating_Groups_Master__c(Name = 'India',Active__c = True);
        insert testOpGrpMstr;
        Account accounts =new Account(name='testaccount');
        insert accounts;
        //Opportunity oppObj = UTIL_DataCreationForTestClass.getOpportunity(oppGrpMaster);
        Opportunity opp = new Opportunity();
        opp.OperatingGroup__c= testOpGrpMstr.id;
        opp.name= UtilConstants.TEST_OPP;
        opp.Geo_Area__c= UTIL_Constants.AsiaPacific;
        opp.Reporting_Status__c= UtilConstants.UNQUALIFIED;
        opp.StageName= UtilConstants.OA;
        opp.Risk_Level__c= UtilConstants.LOW;
        opp.SAP_OM_Id_Dev__c= UtilConstants.SAPIDDEV;
        opp.SAP_OM_ID__c= UtilConstants.SAPOMID; 
        opp.CloseDate = date.newInstance(2001, 3, 21);
        insert opp;
         List<DMAT__c> lstDmat= new List<DMAT__c>();
         DMAT__c dmattest = new DMAT__c();
         dmattest.Opportunity_DMAT__c= opp.id;
         lstDmat.add(dmattest);
        insert lstDmat;
         
        Test.startTest();
        dmattest.Process_transformation__c = 'Yes';
        update lstDmat;
        Test.stopTest();
        }
        }