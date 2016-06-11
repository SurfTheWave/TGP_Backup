@istest
public class techToolTriggerTest {
     static testMethod void updatetechtoolTest(){
        List<SObject> genericmasterlist=new List<SObject>();
        List<SObject> genericmasterlist2=new List<SObject>();
        List<Offering_Master__c> offeringmasterlist=new List<Offering_Master__c>();
        //setting up master data
        Offering_Master__c offeringmaster=new Offering_Master__c(name='Test Offering',flywheel_non_flywheel__c='Finance',Service_Group__c='BPO',active__c=true,offering_description__c='test offering' );
        insert offeringmaster;
        Offering_Master__c offeringmaster1=new Offering_Master__c(name='Sourcing and Procurement',flywheel_non_flywheel__c='Finance',Service_Group__c='BPO',active__c=true,offering_description__c='test offering' );
        insert offeringmaster1; 
        Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offeringmaster1.name,offeringmaster1.id);
        insert customSetting;
        list<CS_SupportOffs__c> supportoffs = new list<CS_SupportOffs__c>();
        supportoffs.add(new CS_SupportOffs__c(name='BST'));
        supportoffs.add(new CS_SupportOffs__c(name='PMO'));
        supportoffs.add(new CS_SupportOffs__c(name='Technology'));
        supportoffs.add(new CS_SupportOffs__c(name='Mobilization'));
        insert supportoffs;
        Services_Master__c servicemaster=new Services_Master__c(name='ABC',active__c=true,Service_Group__c='BPO',Solution_Component__c='Delivery',offering__c=offeringmaster.id,Is_Offering_Specific_Service__c=true);
        Services_Master__c servicemaster1=new Services_Master__c(name='Technology Tools',active__c=true,Service_Group__c='BPO',Solution_Component__c='Technology',offering__c=offeringmaster.id,Is_Offering_Specific_Service__c=true);
        insert servicemaster1;
        insert servicemaster;
        Tech_Tool_Master__c techtoolmaster =new Tech_Tool_Master__c(Services__c=servicemaster1.id,name='APC',active__c=true);
        insert techtoolmaster;
        system.debug('tech tool master -->'+techtoolmaster);
        Operating_Groups_Master__c OppGrpMaster = new Operating_Groups_Master__c(Name = 'testName',Active__c = true);
        insert OppGrpMaster;
        Opportunity opp=new Opportunity();
        opp.OperatingGroup__c=OppGrpMaster.id;
        opp.name=UtilConstants.TEST_OPP;
        opp.Geo_Area__c=UtilConstants.APAC;
        opp.Reporting_Status__c=UtilConstants.UNQUALIFIED;
        opp.StageName=UtilConstants.OA;
        opp.Risk_Level__c=UtilConstants.LOW;
        opp.is_synced__c = true;
        opp.CloseDate= date.newInstance(2001, 3, 21);
        insert(opp);
        Solution_Scope__c solscope=new Solution_Scope__c(Opportunity__c=opp.id,Solution_Component__c='Delivery',Offering_Master__c=offeringmaster.id); 
        insert solscope;
        service__c serv = [select id from service__c where solutionscope__C=:solscope.id limit 1];
        integer solscopelist = [select count() from solution_scope__c where Offering_Master__r.name ='Test Offering'];
        system.debug('solution scopes inserted '+solscopelist);
        system.debug('service insertin --->'+serv);
        /*service__c serv = new service__C();
        serv.solutionscope__C = solscope.id;
        serv.services__c = servicemaster.id;
        serv.scope_Status__c = 'In Scope';
        try{
            insert serv;
        }
        catch(exception e){
            system.debug('exception at service insertion '+e);
        }*/
        tech_tools__c tech = [select id,scope_status__c from tech_tools__c where Tech_Tool__r.name ='APC' limit 1];
        system.debug('sotechnology too queried ----> '+tech);
        tech.Scope_Status__c='In Scope';
        utilconstants.allowactivation = false;
        UtilConstants.allowstatusupdation = false;
        try{
        update tech;
        }
        catch(exception e){
            system.assert(e.getmessage().contains(UtilConstants.scopecantbeupdate));
        }
    }
}