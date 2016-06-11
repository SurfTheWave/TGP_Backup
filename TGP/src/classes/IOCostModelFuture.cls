global class IOCostModelFuture
{
    @Future
    public static void calcOppFte(Id oppId){
        Decimal totalOffshoreFte = 0.0;
        Decimal totalOnshoreFte = 0.0;
        Decimal avgFteOffshore = 0.0;
        Decimal avgFteOnshore = 0.0;
        Opportunity opp_details;
        opp_details =[select name,FTE_Off_IO__c,FTE_Ons_IO__c,account.name from opportunity where id=:OppId limit 1];
        try{
            List <FTE_Details__c> fteList = [SELECT Y1_Dev__c,Y2_Dev__c,Country__r.Name 
                                            from FTE_Details__c where Opportunity__c=:OppId 
                                            and Service__r.Active__c = true];
            Set<String> offshoreCountry = new Set<String>{UtilConstants.INDIA,UtilConstants.PHILIPPINES,UtilConstants.CHINA,UtilConstants.HONGKONG};
            if(!fteList.isEmpty()){
                for(FTE_Details__c fteObj : fteList){
                    if(fteObj.Country__r.Name != null &&(offshoreCountry.contains(fteObj.Country__r.Name))){
                        totalOffshoreFte += fteObj.Y1_Dev__c + fteObj.Y2_Dev__c;
                    } 
                    else{
                        totalOnshoreFte += fteObj.Y1_Dev__c + fteObj.Y2_Dev__c;
                    }   
                }
            }
            avgFteOffshore = totalOffshoreFte/24;
            avgFteOnshore = totalOnshoreFte/24;
            opp_details.FTE_Off_IO__c = avgFteOffshore.setscale(2);
            opp_details.FTE_Ons_IO__c = avgFteOnshore.setscale(2);
             opp_details.Is_Synced_IO__c  = true; 
            update opp_details;
        }
        catch(Exception e){
            System.debug('Exception'+'*******'+e.getLineNumber());
        }
    }
    @Future
    public static void calcOtherCost(Id oppID){
    List<Other_Cost_Details__c> listOther_Cost_SWB = [select id,Y1__c,Y2__c from Other_Cost_Details__c where Opportunity__c=:oppID];
    List<Other_Cost_Details__c> listToupdate = new List<Other_Cost_Details__c>();
        try{
            System.debug('---listOther_Cost_SWB--'+listOther_Cost_SWB);
            for(Other_Cost_Details__c otherCostobj : listOther_Cost_SWB){
                Decimal otherCost = (otherCostobj.Y1__c+otherCostobj.Y2__c)/24;
                System.debug('---otherCost--'+otherCost);
                otherCostobj.Other_Cost_IO__c =  otherCost;
                listToupdate.add(otherCostobj);
                System.debug('---otherCostobj--'+otherCostobj);                  
            }
            if(listToupdate.size()>0){
                update listToupdate;
                System.debug('---listToupdate--'+listToupdate.size());
                System.debug('---listToupdate--'+listToupdate);
            }      
        }
        catch(Exception e){
            System.debug('Exception'+'*******'+e.getLineNumber());
        }    
    }
    @Future
    public static void calcPayroll(Id oppId){
        List<Payroll__c> listPayroll_SWB=[select id,Y1__C,y2__c from Payroll__c where Opportunity__c =:oppId];
        System.debug('---listPayroll_SWB--'+listPayroll_SWB);
        Decimal totalPayroll = 0.0;
        Decimal avgPayroll = 0.0;
        List<Payroll__c> payRollListToupdate = new List<Payroll__c>();
        try{
            if(!listPayroll_SWB.isEmpty()){
                for(Payroll__c payrollObj : listPayroll_SWB){
                    totalPayroll += (payrollObj.Y1__c+payrollObj.Y2__c);
                 }
            }
            avgPayroll = totalPayroll/24;
            
            for(Payroll__c payRollobj : listPayroll_SWB){
                payRollobj.PayRoll_Cost_IO__c = avgPayroll.setscale(2);
                payRollListToupdate.add(payRollobj);
            }
            System.debug('avgPayroll'+avgPayroll.setscale(2));
            update payRollListToupdate;
            System.debug('payRollListToupdate'+payRollListToupdate);
        }
        catch(Exception e){
            System.debug('Exception'+'*******'+e.getLineNumber());
        }
     }
     
     /**
    @Author Jayashree
    @name calcOppFte
    @CreateDate 21/10/2015
    @Description This is to insert Delivery Location
    @Version <1.0>
    @reference 
    */
    @Future
    public static void activateSubComps(Set<String> countryNames,MAP<String,ID> Serviceid,MAP<String,ID> SolutionScopeID){
        Set<String> localString = new Set<String>();
        Set<String> localScope = new Set<String>();
        List<Service__c> servList = new List<Service__c>();
        List<Solution_Scope__c> scopeList = new List<Solution_Scope__c>();
        try{
            ////System.debug('******'+countryNames);
            for(String count : countryNames){
                String[] results = count.split(';');
                ////System.debug('******'+results[0].trim()+';'+results[1].trim());
                localString.add(results[0].trim()+';'+results[1].trim());
                localScope.add(results[0].trim());
            }
            Service__c servObj;
            Solution_Scope__c scopeObj;
            for(String S : Serviceid.keyset()){
                if(localString.contains(S)){
                 servObj = new Service__c(id = serviceid.get(s));
                 servObj .Scope_Status__c = UtilConstants.IN_SCOPE;
                 servList.add(servObj );
                } 
                else{
                 servObj = new Service__c(id = serviceid.get(s));
                 servObj .Scope_Status__c = UtilConstants.OUT_SCOPE;
                 servList.add(servObj );
                }
                ////System.debug('servList'+servList);   
            }
            for(String S : SolutionScopeID.keyset()){
                if(localScope.contains(S)){
                    scopeObj = new Solution_Scope__c(id = SolutionScopeID.get(s));
                    scopeObj.Active__c = true;
                    scopeList.add(scopeObj );
                }
                else{
                    scopeObj = new Solution_Scope__c(id = SolutionScopeID.get(s));
                    scopeObj.Active__c = false;
                    scopeList.add(scopeObj );
                }    
            }
            if(!servList.isEmpty()){
                UtilConstants.allowactivationIO = true;
                database.update(servList);
            } 
            if(!scopeList.isEmpty()){
                UtilConstants.allowactivationIO = true;
                database.update(scopeList);
            } 
        }
        catch(Exception e){
            ////System.debug('Exception'+'*******'+e.getLineNumber());
        }                         
    }
}