/******************************
   @Author       : Modified by Yasin,Aswajit,reason-PTO calculation updates and Novasuite fixes were not present 25/05/2015
   @Class name   : OperationOnPtoTriggerController 
   @CreateDate   : 
   @Description : 
   @Version : 1.0 
*******************************/
public without sharing class OperationOnPtoTriggerController {
    /******************************
     * Method Name: populateUtilization
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/
    public static void populateUtilization(List < PTO__c > ptoList) {
        //List<PTO__c> ptoListNew = [Select Id,User__c,Name from PTO__c where Id IN :ptoList];
        Set < Id > userMasterIds = new Set < Id > ();
        map < id, PTO__c > ptoListToUpdate = new map < id, PTO__c > ();
        List < Utilizations__c > utilList = new List < Utilizations__c > ();
        for (PTO__c ptoRec: ptoList) {
            userMasterIds.add(ptoRec.User__c);
        }
        utilList = [Select Id, Opportunity__r.Name, User__c From Utilizations__c where User__c IN: userMasterIds AND
        Opportunity__r.Name = : UtilConstantsforSWB.OUT_OF_OFFICE limit 40000];
        if (ptoList.size() > 0) {
            for (PTO__c ptoRec: ptoList) {
                if (utilList.size() > 0) {
                    for (Utilizations__c utilRec: utilList) {
                        if (ptoRec.User__c.equals(utilRec.User__c)) {
                            ptoRec.Utilization__c = utilRec.id;
                            ptoListToUpdate.put(ptoRec.id, ptoRec);
                        }
                    }
                }
            }
            if (ptoListToUpdate.values().size() > 0) {
                Database.update(ptoListToUpdate.values());
            }
        }
    }
    /******************************
     * Method Name: populateUser
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/
    public static void populateUser(List < PTO__c > ptoList) {
        List < PTO__c > ptoListToQuery = new List < PTO__c > ();
        set < id > utilids = new set < id > ();
        map < id, id > utilMapwithusers = new map < id, id > ();
        ptoListToQuery = [Select Id, Name, user__c, utilization__c from PTO__c where Id IN: ptoList Limit 5000];
        List < User_Master__c > userMasterList = new List < User_Master__c > ();
        for (pto__c pt: ptolistToQuery) {
            if (pt.Utilization__c != null) {
                utilids.add(pt.utilization__c);
            }
        }
        List < PTO__c > ptoListToUpdate = new List < PTO__c > ();
        if (!utilids.isEmpty()) {
            for (utilizations__c util: [select id, name, user__c from utilizations__c where id IN: utilids Limit 5000]) {
                utilMapwithusers.put(util.id, util.user__c);
            }
            for (PTO__c ptoRec: ptoListToQuery) {
                ptoRec.user__c = utilMapwithusers.get(ptoRec.utilization__c);
                ptoListToUpdate.add(ptoRec);
            }
        } else {
            Id userId = UserInfo.getUserId();
            //String Email =[Select Email from User where Id=:userId].Email; 
            userMasterList = [select id, name from User_Master__c where user__c = : userId limit 1];
            for (PTO__c ptoRec: ptoListToQuery) {
                ptoRec.user__c = userMasterList[0].id;
                ptoListToUpdate.add(ptoRec);
            }
        }
        if (ptoListToUpdate.size() > 0) {
            //Database.update(ptoListToUpdate,false); 
            populateUtilization(ptoListToUpdate);
        }
    }
    /******************************
     * Method Name: calculatePto
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/
    public static void calculatePto(List < PTO__c > ptoList) {
        List < Utilizations__c > utilToUpdate = new List < Utilizations__c > ();
        List < Utilizations__c > utilizationList = new List < Utilizations__c > ();
        set < PTO__c > ptoListNew = new set < PTO__c > ();
        map < id, Pto__c > ptodeleteMap = new map < id, pto__c > ();
        set < id > utilids = new set < id > ();
         String MONDAYDATECS = UtilConstants.MONDATE;
        Utilization_weekStartDate__c myCS = Utilization_weekStartDate__c.getValues(MONDAYDATECS);

        Date mondayDateOfUser1DateValue = myCS.Referenced_Date__c;
        Date mondayDateOfUser2DateValue = mondayDateOfUser1DateValue + 7;
        Date mondayDateOfUser3DateValue = mondayDateOfUser2DateValue + 7;
        Date mondayDateOfUser4DateValue = mondayDateOfUser3DateValue + 7;
        Date mondayDateOfUser5DateValue = mondayDateOfUser4DateValue + 7;
        
        Set<Date> listMondayDateOfUser1DateValue = new Set<Date>();      
        Set<Date> listMondayDateOfUser2DateValue = new Set<Date>();  
        Set<Date> listMondayDateOfUser3DateValue = new Set<Date>();   
        Set<Date> listMondayDateOfUser4DateValue = new Set<Date>();            
        Set<Date> listMondayDateOfUser5DateValue = new Set<Date>(); 
     
        for(Integer i = 0; i < 5; i++){ 
          listMondayDateOfUser1DateValue.add(mondayDateOfUser1DateValue.adddays(i));
          listMondayDateOfUser2DateValue.add(mondayDateOfUser2DateValue.adddays(i));
          listMondayDateOfUser3DateValue.add(mondayDateOfUser3DateValue.adddays(i));  
          listMondayDateOfUser4DateValue.add(mondayDateOfUser4DateValue.adddays(i));       
          listMondayDateOfUser5DateValue.add(mondayDateOfUser5DateValue.adddays(i));     
        }
        for (pto__c pt: ptolist) {
            utilids.add(pt.utilization__c);
            ptodeleteMap.put(pt.id, pt);
        }

        set < pto__c > ptorecordsQueried = new set < pto__c > ();
        utilizationList = [SELECT Opportunity__c, Opportunity__r.Name,  Current_Week__c, Current_Week_1__c, Current_Week_2__c, Current_Week_3__c,
                                  Current_Week_4__c, Client_Name__c, (Select id, Utilization__c, PTO_Start__c, Name, Utilization__r.User__r.email__c, user__c, PTO_End__c from PTOs__r), User__c 
                                  FROM Utilizations__c
                                  WHERE Opportunity__r.Name = : UtilConstants.OUT_OF_OFFICE
        AND ID IN: utilids limit 5000];

        for (utilizations__c pt: utilizationList) {
            ptoListNew.addAll(pt.ptos__r);
        }
        
        for (pto__c pt: ptoListNew) {
            if (ptodeleteMap.containsKey(pt.id) && trigger.isdelete) {
                ptoListNew.remove(pt);
            }
        }
        for (Utilizations__c utilRec: utilizationList) {
            
            Decimal currentWeekTotalDays = 0;
            Decimal currentWeek1TotalDays = 0;
            Decimal currentWeek2TotalDays = 0;
            Decimal currentWeek3TotalDays = 0;
            Decimal currentWeek4TotalDays = 0;
            
            List < Integer > currentWeekPtoList = new List < Integer > ();
            List < Integer > currentWeek1PtoList = new List < Integer > ();
            List < Integer > currentWeek2PtoList = new List < Integer > ();
            List < Integer > currentWeek3PtoList = new List < Integer > ();
            List < Integer > currentWeek4PtoList = new List < Integer > ();

            if (ptoListNew.size() != 0) {
                for (pto__c ptoRec: ptoListNew) { 
                    Integer currentWeekPto = 0;
                    Integer currentWeek1Pto = 0;
                    Integer currentWeek2Pto = 0;
                    Integer currentWeek3Pto = 0;
                    Integer currentWeek4Pto = 0;
                        
                    if (ptoRec.utilization__c == utilRec.id) {                
                        Date tempStartDate = ptoRec.PTO_Start__c; 
                        Integer Nodays = tempStartDate.daysBetween(ptoRec.PTO_End__c); 
                        for(Integer i =0 ; i <= Nodays; i++){
                              if(listMondayDateOfUser1DateValue.contains(tempStartDate.adddays(i))){
                                  currentWeekPto = currentWeekPto+1;
                              }else if(listMondayDateOfUser2DateValue.contains(tempStartDate.adddays(i))){
                                  currentWeek1Pto = currentWeek1Pto+1;
                              }else if(listMondayDateOfUser3DateValue.contains(tempStartDate.adddays(i))){
                                  currentWeek2Pto = currentWeek2Pto+1; 
                              }else if(listMondayDateOfUser4DateValue.contains(tempStartDate.adddays(i))){
                                  currentWeek3Pto = currentWeek3Pto+1;
                              }else if(listMondayDateOfUser5DateValue.contains(tempStartDate.adddays(i))){
                                  currentWeek4Pto = currentWeek4Pto+1;
                              }
                        }
                      currentWeekPtoList.add(currentWeekPto); 
                      currentWeek1PtoList.add(currentWeek1Pto);
                      currentWeek2PtoList.add(currentWeek2Pto);
                      currentWeek3PtoList.add(currentWeek3Pto);
                      currentWeek4PtoList.add(currentWeek4Pto);
                    }   
                }
                currentWeekTotalDays = addTotalDays(currentWeekPtoList); 
                currentWeek1TotalDays = addTotalDays(currentWeek1PtoList);
                currentWeek2TotalDays = addTotalDays(currentWeek2PtoList);
                currentWeek3TotalDays = addTotalDays(currentWeek3PtoList);
                currentWeek4TotalDays = addTotalDays(currentWeek4PtoList);
                utilRec.Current_Week__c = Integer.valueof((currentWeekTotalDays) / 5 * 100);
                utilRec.Current_Week_1__c = Integer.valueof((currentWeek1TotalDays) / 5 * 100);
                utilRec.Current_Week_2__c = Integer.valueof((currentWeek2TotalDays) / 5 * 100);
                utilRec.Current_Week_3__c = Integer.valueof((currentWeek3TotalDays) / 5 * 100);
                utilRec.Current_Week_4__c = Integer.valueof((currentWeek4TotalDays) / 5 * 100);
                utilToUpdate.add(utilRec);  
                
            }else {
                utilRec.Current_Week__c = 0;
                utilRec.Current_Week_1__c = 0;
                utilRec.Current_Week_2__c = 0;
                utilRec.Current_Week_3__c = 0;
                utilRec.Current_Week_4__c = 0;
                utilToUpdate.add(utilRec);
            }
        }      
        // update utilizations__c
        if (utilToUpdate != null) 
            database.saveResult[] uresult = Database.update(utilToUpdate, true);
    }            
    
    /******************************
     * Method Name: addTotalDays
     * Description: 
     * Paramenters: 
     * Return Value: NA
     *******************************/
    public static Decimal addTotalDays(List < Integer > weekList) {
        Decimal totalDays = 0;
        for (Integer one: weekList) {
            totalDays += one;
        }
        return totalDays;
    }
}