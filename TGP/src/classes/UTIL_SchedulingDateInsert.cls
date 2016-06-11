public class UTIL_SchedulingDateInsert
{

    List<Scheduling__c> insertOffList = new List<Scheduling__c>();
    
    public void insertSchedulingDate(List<Opportunity_TGP__c> oppObjRecList)
    {
        String mondayDate;
        String nextMondayDate;
        String nextMondayDate1;
        String nextMondayDate2;
        Date d = System.today();
        Date mondayDate1 = d.toStartofWeek();
        DateTime mondayDate2; 
        DateTime mondayDateTime = datetime.newInstance(mondayDate1.year(), mondayDate1.month(),mondayDate1.day());  
        datetime myDate = datetime.newInstance(d.year(), d.month(),d.day());  
        String DayOfWeek = myDate.format('EEEE');                            
        if(DayOfWeek.equalsignorecase('Sunday')) {
            mondayDate2 = mondayDateTime - 6;
        }
        else {
            mondayDate2 = mondayDateTime + 1;
        }
        //DateTime mondayDate2 = mondayDate1 + 1;
        DateTime mondayDate3 = mondayDate2 + 7;
        DateTime mondayDate4 = mondayDate3 + 7;
        DateTime mondayDate5 = mondayDate4 + 7;
         
        
        String type_1='Opportunity_TGP__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type_1);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        
        
        String type_2='Opportunity_Offering__c';
        //Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchemaForOff = schemaMap.get(type_2);
        Map<String, Schema.SObjectField> fieldMapForOff = leadSchemaForOff.getDescribe().fields.getMap();


        set<String> keysetlist;

        for(Opportunity_TGP__c oppRec : oppObjRecList){
        
            keysetlist = new set<String>();
        
            Scheduling__c schObj = new Scheduling__c(); 
             schObj.BPO_Opportunity_MD__c = oppRec.id;
             schObj.MondayDate__c = mondayDate2;
             schObj.MondayDate_1__c = mondayDate3 ;
             schObj.MondayDate_2__c = mondayDate4 ;
             schObj.MondayDate_3__c = mondayDate5 ;
             schObj.isDateActive__c = true;
             schObj.First_Date__c = mondayDate2;
            
            insertOffList.add(schObj);
            

                

                if(oppRec.Enterprise_Solution_Architect_New__c != null){

                       String label = fieldMap.get('Enterprise_Solution_Architect_New__c').getDescribe().getLabel();
                
                       keysetlist.add(label + ';' +oppRec.Enterprise_Solution_Architect_New__c+ ';' +oppRec.id);
                }


                if(oppRec.Complex_Cost_Architect_New__c != null){

                       String label = fieldMap.get('Complex_Cost_Architect_New__c').getDescribe().getLabel();

                       keysetlist.add(label +';'+oppRec.Complex_Cost_Architect_New__c +';'+oppRec.id);
                }
                
                for(Opportunity_Offering__c offRec : [select Offering_Solution_Lead_Secondary_New__r.SFDC_User__c,Solution_Lead_New__r.SFDC_User__c,Solution_Specialist_New__r.SFDC_User__c,Solution_Specialist_New__c,Opportunity_TGP__c,Solution_Specialist_New__r.Name,
                                                    
                                                    Solution_Lead_New__r.Name,Solution_Lead_New__c,Offering_Solution_Lead_Secondary_New__r.Name,
                                                    Offering_Solution_Lead_Secondary_New__c from Opportunity_Offering__c where Opportunity_TGP__c =: oppRec.id]){


                                if(offRec.Solution_Lead_New__c != null){

                                                String label = fieldMapForOff.get('Solution_Lead_New__c').getDescribe().getLabel();

                                                keysetlist.add(label +  ';' +offRec.Solution_Lead_New__c+  ';' + oppRec.id);
                                }
                                if(offRec.Offering_Solution_Lead_Secondary_New__c != null){

                                                String label = fieldMapForOff.get('Offering_Solution_Lead_Secondary_New__c').getDescribe().getLabel();

                                                keysetlist.add(label +  ';' +offRec.Offering_Solution_Lead_Secondary_New__c+  ';' + oppRec.id);
                                }

                                if(offRec.Solution_Specialist_New__c != null){

                                                String label = fieldMapForOff.get('Solution_Specialist_New__c').getDescribe().getLabel();

                                                keysetlist.add(label +  ';' + offRec.Solution_Specialist_New__c +  ';' +  oppRec.id);
                                }
                }
                
                for(String keyRec : keysetlist){

                    String[] stringArray = keyRec.split(';'); 
                                
                    Scheduling__c obj = new Scheduling__c(); 
                    obj.BPO_Opportunity_MD__c = stringArray[2] ;                
                    obj.Role_Name__c = stringArray[0];
                    obj.User_Name__c =  [select Name from Review_User_Master__c where Id = : stringArray[1]].Name ;
                    obj.User_Id__c = stringArray[1];
                    obj.Key_Field__c = keyRec;
                    obj.First_Date__c = mondayDate2;
                    obj.User_SFDC_Id__c = [select SFDC_User__c from Review_User_Master__c where Id = : stringArray[1]].SFDC_User__c ;
                    obj.Current_week__c = 0;
                    obj.Current_week_1__c = 0;
                    obj.Current_week_2__c = 0;
                    obj.Current_week_3__c = 0;
                    obj.Ongoing__c = 0;
                    obj.isDateActive__c = false;
                    
                insertOffList.add(obj);
                }

        }
        System.debug('--------keysetlist------------'+keysetlist);
        System.debug('--------insertOffList------------'+insertOffList);
        
        List<Scheduling__c> schList = new List<Scheduling__c>();
        
        for(Scheduling__c schRec : insertOffList){
            
            schList.add(schRec);
        
        }
        System.debug('--------schList------------'+schList);
        insert schList;
    }
}