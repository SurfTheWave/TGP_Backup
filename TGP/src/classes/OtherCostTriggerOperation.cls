/*
@Author : Apoorva Sharma
@name : OtherCostTriggerOperation
@CreateDate : 6/23/2015
@Description : This class handelles all the operations on other cost object
*/
public with sharing class OtherCostTriggerOperation {
    
    public static List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
    
    
    
     /******************************
    Method Name:insertDeliveryLocation
    Description:to insert delivery location
    Parameters: List<Other_Cost_Details__c> ocdDetailsList, Id opportunityId
    Return Value:Void
    ******************************/
   public static void insertDeliveryLocation(List<Other_Cost_Details__c> ocdDetailsList,Id opportunityId){
            List<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsert=new List<Opportunity_Delivery_Location__c>();
            Set<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsertSet=new Set<Opportunity_Delivery_Location__c>();
            List<Other_Cost_Details__c> ocdDataToUpdate=new List<Other_Cost_Details__c>();
            boolean isSucsess=false;
            Map<String,String>SolutionComponent=new Map<String,String>();
            Set<id>fteRecords=new set<id>();
            for(Other_Cost_Details__c fte:ocdDetailsList){
                fteRecords.add(fte.Service__c);
            }
            for(Service__c fterec:[Select id,Solutionscope__r.Solution_Component__c from Service__c where id in:fteRecords]){
                SolutionComponent.put(fterec.id+fterec.Solutionscope__r.Solution_Component__c,fterec.Solutionscope__r.Solution_Component__c);
                system.debug('Solution Component-------------------->'+fterec.id+fterec.Solutionscope__r.Solution_Component__c);
            }
            map<String,id> updatedCountryMaster=new map<String,id>();
            map<String,id> deliveryLocationMap=new map<String,id>();
            map<String,String> missingDeliveryLocation=new map<String,string>();
            map<String,id> servicesmap=new map<String,id>();
            Map<Id,String>countryRegion=new map<id,String>();
            for(Country_Master__c country: masterqueries.querycountrymasters()){
                    countryRegion.put(country.id,country.Geo_Region__r.name);
              }
            for(Delivery_Location_Masters__c deliveryloc : masterqueries.querydeliverymasters()){
            String dellocNService1;
            if(deliveryloc.name.contains(SWBBPOSEIntegrationConstants.hyphen)){
                        List<String> temp=deliveryloc.name.split(SWBBPOSEIntegrationConstants.hyphen);
                        dellocNService1=temp[1].trim();
                        system.debug('IND-Banglore'+dellocNService1);
                    }
                    else{   
                        dellocNService1=deliveryloc.name;
                    }                   
                     deliveryLocationMap.put(dellocNService1,deliveryloc.id);
              }
            for(Other_Cost_Details__c ocd :ocdDetailsList){
                if(ocd.Opportunity_Delivery_Location__c ==null){
                String dellocNService;               
                      dellocNService=ocd.Delivery_Location_Dev__c+ocd.Service__c;     
                missingDeliveryLocation.put(dellocNService,ocd.Delivery_Location_Dev__c);
                servicesmap.put(dellocNService,ocd.Service__c);
                }
            }
            //system.debug('delloc!!!!!!!!!!!!!!1234'+delloc);
            if(missingDeliveryLocation.keyset()!=null){
                for(String delloc:missingDeliveryLocation.keySet()){
                    system.debug('delloc!!!!!!!!!!!!!!1234'+delloc+'deliveryLocationMap.get(missingDeliveryLocation.get(delloc))'+deliveryLocationMap.get(missingDeliveryLocation.get(delloc)));
                    system.debug('service!!!!!!!!!!!!!!1234'+servicesmap.get(delloc));
                    if((deliveryLocationMap.get(missingDeliveryLocation.get(delloc)))!=null && (servicesmap.get(delloc)!=null)){
                    Opportunity_Delivery_Location__c oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=servicesmap.get(delloc);
                    oppDelLocation.Delivery_Location__c=deliveryLocationMap.get(missingDeliveryLocation.get(delloc));
                    oppDelLocation.active__c = true;
                    oppDeliveryLocationToInsert.add(oppDelLocation);
                    }
                }   
                oppDeliveryLocationToInsertSet.addAll(oppDeliveryLocationToInsert);
                oppDeliveryLocationToInsert.clear();
                oppDeliveryLocationToInsert.addAll(oppDeliveryLocationToInsert);
                try{
                    if(!oppDeliveryLocationToInsert.isEmpty()){
                        system.debug('isSucsess!!!!!!!!!!!!!!1234'+isSucsess);
                        SWBBPOSEIntegrationConstants.rundeliverylocationtrigger = false;
                        SWBBPOSEIntegrationConstants.runservTrigger = false;
                        database.insert(oppDeliveryLocationToInsert,false);
                        isSucsess=true;
                        system.debug('isSucsess!!!!!!!!!!!!!!'+isSucsess);
                    }
                }
                catch(exception e){
                ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.insertCountryInMaster,e,UtilConstants.SWB,UtilConstants.BPOSE);
                }
          }
        
        //updating ocd and ccd records
        if(isSucsess){
            
            
          for(Opportunity_Delivery_Location__c deliveryloc :[select Delivery_Location__c,Delivery_Location__r.name,Offering_Service__c
                                                         from Opportunity_Delivery_Location__c where  Offering_Service__r.Solutionscope__r.opportunity__c=:opportunityId
                                                        limit 5000]){
                    String dellocNService1;
                    if(deliveryloc.Delivery_Location__r.name.contains(SWBBPOSEIntegrationConstants.hyphen)){
                    
                        List<String> temp=deliveryloc.Delivery_Location__r.name.split(SWBBPOSEIntegrationConstants.hyphen);
                        dellocNService1=temp[1].trim()+deliveryloc.Offering_Service__c;
                        system.debug(' in del location master IND-Banglore'+dellocNService1);
                    }
                    else{   
                        dellocNService1=deliveryloc.Delivery_Location__r.name+deliveryloc.Offering_Service__c;
                    }                                
                     updatedCountryMaster.put(dellocNService1,deliveryloc.id);
              }
          //Map to polulate geo-reion value for country
             
              boolean deliverylocationfound=true; 
              List<Opportunity_Delivery_Location__c> nondcnlocationtoinsert= new list<Opportunity_Delivery_Location__c>();
              missingDeliveryLocation.clear();
              servicesmap.clear();    
          if(updatedCountryMaster!=null){ 
            //insert ocd 
            for(Other_Cost_Details__c ocd:ocdDetailsList){
            system.debug('ocd.Delivery_Location_Dev__c+ocd.Service__c'+ocd.Delivery_Location_Dev__c+ocd.Service__c+' updatedCountryMaster.get(ocd.Delivery_Location_Dev__c+ocd.Service__c)'+updatedCountryMaster.get(ocd.Delivery_Location_Dev__c+ocd.Service__c));
                if(updatedCountryMaster.get(ocd.Delivery_Location_Dev__c+ocd.Service__c) != null){
                           ocd.Opportunity_Delivery_Location__c = updatedCountryMaster.get(ocd.Delivery_Location_Dev__c+ocd.Service__c);
                            system.debug('in insertDeliveryLocation'+ocd.Opportunity_Delivery_Location__c);
                  }
                     else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && ocd.Load_Type_Dev__c!=null && ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                       if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                      ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.LatamClient+ocd.Service__c);
                      }
                  }
                  else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && ocd.Load_Type_Dev__c!=null && !(ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                    
                    if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                     ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.latamnondcnlocation+ocd.Service__c);
                     }
                  }
                  else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && ocd.Load_Type_Dev__c!=null && ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                     if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                    ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.EMEAClient+ocd.Service__c);
                    }
                  }
                  else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && ocd.Load_Type_Dev__c!=null && !(ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                    if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){                     
                      ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.emeanondcnlocation+ocd.Service__c);
                      }
                  }
                  else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && ocd.Load_Type_Dev__c!=null && ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                      if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                     
                     ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACCLIENT+ocd.Service__c);
                     }
                  }
                  else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && ocd.Load_Type_Dev__c!=null && !(ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                         if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                        ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+ocd.Service__c);
                        }
                  }
                  else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && ocd.Load_Type_Dev__c!=null && ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                      if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                     ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+ocd.Service__c);
                     }
                  }
                  else if(countryRegion.get(ocd.country__c)!=null && countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && ocd.Load_Type_Dev__c!=null && !(ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                         if(SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null &&((SolutionComponent.get(ocd.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(ocd.Delivery_Location_Dev__c!=null && ocd.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                        ocd.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NAlondcnlocation+ocd.Service__c);
                        }
                  }
                  if(ocd.Opportunity_Delivery_Location__c==null){
                                               deliverylocationfound=false;
                        String dellocNService;               
                        if(ocd.Load_Type_Dev__c!=null && !(ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){ 
                            if(!countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && !countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA)){        
                                dellocNService=countryRegion.get(ocd.country__c)+SWBBPOSEIntegrationConstants.ClientLoc+ocd.Service__c;     
                                missingDeliveryLocation.put(dellocNService,countryRegion.get(ocd.country__c)+SWBBPOSEIntegrationConstants.ClientLoc);
                            }
                            else if(countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA)){
                                dellocNService=SWBBPOSEIntegrationConstants.latamnondcnlocation+ocd.Service__c;     
                                missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.latamnondcnlocation);
                            }
                            else if(countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){
                            dellocNService=SWBBPOSEIntegrationConstants.NAlondcnlocation+ocd.Service__c;     
                                missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.NAlondcnlocation);
                            }
                            
                        }
                        else if(ocd.Load_Type_Dev__c!=null && (ocd.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                            if(countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC)){ 
                                     dellocNService=countryRegion.get(ocd.country__c)+SWBBPOSEIntegrationConstants.ClientLoc+ocd.Service__c;
                                     missingDeliveryLocation.put(dellocNService,countryRegion.get(ocd.country__c)+SWBBPOSEIntegrationConstants.ClientLoc);
                                }
                                else if(countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA)){
                                    dellocNService=SWBBPOSEIntegrationConstants.LatamClient+ocd.Service__c;
                                    missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.LatamClient);                                    
                                }
                                else if(countryRegion.get(ocd.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){
                                dellocNService=SWBBPOSEIntegrationConstants.NACLIENT+ocd.Service__c;
                                    missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.NACLIENT);
                                }
                            else{
                                  dellocNService=countryRegion.get(ocd.country__c)+SWBBPOSEIntegrationConstants.clientLocation+ocd.Service__c;
                                  missingDeliveryLocation.put(dellocNService,countryRegion.get(ocd.country__c)+SWBBPOSEIntegrationConstants.ClientLoc);
                            }
                        }
                        servicesmap.put(dellocNService,ocd.Service__c);
                  }   
             }
             
           }
             isSucsess=false;
             if(missingDeliveryLocation.keyset()!=null){
                for(String delloc:missingDeliveryLocation.keySet()){
                    system.debug('Non DCN Delivery Location--->'+delloc+'deliveryLocationMap.get(missingDeliveryLocation.get(delloc))'+deliveryLocationMap.get(missingDeliveryLocation.get(delloc)));
                    system.debug('service!!!!!!!!!!!!!!1234'+servicesmap.get(delloc));
                    if((deliveryLocationMap.get(missingDeliveryLocation.get(delloc)))!=null && (servicesmap.get(delloc)!=null)){
                    Opportunity_Delivery_Location__c oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=servicesmap.get(delloc);
                    oppDelLocation.Delivery_Location__c=deliveryLocationMap.get(missingDeliveryLocation.get(delloc));
                    oppDelLocation.active__c = true;
                    nondcnlocationtoinsert.add(oppDelLocation);
                    }
                }   
                try{
                    if(!nondcnlocationtoinsert.isEmpty()){
                        system.debug('isSucsess!!!!!!!!!!!!!!1234'+isSucsess);
                        SWBBPOSEIntegrationConstants.rundeliverylocationtrigger = false;
                        SWBBPOSEIntegrationConstants.runservTrigger = false;
                        database.insert(nondcnlocationtoinsert,false);
                        isSucsess=true;
                        system.debug('isSucsess for non dcn!!!!!!!!!!!!!!'+isSucsess);
                    }
                }
                catch(exception e){
                ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.insertCountryInMaster,e,UtilConstants.SWB,UtilConstants.BPOSE);
                }
           }
           
           if(isSucsess){
                for(Opportunity_Delivery_Location__c deliveryloc :[select Delivery_Location__c,Delivery_Location__r.name,Offering_Service__c
                                                         from Opportunity_Delivery_Location__c where  Offering_Service__r.Solutionscope__r.opportunity__c=:opportunityId
                                                        limit 5000]){
                        String dellocNService1;
                        if(deliveryloc.Delivery_Location__r.name.contains(SWBBPOSEIntegrationConstants.hyphen)){
                        
                            List<String> temp=deliveryloc.Delivery_Location__r.name.split(SWBBPOSEIntegrationConstants.hyphen);
                            dellocNService1=temp[1].trim()+deliveryloc.Offering_Service__c;
                            system.debug(' in del location master IND-Banglore'+dellocNService1);
                        }
                        else{   
                            dellocNService1=deliveryloc.Delivery_Location__r.name+deliveryloc.Offering_Service__c;
                        }                                
                        updatedCountryMaster.put(dellocNService1,deliveryloc.id);
                    }
              
                  if(updatedCountryMaster!=null){ 
                    for(Other_Cost_Details__c fte:ocdDetailsList){
                      if(fte.Opportunity_Delivery_Location__c==null){
                            if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                    if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){

                              fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.LatamClient+fte.Service__c);
                              }
                          }
                          else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                            if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                             fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c);
                             }
                          }
                          else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                             if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                             fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.EMEAClient+fte.Service__c);
                             }
                          }
                          else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                               if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                               fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.emeanondcnlocation+fte.Service__c);
                               }
                          }
                          else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                             if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                             fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACCLIENT+fte.Service__c);
                             }
                          }
                          else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                                if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c);
                                }
                          }
                          else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                             if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                             fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c);
                             }
                          }
                          else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                                if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NAlondcnlocation+fte.Service__c);
                                }
                          }
                        else{
                            system.debug('Delivery Location Not Mapped!!!!');
                        }
                      } 
                  }
              }
            }
          }
          else{
            system.debug('In_ELSE Part');
        //for(Country_Master__c country:[select id,Geo_Region__r.name from Country_Master__c]){
           //           countryRegion.put(country.id,country.Geo_Region__r.name);
             // }
              List<Other_Cost_Details__c> FteWithoutdeliveryloc =new list<Other_Cost_Details__c>(); 
              boolean deliverylocationfound=true; 
              missingDeliveryLocation.clear();
              servicesmap.clear();
              List<Opportunity_Delivery_Location__c> nondcnlocationtoinsert= new list<Opportunity_Delivery_Location__c>();
            for(Other_Cost_Details__c fte:ocdDetailsList){
                if(fte.Opportunity_Delivery_Location__c==null){
                            deliverylocationfound=false;
                        String dellocNService;               
                        if(fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){ 
                            if(!countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && !countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){        
                                dellocNService=countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.ClientLoc+fte.Service__c;     
                                missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.ClientLoc);
                            }
                            else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){
                            dellocNService=SWBBPOSEIntegrationConstants.NAlondcnlocation+fte.Service__c;     
                                missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.NAlondcnlocation);
                            }
                            else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA)){
                                dellocNService=SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c;     
                                missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.latamnondcnlocation);
                            }            
                        }
                        else if(fte.Load_Type_Dev__c!=null && (fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                            if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC)){ 
                                     dellocNService=countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.ClientLoc+fte.Service__c;
                                     missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.ClientLoc);
                                }
                                else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA)){
                                    dellocNService=SWBBPOSEIntegrationConstants.LatamClient+fte.Service__c;
                                    missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.LatamClient);                                    
                                }
                                else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){
                                    dellocNService=SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c;
                                    missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.NACLIENT);  
                                }
                            else{
                                  dellocNService=countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.clientLocation+fte.Service__c;
                                  missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.clientLocation);
                            }
                        }
                        servicesmap.put(dellocNService,fte.Service__c);
                  }
                
                }
                if(missingDeliveryLocation.keyset()!=null){
                for(String delloc:missingDeliveryLocation.keySet()){
                    system.debug('ELse Non DCN Delivery Location--->'+delloc+'deliveryLocationMap.get(missingDeliveryLocation.get(delloc))'+deliveryLocationMap.get(missingDeliveryLocation.get(delloc)));
                    system.debug('service!!!!!!!!!!!!!!1234'+servicesmap.get(delloc));
                    if((deliveryLocationMap.get(missingDeliveryLocation.get(delloc)))!=null && (servicesmap.get(delloc)!=null)){
                    Opportunity_Delivery_Location__c oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=servicesmap.get(delloc);
                    oppDelLocation.Delivery_Location__c=deliveryLocationMap.get(missingDeliveryLocation.get(delloc));
                    oppDelLocation.active__c = true;
                    nondcnlocationtoinsert.add(oppDelLocation);
                    }
                }   
                try{
                    if(!nondcnlocationtoinsert.isEmpty()){
                        system.debug('isSucsess!!!!!!!!!!!!!!1234'+isSucsess);
                        SWBBPOSEIntegrationConstants.rundeliverylocationtrigger = false;
                        SWBBPOSEIntegrationConstants.runservTrigger = false;
                        database.insert(nondcnlocationtoinsert,false);
                        isSucsess=true;
                        system.debug('isSucsess for non dcn!!!!!!!!!!!!!!'+isSucsess);
                    }
                }
                catch(exception e){
                ExceptionClass.logException(UtilConstants.ScopeUpdataion_FutureClass,UtilConstants.insertCountryInMaster,e,UtilConstants.SWB,UtilConstants.BPOSE);
                }
                      //if(isSucsess){
                for(Opportunity_Delivery_Location__c deliveryloc :[select Delivery_Location__c,Delivery_Location__r.name,Offering_Service__c
                                                         from Opportunity_Delivery_Location__c where  Offering_Service__r.Solutionscope__r.opportunity__c=:opportunityId
                                                        limit 5000]){
                        String dellocNService1;
                        if(deliveryloc.Delivery_Location__r.name.contains(SWBBPOSEIntegrationConstants.hyphen)){
                        
                            List<String> temp=deliveryloc.Delivery_Location__r.name.split(SWBBPOSEIntegrationConstants.hyphen);
                            dellocNService1=temp[1].trim()+deliveryloc.Offering_Service__c;
                            system.debug(' in del location master IND-Banglore'+dellocNService1);
                        }
                        else{   
                            dellocNService1=deliveryloc.Delivery_Location__r.name+deliveryloc.Offering_Service__c;
                        }                                
                        updatedCountryMaster.put(dellocNService1,deliveryloc.id);
                    }
              
                  if(updatedCountryMaster!=null){ 
                    for(Other_Cost_Details__c fte:ocdDetailsList){
                        system.debug(UtillContstant_Novasuite.NULL_VALUE+countryRegion.get(fte.country__c)+' fte.Load_Type_Dev__c'+fte.Load_Type_Dev__c);
                      if(fte.Opportunity_Delivery_Location__c==null){
                        if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                             if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                              fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.LatamClient+fte.Service__c);
                              }
                              }
                              else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                                  if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                  fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c);
                                  }
                              }
                              else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                                 if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                 fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.EMEAClient+fte.Service__c);
                                 }
                              }
                              else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                                   if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                   fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.emeanondcnlocation+fte.Service__c);
                                   }
                              }
                              else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                                 if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                 fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACCLIENT+fte.Service__c);
                                 }
                              }
                              else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                                    if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                    fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c);
                                    }
                              }
                              else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                                if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c);
                                }
                              }
                              else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                                if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                                   fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NAlondcnlocation+fte.Service__c);
                                   }
                              }
                            else{
                                system.debug('Delivery Location Not Mapped!!!!');
                            }
                        
                        
                        
                 
                      } 
                  }
              }
            //}
           }
                
            
          }
        } 
 /*************************
       @method Name: mapMissingTechTool
       @parameters : List<Other_Cost_Details__c> ocdDetailsList,Id opportunityId
       @output :called before insert and populates missing tech tools
       @returntype : void
     *****************************/
     
     public static void mapMissingTechTool(List<Other_Cost_Details__c> ocdDetailsList,Id opportunityId){
        
        map<String,id> missingTechtool=new map<String,id>();
        for(Tech_Tools__c tool:[select id, name,service__r.name,Tech_Tool_Name__c,Tech_Tool__c,Custom_Tool_Name__c from Tech_Tools__c where 
                                    service__r.Solutionscope__r.opportunity__c=:opportunityId and Service__r.Solutionscope__r.Offering_Master__r.name =:UtillContstant_Novasuite.CROSS_OFFRING  limit 5000]){
                                        
                missingTechtool.put(tool.Tech_Tool_Name__c+tool.Service__c,tool.id);
             }
         
         try{
            Service__c serAllTech =[Select id,Solutionscope__c from Service__c where Solutionscope__r.Offering_Master__r.name =:UtillContstant_Novasuite.CROSS_OFFRING
                                     and  Solutionscope__r.opportunity__c=:opportunityId and Solutionscope__r.Solution_Component__c=:UtillContstant_Novasuite.TECHNOLOGY limit 1 ];
            for(Other_Cost_Details__c ocd:ocdDetailsList){
             if(ocd.Tech_Tools__c==null && missingTechtool.get(ocd.Offering2__c+serAllTech.id)!=null){
                system.debug('missing tech tool in ocd trigger mapping '+missingTechtool.get(ocd.Offering2__c+serAllTech.id));
                ocd.Tech_Tools__c=missingTechtool.get(ocd.Offering2__c+serAllTech.id);
                ocd.service__C=serAllTech.id;
                ocd.Sub_Service_Group__c=serAllTech.Solutionscope__c;
             }
           }
             serAllTech.clear();
             missingTechtool=new map<String,id>();
         }
         catch(Exception e){
            
         }
         
        
     }
     /*************************
       @method Name: populatePayrollData
       @parameters : List<Other_Cost_Details__c> ocdDetailsList
       @output :populate payroll object after record insertion in other cost Details
       @returntype : void
       *****************************/
  public static void populatePayrollData(List<Other_Cost_Details__c> ocdDetailsList){
    List<Payroll__c> payrollToInsert=new List<Payroll__c>();
    for(Other_Cost_Details__c ocd: [SELECT ActivityDescription__c,BillCode__c,CareerTrack__c,Career_Level__c,
    CC_Grand_Total_Cost__c,Costing_Type__c,Cost_Type__c,Country__c,CreatedById,CreatedDate,Description1__c,
    Description2__c,Description3__c,Description4__c,Description5__c,Description6__c,Description7__c,Description_Full__c,
    EconomicProfile__c,Generic1__c,Generic2__c,Generic3__c,Go_Live_Date__c,Id,LoadType__c,M1__c,M2__c,M3__c,M4__c,M5__c,M6__c,M7__c,
    M8__c,M9__c,M10__c,M11__c,M12__c,M13__c,M14__c,M15__c,M16__c,M17__c,M18__c,M19__c,M20__c,M21__c,M22__c,M23__c,M24__c,M25__c,
    M26__c,M27__c,M28__c,M29__c,M30__c,M31__c,M32__c,M33__c,M34__c,M35__c,M36__c,M37__c,M38__c,M39__c,M40__c,M41__c,M42__c,M43__c,
    M44__c,M45__c,M46__c,M47__c,M48__c,M49__c,M50__c,M51__c,M52__c,M53__c,M54__c,M55__c,M56__c,M57__c,M58__c,M59__c,M60__c,M61__c,
    M62__c,M63__c,M64__c,M65__c,M66__c,M67__c,M68__c,M69__c,M70__c,M71__c,M72__c,M73__c,M74__c,M75__c,M76__c,M77__c,M78__c,M79__c,
    M80__c,M81__c,M82__c,M83__c,M84__c,M85__c,M86__c,M87__c,M88__c,M89__c,M90__c,M91__c,M92__c,M93__c,M94__c,M95__c,M96__c,M97__c,
    M98__c,M99__c,M100__c,M101__c,M102__c,M103__c,M104__c,M105__c,M106__c,M107__c,M108__c,M109__c,M110__c,M111__c,M112__c,M113__c,
    M114__c,M115__c,M116__c,M117__c,M118__c,M119__c,M120__c,Mobilization_Start_Date__c,Mob_Category__c,Mob_Cost__c,Mob_Sub_Category__c,
    Mob_Totals__c,Name,Offering2__c,Offering3__c,Opportunity__c,Phases__c,RateType_Load_Type__c,RateType__c,
    ResourceGroup_CareerTrack_EconomicPr__c,ResourceGroup__c,Run_Type__c,Run_Yr1__c,Run_Yr2__c,Run_Yr3__c,Run_Yr4__c,Run_Yr5__c,
    Run_Yr6__c,Run_Yr7__c,Run_Yr8__c,Run_Yr9__c,Run_Yr10__c,Service_Component_Name__c,Service_Component__c,Service_Group__c,
    Service_Name__c,Service_Ops__c,Service__c,Sub_Service_Group_Name__c,Sub_Service_Group__c,Sum_of_Other_Costs__c,
    Tech_Tools__c,Unused_Field2__c,Unused__c,Y1_Y2_Y3_Y4_Y5__c,Y1__c,Y2__c,Y3__c,Y4__c,Y5__c,Y6_Y7_Y8_Y9_Y10__c,Y6__c,Y7__c,Y8__c,
    Y9__c,Y10__c,Costing_Request__c FROM Other_Cost_Details__c where ID IN:ocdDetailsList AND cost_type__c LIKE:UtillContstant_Novasuite.STRT_WITH_PAYROLL]){
 
        Payroll__c payroll =new Payroll__c();
        payroll.name=ocd.name;
        payroll.Activity_Description__c=ocd.ActivityDescription__c;
        payroll.Bill_Code__c=ocd.BillCode__c;
        payroll.Career_Level__c=ocd.Career_Level__c;
        payroll.Career_Track__c=ocd.CareerTrack__c;
        payroll.Country_Master__c=ocd.Country__c;
        payroll.Economic_Profile__c=ocd.EconomicProfile__c;
        payroll.Other_Cost_Details__c=ocd.id;
        payroll.Load_Type__c=ocd.LoadType__c;
        //payroll.is_transient__c = true;
        payroll.M1__c=ocd.M1__c;
        payroll.M2__c=ocd.M2__c;
        payroll.M3__c=ocd.M3__c;
        payroll.M4__c=ocd.M4__c;
        payroll.M5__c=ocd.M5__c;
        payroll.M6__c=ocd.M6__c;
        payroll.M7__c=ocd.M7__c;
        payroll.M8__c=ocd.M8__c;
        payroll.M9__c=ocd.M9__c;
        payroll.M10__c=ocd.M10__c;
        payroll.M11__c=ocd.M11__c;
        payroll.M12__c=ocd.M12__c;
        payroll.M13__c=ocd.M13__c;
        payroll.M14__c=ocd.M14__c;
        payroll.M15__c=ocd.M15__c;
        payroll.M16__c=ocd.M16__c;
        payroll.M17__c=ocd.M17__c;
        payroll.M18__c=ocd.M18__c;
        payroll.M19__c=ocd.M19__c;
        payroll.M20__c=ocd.M20__c;
        payroll.M21__c=ocd.M21__c;
        payroll.M22__c=ocd.M22__c;
        payroll.M23__c=ocd.M23__c;
        payroll.M24__c=ocd.M24__c;
        payroll.M25__c=ocd.M25__c;
        payroll.M26__c=ocd.M26__c;
        payroll.M27__c=ocd.M27__c;
        payroll.M28__c=ocd.M28__c;
        payroll.M29__c=ocd.M29__c;
        payroll.M30__c=ocd.M30__c;
        payroll.M31__c=ocd.M31__c;
        payroll.M32__c=ocd.M32__c;
        payroll.M33__c=ocd.M33__c;
        payroll.M34__c=ocd.M34__c;
        payroll.M35__c=ocd.M35__c;
        payroll.M36__c=ocd.M36__c;
        payroll.M37__c=ocd.M37__c;
        payroll.M38__c=ocd.M38__c;
        payroll.M39__c=ocd.M39__c;
        payroll.M40__c=ocd.M40__c;
        payroll.M41__c=ocd.M21__c;
        payroll.M42__c=ocd.M42__c;
        payroll.M43__c=ocd.M43__c;
        payroll.M44__c=ocd.M44__c;
        payroll.M45__c=ocd.M45__c;
        payroll.M46__c=ocd.M46__c;
        payroll.M47__c=ocd.M47__c;
        payroll.M48__c=ocd.M48__c;
        payroll.M49__c=ocd.M49__c;
        payroll.M50__c=ocd.M50__c;
        payroll.M51__c=ocd.M51__c;
        payroll.M52__c=ocd.M52__c;
        payroll.M53__c=ocd.M53__c;
        payroll.M54__c=ocd.M54__c;
        payroll.M55__c=ocd.M55__c;
        payroll.M56__c=ocd.M56__c;
        payroll.M57__c=ocd.M57__c;
        payroll.M58__c=ocd.M58__c;
        payroll.M59__c=ocd.M59__c;
        payroll.M60__c=ocd.M60__c;
        payroll.M61__c=ocd.M61__c;
        payroll.M62__c=ocd.M62__c;
        payroll.M63__c=ocd.M63__c;
        payroll.M64__c=ocd.M64__c;
        payroll.M65__c=ocd.M65__c;
        payroll.M66__c=ocd.M66__c;
        payroll.M67__c=ocd.M67__c;
        payroll.M68__c=ocd.M68__c;
        payroll.M69__c=ocd.M69__c;
        payroll.M70__c=ocd.M70__c;
        payroll.M71__c=ocd.M71__c;
        payroll.M72__c=ocd.M72__c;
        payroll.M73__c=ocd.M73__c;
        payroll.M74__c=ocd.M74__c;
        payroll.M75__c=ocd.M75__c;
        payroll.M76__c=ocd.M76__c;
        payroll.M77__c=ocd.M77__c;
        payroll.M78__c=ocd.M78__c;
        payroll.M79__c=ocd.M79__c;
        payroll.M80__c=ocd.M80__c;
        payroll.M81__c=ocd.M81__c;
        payroll.M82__c=ocd.M82__c;
        payroll.M83__c=ocd.M83__c;
        payroll.M84__c=ocd.M84__c;
        payroll.M85__c=ocd.M85__c;
        payroll.M86__c=ocd.M86__c;
        payroll.M87__c=ocd.M87__c;
        payroll.M88__c=ocd.M88__c;
        payroll.M89__c=ocd.M89__c;
        payroll.M90__c=ocd.M90__c;
        payroll.M91__c=ocd.M91__c;
        payroll.M92__c=ocd.M92__c;
        payroll.M93__c=ocd.M93__c;
        payroll.M94__c=ocd.M94__c;
        payroll.M95__c=ocd.M95__c;
        payroll.M96__c=ocd.M96__c;
        payroll.M97__c=ocd.M97__c;
        payroll.M98__c=ocd.M98__c;
        payroll.M99__c=ocd.M99__c;
        payroll.M100__c=ocd.M100__c;
        payroll.M101__c=ocd.M101__c;
        payroll.M102__c=ocd.M102__c;
        payroll.M103__c=ocd.M103__c;
        payroll.M104__c=ocd.M104__c;
        payroll.M105__c=ocd.M105__c;
        payroll.M106__c=ocd.M106__c;
        payroll.M107__c=ocd.M107__c;
        payroll.M108__c=ocd.M108__c;
        payroll.M109__c=ocd.M109__c;
        payroll.M110__c=ocd.M110__c;
        payroll.M111__c=ocd.M111__c;
        payroll.M112__c=ocd.M112__c;
        payroll.M113__c=ocd.M113__c;
        payroll.M114__c=ocd.M114__c;
        payroll.M115__c=ocd.M115__c;
        payroll.M116__c=ocd.M116__c;
        payroll.M117__c=ocd.M117__c;
        payroll.M118__c=ocd.M118__c;
        payroll.M119__c=ocd.M119__c;
        payroll.M120__c=ocd.M120__c;
        payroll.Mob_Payroll_Ops__c=ocd.Mob_Totals__c;
        payroll.Opportunity__c=ocd.Opportunity__c;
        payroll.Phase__c=ocd.Phases__c;
        payroll.Rate_Type__c=ocd.RateType__c;
        payroll.Resource_Group__c=ocd.ResourceGroup__c;
        //payroll.Role__c=ocd.Role_Master__c;
        payroll.Service__c=ocd.Service__c;
        payroll.Service_Component__c=ocd.Service_Component__c;
        payroll.Sub_Service_Group__c=ocd.Sub_Service_Group__c;
        payroll.Y1_Ops__c=ocd.Run_Yr1__c;
        payroll.Y2_Ops__c=ocd.Run_Yr2__c;
        payroll.Y3_Ops__c=ocd.Run_Yr3__c;
        payroll.Y4_Ops__c=ocd.Run_Yr4__c;
        payroll.Y5_Ops__c=ocd.Run_Yr5__c;
        payroll.Y6_Ops__c=ocd.Run_Yr6__c;
        payroll.Y7_Ops__c=ocd.Run_Yr7__c;
        payroll.Y8_Ops__c=ocd.Run_Yr8__c;
        payroll.Y9_Ops__c=ocd.Run_Yr9__c;
        payroll.Y10_Ops__c=ocd.Run_Yr10__c;
       if(payroll.Y1_Ops__c >0){
            payroll.total_dev__c = payroll.Mob_Payroll_Ops__c+payroll.Y1_Ops__c;
        }
        else{
            payroll.total_dev__c = payroll.Mob_Payroll_Ops__c+payroll.M1__c+payroll.M2__c+payroll.M3__c+payroll.M4__c+payroll.M5__c+
            payroll.M6__c+payroll.M7__c+payroll.M8__c+payroll.M9__c+payroll.M10__c+payroll.M11__c+payroll.M12__c+payroll.M13__c+
            payroll.M14__c+payroll.M15__c+payroll.M16__c+payroll.M17__c+payroll.M18__c+payroll.M19__c+payroll.M20__c+payroll.M21__c+
            payroll.M22__c+payroll.M23__c+payroll.M24__c+payroll.M25__c+payroll.M26__c+payroll.M27__c+payroll.M28__c+payroll.M29__c+
            payroll.M30__c+payroll.M31__c+payroll.M32__c+payroll.M33__c+payroll.M34__c+payroll.M35__c+payroll.M36__c+payroll.M37__c+
            payroll.M38__c+payroll.M39__c+payroll.M40__c+payroll.M41__c+payroll.M42__c+payroll.M43__c+payroll.M44__c+payroll.M45__c+
            payroll.M46__c+payroll.M47__c+payroll.M48__c+payroll.M49__c+payroll.M50__c+payroll.M51__c+payroll.M52__c+payroll.M53__c+
            payroll.M54__c+payroll.M55__c+payroll.M56__c+payroll.M57__c+payroll.M58__c+payroll.M59__c+payroll.M60__c+payroll.M61__c+
            payroll.M62__c+payroll.M63__c+payroll.M64__c+payroll.M65__c+payroll.M66__c+payroll.M67__c+payroll.M68__c+payroll.M69__c+
            payroll.M70__c+payroll.M71__c+payroll.M72__c+payroll.M73__c+payroll.M74__c+payroll.M75__c+payroll.M76__c+payroll.M77__c+
            payroll.M78__c+payroll.M79__c+payroll.M80__c+payroll.M81__c+payroll.M82__c+payroll.M83__c+payroll.M84__c+payroll.M85__c+
            payroll.M86__c+payroll.M87__c+payroll.M88__c+payroll.M89__c+payroll.M90__c+payroll.M91__c+payroll.M92__c+payroll.M93__c+
            payroll.M94__c+payroll.M95__c+payroll.M96__c+payroll.M97__c+payroll.M98__c+payroll.M99__c+payroll.M100__c+payroll.M101__c+
            payroll.M102__c+payroll.M103__c+payroll.M104__c+payroll.M105__c+payroll.M106__c+payroll.M107__c+payroll.M108__c+
            payroll.M109__c+payroll.M110__c+payroll.M111__c+payroll.M112__c+payroll.M113__c+payroll.M114__c+payroll.M115__c+
            payroll.M116__c+payroll.M117__c+payroll.M118__c+payroll.M119__c+payroll.M120__c;
        }
        payroll.Service_Group__c=ocd.Service_Group__c;
        payroll.Costing_Request__c = ocd.costing_request__c;
        payrollToInsert.add(payroll);
     }
    //insert payroll
    try{
        if(!payrollToInsert.isEmpty()){
            database.insert(payrollToInsert,true);
        }
    }
    catch(Exception e){
        ExceptionLog__c exlog =new ExceptionLog__c();
            exlog.ExceptionDescription__c=e.getMessage().substring(0,100);
            exlog.ExceptionDetails__c=String.valueof(e);
            exlog.ExceptionLogTimestamp__c=system.now();
            exlog.ExceptionType__c=e.getTypeName();
            exlog.Application__c=UtilConstants.SWB;
            exlog.WSCallingApplication__c=UtilConstants.BPOSE;
            exlog.MethodName__c=UtilConstants.populatePayrollData;
            exlog.ClassName__c=UtilConstants.OtherCostTriggerOperations;
            exlog.ApexTrigger__c=UtilConstants.OtherCostTrigger;
            exlog.ContextUser__c=userinfo.getuserid();
            exceptions.add(exlog);
    }
    }
    
       /*************************
       @method Name: populateDeliveryLocationBPOSE
       @parameters : list<O> othercost
       @output :populate Delivery Location BPOSE field after fte insert of fte records
       @returntype : void
       @Description: populate Delivery Location BPOSE field at Opportunity Delivery Location
       *****************************/
       public static void populateDeliveryLocationBPOSE(List<Other_Cost_Details__c> othercostlist){
           String deliverylocationbbose=UtillContstant_Novasuite.NULL_VALUE;
           Map<ID,String> deliveryLocationBpose = new Map<Id,String>();
           Set<id> uniqueDeliveryLocation = new set<id>();
           Set<id> ccdRecords =new set<id>();
           map<String,String> serviceNdeliverylocationMap= new map<String,String>();
            
            for(Other_Cost_Details__c ccd:othercostlist){
              ccdRecords.add(ccd.id);
             if(ccd.Opportunity_Delivery_Location__c!=null){
               uniqueDeliveryLocation.add(ccd.Opportunity_Delivery_Location__c);
             }
           }
           
           List<Other_Cost_Details__c> ccdRecordList =[Select id,Opportunity_Delivery_Location__r.Delivery_Location__r.name,Opportunity_Delivery_Location__c,
                               service__c,Delivery_Location_Dev__c,Load_Type_Dev__c from Other_Cost_Details__c where id in:ccdRecords
                               and Opportunity_Delivery_Location__c!=null];
                               
  
             Set<String> deliverylocationvalues =new set<String>();                   
           for(Other_Cost_Details__c fte:ccdRecordList){
             serviceNdeliverylocationMap.put(fte.service__c+UtillContstant_Novasuite.NULL_VALUE+fte.Opportunity_Delivery_Location__c+UtillContstant_Novasuite.NULL_VALUE+fte.id,fte.Delivery_Location_Dev__c);
           }                    
            List<Opportunity_Delivery_Location__c> opportunityDeliveryLocationRecords=[Select id,Delivery_Location__r.name,Delivery_Location__c,Delivery_Location_BPOSE__c,
                                                    (Select id,Service__c,Opportunity_Delivery_Location__c,Delivery_Location_Dev__c from Other_Cost_Details__r where id in:ccdRecords)
                                                    from Opportunity_Delivery_Location__c  where id in:uniqueDeliveryLocation];  
              
              List<Opportunity_Delivery_Location__c> opportunityDeliveryLocationRecordstoUpdate=new List<Opportunity_Delivery_Location__c>();
              for(Opportunity_Delivery_Location__c oppdelloc:opportunityDeliveryLocationRecords){
                deliveryLocationBpose.put(oppdelloc.id,oppdelloc.Delivery_Location_BPOSE__c);
                deliverylocationbbose=oppdelloc.Delivery_Location_BPOSE__c;
                for(Other_Cost_Details__c fteRec:oppdelloc.Other_Cost_Details__r){
                  system.debug('In for loop'+oppdelloc.Other_Cost_Details__r.size());
                  system.debug('------ service map---'+serviceNdeliverylocationMap.get(fteRec.service__c+UtillContstant_Novasuite.NULL_VALUE+fteRec.Opportunity_Delivery_Location__c+UtillContstant_Novasuite.NULL_VALUE+fteRec.id));
                  if(serviceNdeliverylocationMap.get(fteRec.service__c+UtillContstant_Novasuite.NULL_VALUE+fteRec.Opportunity_Delivery_Location__c+UtillContstant_Novasuite.NULL_VALUE+fteRec.id)!=null){
                    //if(!deliverylocationbbose.containsignorecase((serviceNdeliverylocationMap.get(fteRec.service__c+UtillContstant_Novasuite.NULL_VALUE+fteRec.Opportunity_Delivery_Location__c+UtillContstant_Novasuite.NULL_VALUE+fteRec.id)))){
                        //oppdelloc.Delivery_Location_BPOSE__c+=fteRec.Delivery_Location_Dev__c+';';
                        system.debug('oppdelloc.Delivery_Location_BPOSE__c--------->'+fteRec.Delivery_Location_Dev__c);
                        deliverylocationvalues.add(fteRec.Delivery_Location_Dev__c);
                    //}
                  }
                  } for(String s:deliverylocationvalues){
                    if(oppdelloc.Delivery_Location_BPOSE__c!= null && !oppdelloc.Delivery_Location_BPOSE__c.containsIgnoreCase(s)){
                    oppdelloc.Delivery_Location_BPOSE__c+=s+UtillContstant_Novasuite.SEMI_COLON;   
                        }
                    }
                if(oppdelloc.Delivery_Location_BPOSE__c != null){
                    oppdelloc.Delivery_Location_BPOSE__c=oppdelloc.Delivery_Location_BPOSE__c.remove(UtillContstant_Novasuite.NLL);
                    oppdelloc.Delivery_Location_BPOSE__c=oppdelloc.Delivery_Location_BPOSE__c.remove(UtillContstant_Novasuite.ZERO_INT);
                    oppdelloc.Delivery_Location_BPOSE__c=oppdelloc.Delivery_Location_BPOSE__c.removeEnd(UtillContstant_Novasuite.SEMI_COLON);
                }
                system.debug('oppdelloc.at BPOSE-------------------->'+oppdelloc.Delivery_Location_BPOSE__c);
                system.debug('oppdelloc.at BPOSE-------------------->'+oppdelloc.id);
                opportunityDeliveryLocationRecordstoUpdate.add(oppdelloc);
                deliverylocationvalues.clear();
                //opportunityDeliveryLocationRecordstoUpdate.add(oppdelloc);
              }   
             system.debug('Updated  listt after for--------->'+opportunityDeliveryLocationRecordstoUpdate);
           
           if(!opportunityDeliveryLocationRecordstoUpdate.isEmpty()){
               try{
                    SWBBPOSEIntegrationConstants.rundeliverylocationtrigger = false;
                    SWBBPOSEIntegrationConstants.runservTrigger = false;
                    database.update(opportunityDeliveryLocationRecordstoUpdate,false);
                    system.debug('Updated--------->'+opportunityDeliveryLocationRecordstoUpdate);
                  }
                  catch(Exception e){
                    system.debug('Exception--------->'+e);
                    ExceptionLog__c exlog =new ExceptionLog__c();
                  exlog.ExceptionDescription__c=e.getMessage().substring(0,100);
                  exlog.ExceptionDetails__c=String.valueof(e);
                  exlog.ExceptionLogTimestamp__c=system.now();
                  exlog.ExceptionType__c=e.getTypeName();
                  exlog.Application__c=UtilConstants.SWB;
                  exlog.WSCallingApplication__c=UtilConstants.BPOSE;
                  exlog.MethodName__c=UtillContstant_Novasuite.POPULATE_DELIVERY_LBPOSE;
                  exlog.ClassName__c=UtilConstants.OtherCostTriggerOperations;
                  exlog.ApexTrigger__c=UtilConstants.OtherCostTrigger;
                  exlog.ContextUser__c=userinfo.getuserid();
                  exceptions.add(exlog);
                  }
           }
         
         
       }
       
       /*****************************************************************************************************************
       @method Name: insertDeliveryLocationIO
       @parameters : List<Other_Cost_Details__c> ftedetails
       @output :insert delivery locations for IO Service Group
       @returntype : void
       @Description: populate Delivery Location BPOSE field at Opportunity Delivery Location
       ****************************************************************************************************************/
       public static void insertDeliveryLocationIO(List<Other_Cost_Details__c> ccdrecords,ID OpportunityId){
         
           map<string,id> updatedOpportunityDeliveryLocation=new map<string,id>();
           for(Opportunity_Delivery_Location__c oppdelIO :[select id,Delivery_Location__c,Delivery_Location__r.name,Offering_Service__c
                                                                           from Opportunity_Delivery_Location__c where 
                                                                           Offering_Service__r.Solutionscope__r.opportunity__c=:opportunityId
                                                                          limit 5000]){
                       updatedOpportunityDeliveryLocation.put(oppdelIO.Delivery_Location__r.name+oppdelIO.Offering_Service__c,oppdelIO.id);
                                                                            
            }
           for(Other_Cost_Details__c fte :ccdrecords){
                  if(fte.Opportunity_Delivery_Location__c ==null && fte.Country_Dev__c!=null){
                    //if(updatedOpportunityDeliveryLocation.containsIgnorecase(fte.Country_Dev__c) && updatedOpportunityDeliveryLocation.containsIgnorecase(fte.Service__c)){
                      fte.Opportunity_Delivery_Location__c=updatedOpportunityDeliveryLocation.get(fte.Country_Dev__c+UtillContstant_Novasuite.BLANK_IS+fte.Service__c);
                    //}
                  }
            }
           map<String,id>deliveryLocationMap=new Map<String,id>();
           List<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsert=new List<Opportunity_Delivery_Location__c>();
            Set<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsertSet= new Set<Opportunity_Delivery_Location__c>();
            map<string,string> missingdeliverylocationmap=new map<string,string>();
            map<string,string> missingservicemap=new map<string,string>();
            List<Other_Cost_Details__c> fteDataToUpdate=new List<Other_Cost_Details__c>();
            Opportunity_Delivery_Location__c oppDelLocation;
           for(Delivery_Location_Masters__c deliveryloc :masterqueries.querydeliverymasters()){           
                     deliveryLocationMap.put(deliveryloc.name,deliveryloc.id);
            }
            for(Other_Cost_Details__c fte :ccdrecords){
            System.debug('=========ccdrecord '  );
                if(fte.Opportunity_Delivery_Location__c ==null && fte.Country_Dev__c!=null){
                    System.debug('=========Opportunity_Delivery_Location__c '+fte.Opportunity_Delivery_Location__c );
                    missingdeliverylocationmap.put(fte.Country_Dev__c+fte.service__c,fte.Country_Dev__c+UtillContstant_Novasuite.BLANK_IS2);
                    missingservicemap.put(fte.Country_Dev__c+fte.service__c,fte.service__c);
                }
            }
            boolean isSuccess=false;
            if(missingdeliverylocationmap.keyset()!=null){
                System.debug('========missingdeliverylocationmap '+missingdeliverylocationmap.size());
                    
              for(String delloc:missingdeliverylocationmap.keySet()){
                oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=missingservicemap.get(delloc);
                    oppDelLocation.Delivery_Location__c=deliveryLocationMap.get(missingdeliverylocationmap.get(delloc));
                    oppDelLocation.active__c = true;
                    oppDeliveryLocationToInsert.add(oppDelLocation);
              }
              oppDeliveryLocationToInsertSet.addAll(oppDeliveryLocationToInsert);
              oppDeliveryLocationToInsert.clear();
              oppDeliveryLocationToInsert.addall(oppDeliveryLocationToInsertSet);
              try{
               System.debug('========oppDeliveryLocationToInsert'+oppDeliveryLocationToInsert.size());
                 insert oppDeliveryLocationToInsert;
                 isSuccess=true;
              }
              catch(Exception e){
                isSuccess=false;
              }
            }
            updatedOpportunityDeliveryLocation.clear();
            if(isSuccess){
              for(Opportunity_Delivery_Location__c oppdelIO :[select id,Delivery_Location__c,Delivery_Location__r.name,Offering_Service__c
                                                                           from Opportunity_Delivery_Location__c where 
                                                                           Offering_Service__r.Solutionscope__r.opportunity__c=:opportunityId
                                                                          limit 5000]){
                       updatedOpportunityDeliveryLocation.put(oppdelIO.Delivery_Location__r.name+oppdelIO.Offering_Service__c,oppdelIO.id);
                                                                            
                }
                 
                for(Other_Cost_Details__c fte :ccdrecords){
                  if(fte.Opportunity_Delivery_Location__c ==null && fte.Country_Dev__c!=null){
                    //if(updatedOpportunityDeliveryLocation.containsIgnorecase(fte.Country_Dev__c) && updatedOpportunityDeliveryLocation.containsIgnorecase(fte.Service__c)){
                      fte.Opportunity_Delivery_Location__c=updatedOpportunityDeliveryLocation.get(fte.Country_Dev__c+UtillContstant_Novasuite.BLANK_IS+fte.Service__c);
                    //}
                  }
                }
                
            }
            
       }
}