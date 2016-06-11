/***
***/
@isTest public class batchDeliveryLocation_Test
{
   public static testmethod void testBUDeliveryLocation()
    {
        
        Operating_Groups_Master__c opGrpM=new Operating_Groups_Master__c(Name='TestGroupMaster',Active__c=true,Description__c='TestDescp');
        insert opGrpM;
        Geo_Region_Master__c geo=new Geo_Region_Master__c(name='APAC',active__c=true);
        insert geo;
        Opportunity opp=new Opportunity(Name='TestOpp',Geo_Region__c=geo.Id,Geo_Unit__c='ASEAN',OperatingGroup__c=opGrpM.Id,Reporting_Status__c='pipeline',StageName='0A',Risk_Level__c='Low',closedate=system.today());    
        insert opp;
    
        Offering_Master__c off=new Offering_Master__c(Name='financt',offering_description__c='Test offering Master',flywheel_non_flywheel__c='tesfly',Service_Group__c='BPO',Active__c=true);
        insert off;
    
        Offering_Name__c offName=new Offering_Name__c(name='Sourcing and Procurement');
        insert offName;
    Services_Master__c srvM=new Services_Master__c(Name='Tpayroll',active__c=true,Solution_Component__c='Delivery',Is_Offering_Specific_Service__c=true,offering__c=off.Id,Service_Group__c='BPO');
        insert srvM;
        Solution_Scope__c sscope1=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='Delivery',Offering_Master__c=off.id,IsUserAddedOffering__c=false,Service_Group__c='BPO'); 
        insert sscope1;
    //Solution_Scope__c sscope2=new Solution_Scope__c(Opportunity__c=opp.Id,Solution_Component__c='PMO',Offering_Master__c=off.Id); 
    system.debug('Mujhe Toota hua koi sitara mil gaya hota:'+sscope1.Service_Group__c);

         //Service__c srv=new Service__c(services__c=srvM.Id,Scope_Status__c='tbd',Solutionscope__c=sscope1.Id);
        //insert srv;
        Service__c  srv=[select id,Service_Group__c from Service__c where solutionscope__c=:sscope1.id ];
        system.debug('Mujhe Toota hua koi sitara mil gaya hota:'+srv.Service_Group__c);
        Country_Master__c country=new Country_Master__c(active__c=true,name='India',Geo_Region__c=geo.id);
        insert country;
        Delivery_Location_Masters__c delloc1 =new Delivery_Location_Masters__c(name='Mumbai',country__c=country.id);
        insert delloc1;
        Delivery_Location_Masters__c delloc2 =new Delivery_Location_Masters__c(name='Chennai',country__c=country.id);
        insert delloc2;
        Delivery_Location_Masters__c delloc3 =new Delivery_Location_Masters__c(name='Gautam Buddha Nagar',country__c=country.id);
        insert delloc3;
        //system.debug('delloc'+delloc);
        Opportunity_Delivery_Location__c oppdelloc =new Opportunity_Delivery_Location__c(Offering_Service__c=srv.id,Delivery_Location__c=delloc1.id);
        insert oppdelloc;
        Opportunity_Delivery_Location__c oppdelloc1 =new Opportunity_Delivery_Location__c(Offering_Service__c=srv.id,Delivery_Location__c=delloc2.id);
        insert oppdelloc1;
        Opportunity_Delivery_Location__c oppdelloc2 =new Opportunity_Delivery_Location__c(Offering_Service__c=srv.id,Delivery_Location__c=delloc3.id);
        insert oppdelloc2;
        List<Opportunity_Delivery_Location__c> aaaa = [select id,Opportunity_Delivery_Location__c.Offering_Service__c,Offering_Service__r.Service_Group__c,Offering_Service__r.Solutionscope__r.Service_Group__c from Opportunity_Delivery_Location__c];
        system.debug('Mujhe Toota hua koi sitara mil gaya hota:'+aaaa[0].Offering_Service__r.Service_Group__c+'rtyhsrthysrthrd '+aaaa[0].Offering_Service__r.Solutionscope__r.Service_Group__c);
        Test.startTest();
         id jobid=database.executeBatch(new batchupdateDeliveryLocation ());
        system.debug('----------------------------------------------------------------'+jobid);
        
        Test.stopTest();
        
    }
}