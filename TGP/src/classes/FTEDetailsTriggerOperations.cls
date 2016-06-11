/*
@Author : Apoorva Sharma
@name : FTEDetailsTriggerOperations
@CreateDate : 6/23/2015
@Description : This class handelles all the operations on fte detail object
*/
public with sharing class FTEDetailsTriggerOperations {
    
    public static List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
    /*
        @methodname : populatePayrollData
        @methodDescription : This function is used to populate payroll object after record insertion in FTE Details
    */
    
    
   /******************************
    Method Name:insertDeliveryLocation
    Description:to insert delivery location
    Parameters: List<FTE_Details__c>, Id
    Return Value:Void
    ******************************/
   public static void insertDeliveryLocation(List<FTE_Details__c> fteDetailsList,Id opportunityId){
            List<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsert=new List<Opportunity_Delivery_Location__c>();
            Set<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsertSet= new Set<Opportunity_Delivery_Location__c>();
            List<FTE_Details__c> fteDataToUpdate=new List<FTE_Details__c>();
            Map<String,String>SolutionComponent=new Map<String,String>();
            Set<id>fteRecords=new set<id>();
            for(FTE_Details__c fte:fteDetailsList){
                system.debug('Service id....------>'+fte.Service__c);
                fteRecords.add(fte.Service__c);
            }
                system.debug('fteRecords....------>'+fteRecords.size());
            for(Service__c fterec:[Select id,Solutionscope__r.Solution_Component__c from Service__c where id in:fteRecords]){
                SolutionComponent.put(fterec.id+fterec.Solutionscope__r.Solution_Component__c,fterec.Solutionscope__r.Solution_Component__c);
                system.debug('Solution Component-------------------->'+fterec.id+fterec.Solutionscope__r.Solution_Component__c);
            }
            for(FTE_Details__c i:fteDetailsList){
                system.debug('Solution Component-+8888------------------->'+SolutionComponent.get(i.Service__c+'Delivery'));
            }
            boolean isSucsess=false;
            map<String,id> updatedCountryMaster=new map<String,id>();
            map<String,id> deliveryLocationMap=new map<String,id>();
            map<String,String> missingDeliveryLocation=new map<String,string>();
            map<String,id> servicesmap=new map<String,id>();
            map<String,id>Countrymap=new map<String,id>();
            Map<Id,String>countryRegion=new map<id,String>();
             for(Country_Master__c country:masterqueries.querycountrymasters()){
                  countryRegion.put(country.id,country.Geo_Region__r.name);
              }
            for(Delivery_Location_Masters__c deliveryloc :masterqueries.querydeliverymasters()){
            String dellocNService1;
            if(deliveryloc.name.contains(SWBBPOSEIntegrationConstants.hyphen)){
                        List<String> temp=deliveryloc.name.split(SWBBPOSEIntegrationConstants.hyphen);
                        dellocNService1=temp[1].trim();
                        system.debug('Delivery Location ----------->'+dellocNService1);
                    }
                    else{   
                        dellocNService1=deliveryloc.name;
                    }                   
                     deliveryLocationMap.put(dellocNService1,deliveryloc.id);
              }
            for(FTE_Details__c fte :fteDetailsList){
                if(fte.Opportunity_Delivery_Location__c ==null){
                String dellocNService;               
                      dellocNService=fte.Delivery_Location_Dev__c+fte.Service__c;     
                missingDeliveryLocation.put(dellocNService,fte.Delivery_Location_Dev__c);
                servicesmap.put(dellocNService,fte.Service__c);
                Countrymap.put(dellocNService,fte.Country__c);
                }
            }
            
            //system.debug('delloc!!!!!!!!!!!!!!1234'+delloc);
            if(missingDeliveryLocation.keyset()!=null){
                for(String delloc:missingDeliveryLocation.keySet()){
                    system.debug('delloc!!!!!!!!!!!!!!1234'+delloc+'deliveryLocationMap.get(missingDeliveryLocation.get(delloc))'+deliveryLocationMap.get(missingDeliveryLocation.get(delloc)));
                    system.debug('service!!!!!!!!!!!!!!1234'+servicesmap.get(delloc));
                    if((deliveryLocationMap.get(missingDeliveryLocation.get(delloc)))!=null && (servicesmap.get(delloc)!=null)&& (Countrymap.get(delloc)!=null)){
                    Opportunity_Delivery_Location__c oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=servicesmap.get(delloc);
                    OppDelLocation.Country__c=Countrymap.get(delloc);
                    oppDelLocation.Delivery_Location__c=deliveryLocationMap.get(missingDeliveryLocation.get(delloc));
                    oppDelLocation.active__c = true;
                        
                          oppDeliveryLocationToInsert.add(oppDelLocation);
                        
                    }
                }   
                oppDeliveryLocationToInsertSet.addall(oppDeliveryLocationToInsert);
                oppDeliveryLocationToInsert.clear();
                oppDeliveryLocationToInsert.addAll(oppDeliveryLocationToInsertSet);
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
        
        //updating fte and ccd records
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
              system.debug('updatedCountryMaster'+updatedCountryMaster);
              for(String deloc:updatedCountryMaster.keyset()){
              system.debug('updatedCountryMaster'+deloc+' id valueeee'+updatedCountryMaster.get(deloc));
              }
              //Map to polulate geo-reion value for country
              List<FTE_Details__c> FteWithoutdeliveryloc =new list<FTE_Details__c>(); 
              boolean deliverylocationfound=true; 
              List<Opportunity_Delivery_Location__c> nondcnlocationtoinsert= new list<Opportunity_Delivery_Location__c>();
          if(updatedCountryMaster!=null){ 
            //insert fte 
            for(FTE_Details__c fte:fteDetailsList){
            system.debug('fte.Delivery_Location_Dev__c+fte.Service__c'+fte.Delivery_Location_Dev__c+fte.Service__c+' updatedCountryMaster.get(fte.Delivery_Location_Dev__c+fte.Service__c)'+updatedCountryMaster.get(fte.Delivery_Location_Dev__c+fte.Service__c));
                if(updatedCountryMaster.get(fte.Delivery_Location_Dev__c+fte.Service__c) != null){
                           fte.Opportunity_Delivery_Location__c = updatedCountryMaster.get(fte.Delivery_Location_Dev__c+fte.Service__c);
                            system.debug('in insertDeliveryLocation'+fte.Opportunity_Delivery_Location__c);
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                      if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                         && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                             ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!='0'))){
                      fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.LatamClient+fte.Service__c);
                      }
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                      if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                         && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                             ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                      fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c);
                      }
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                      if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                         && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                             ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                     	fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.EMEAClient+fte.Service__c);
                     }
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                       if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                          && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                              ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                       fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.emeanondcnlocation+fte.Service__c);
                       }
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                     if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                        && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                            ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                     fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACCLIENT+fte.Service__c);
                     }
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                      if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                         && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                             ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                      fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c);
                      }
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                    System.debug('North America 1---'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c));
                    if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                       && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                           ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                    	fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c);
                    }
                  }
                  else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                  System.debug('North America 2---------------------------'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c));
                    if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                       && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                           ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                      fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NAlondcnlocation+fte.Service__c);
                      }
                  }
                  if(fte.Opportunity_Delivery_Location__c==null){
                        deliverylocationfound=false;
                        system.debug('Fte Load type----------'+fte.Load_Type_Dev__c);
                        String dellocNService;  
                        if(fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){ 
                          if(!countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && !countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){        
                            dellocNService=countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.nonDCNLocation+fte.Service__c;     
                              missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.nonDCNLocation);
                          }
                          else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA)){
                            dellocNService=SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c;     
                            missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.latamnondcnlocation);
                          }    
                            else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){
                                dellocNService=SWBBPOSEIntegrationConstants.NAlondcnlocation+fte.Service__c;     
                            missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.NAlondcnlocation);
                            }
                        }
                        else if(fte.Load_Type_Dev__c!=null && (fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                          if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC)){  
                                 dellocNService=countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.clientLocation+fte.Service__c;
                                missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.clientLocation);
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
                      //missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.nonDCNLocation);
                    servicesmap.put(dellocNService,fte.Service__c);
                    Countrymap.put(dellocNService,fte.Country__c);
                  }   
             }
             isSucsess=false;
             if(missingDeliveryLocation.keyset()!=null){
                for(String delloc:missingDeliveryLocation.keySet()){
                    system.debug('Non DCN/Client  Delivery Location--->'+delloc+'deliveryLocationMap.get(missingDeliveryLocation.get(delloc))'+deliveryLocationMap.get(missingDeliveryLocation.get(delloc)));
                    system.debug('service!!!!!!!!!!!!!!1234'+servicesmap.get(delloc));
                    if((deliveryLocationMap.get(missingDeliveryLocation.get(delloc)))!=null && (servicesmap.get(delloc)!=null) && (Countrymap.get(delloc)!=null)){
                    Opportunity_Delivery_Location__c oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=servicesmap.get(delloc);
                    oppDelLocation.Delivery_Location__c=deliveryLocationMap.get(missingDeliveryLocation.get(delloc));
                    OppDelLocation.Country__c=Countrymap.get(delloc);
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
                
                  for(FTE_Details__c fte:fteDetailsList){

                    if(fte.Opportunity_Delivery_Location__c==null){
                        system.debug('Issue yahan hai-------->'+fte.Load_Type_Dev__c+'-----'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c));
                    if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                          if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                             && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                 ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                          fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.LatamClient+fte.Service__c);
                          }
                      }
                      else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                          if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                             && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                 ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                          fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c);
                          }
                      }
                      else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                         if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                            && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                         fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.EMEAClient+fte.Service__c);
                         }
                      }
                      else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                           if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                              && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                  ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                           fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.emeanondcnlocation+fte.Service__c);
                           }
                      }
                      else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                         if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                            && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                         fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACCLIENT+fte.Service__c);
                         }
                      }
                      else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                          system.debug('Issue yahan hai 2-------->'+fte.Load_Type_Dev__c+'-----'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c)+'------'+SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery));
                          if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                             && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                 ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                              system.debug('Issue yahan hai 3-------->'+fte.Load_Type_Dev__c+'-----'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c)+'-----------');
                          fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c);
                          }
                      }
                      else if(countryRegion.get(fte.country__c)!=null 
                              && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) 
                              && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                      System.debug('North America 3---------------------------'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c));
                         if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!='0'))){
                         fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c);
                         }
                      }
                      else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                      System.debug('North America 4---------------------------'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c));
                          if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                             && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                 ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
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
        }
  else{
    system.debug('In_ELSE Part');
    //for(Country_Master__c country:[select id,Geo_Region__r.name from Country_Master__c]){
         //         countryRegion.put(country.id,country.Geo_Region__r.name);
             // }
              List<FTE_Details__c> FteWithoutdeliveryloc =new list<FTE_Details__c>(); 
              boolean deliverylocationfound=true; 
              missingDeliveryLocation.clear();
              servicesmap.clear();
              Countrymap.clear();
              List<Opportunity_Delivery_Location__c> nondcnlocationtoinsert= new list<Opportunity_Delivery_Location__c>();
      for(FTE_Details__c fte:fteDetailsList){
        if(fte.Opportunity_Delivery_Location__c==null){
                        deliverylocationfound=false;
                        String dellocNService; 
                        if(fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){ 
                          if(!countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && !countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){        
                            dellocNService=countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.nonDCNLocation+fte.Service__c;     
                              missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.nonDCNLocation);
                          }
                          else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA)){
                            dellocNService=SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c;     
                            missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.latamnondcnlocation);
                          }
                        else if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA)){
                            dellocNService=SWBBPOSEIntegrationConstants.NAlondcnlocation+fte.Service__c;     
                            missingDeliveryLocation.put(dellocNService,SWBBPOSEIntegrationConstants.NAlondcnlocation);
                         }
                        }
                        else if(fte.Load_Type_Dev__c!=null && (fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                          if(countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC)){  
                            system.debug('APAC------------------------>'+fte.country__c);
                                 dellocNService=countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.clientLocation+fte.Service__c;
                                missingDeliveryLocation.put(dellocNService,countryRegion.get(fte.country__c)+SWBBPOSEIntegrationConstants.clientLocation);
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
                    Countrymap.put(dellocNService,fte.Country__c);
                  }
        
        }
        if(missingDeliveryLocation.keyset()!=null){
                for(String delloc:missingDeliveryLocation.keySet()){
                    system.debug('ELse Non DCN Delivery Location--->'+delloc+'deliveryLocationMap.get(missingDeliveryLocation.get(delloc))'+deliveryLocationMap.get(missingDeliveryLocation.get(delloc)));
                    system.debug('service!!!!!!!!!!!!!!1234'+servicesmap.get(delloc));
                    if((deliveryLocationMap.get(missingDeliveryLocation.get(delloc)))!=null && (servicesmap.get(delloc)!=null) && (Countrymap.get(delloc)!=null)){
                    Opportunity_Delivery_Location__c oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=servicesmap.get(delloc);
                    OppDelLocation.Country__c=Countrymap.get(delloc);
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
                  for(FTE_Details__c fte:fteDetailsList){
                    if(fte.Opportunity_Delivery_Location__c==null){
                        if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                          if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                             && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                 ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                          fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.LatamClient+fte.Service__c);
                          }
                        }
                        else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.LATINAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                            if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                               && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                   ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                            fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.latamnondcnlocation+fte.Service__c);
                            }
                        }
                        else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                           if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                              && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                  ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                           fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.EMEAClient+fte.Service__c);
                           }
                        }
                        else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.EMEA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                            if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                               && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                   ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                            
                             fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.emeanondcnlocation+fte.Service__c);
                            }
                        }
                        else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) 
                                && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                           if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                              && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                  ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                           fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACCLIENT+fte.Service__c);
                           }
                        }
                        else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.APAC) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                            if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                               && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
                           fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.APACnondcnlocation+fte.Service__c);
                            }
                        }
                        else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client)){
                        System.debug('North America 5---------------------------'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c));
                           if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!='0'))){
                           fte.Opportunity_Delivery_Location__c=updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c);
                           }
                        }
                        else if(countryRegion.get(fte.country__c)!=null && countryRegion.get(fte.country__c).equalsignorecase(SWBBPOSEIntegrationConstants.NORTHAMERICA) && fte.Load_Type_Dev__c!=null && !(fte.Load_Type_Dev__c.containsIgnoreCase(SWBBPOSEIntegrationConstants.client))){
                        System.debug('North America 6---------------------------'+updatedCountryMaster.get(SWBBPOSEIntegrationConstants.NACLIENT+fte.Service__c));
                            if(SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery)!= null 
                               && ((SolutionComponent.get(fte.Service__c+SWBBPOSEIntegrationConstants.delivery).equalsignorecase(SWBBPOSEIntegrationConstants.delivery))
                                   ||(fte.Delivery_Location_Dev__c!=null && fte.Delivery_Location_Dev__c!=UtillContstant_Novasuite.ZERO_INT))){
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
        
        
    }
      
   }
  /******************************
    Method Name:populatePayrollData
    Description:to populate payroll data
    Parameters: list<FTE_Details__c>
    Return Value:Void
    ******************************/
  public static void populatePayrollData(list<FTE_Details__c> fteDetailsList){
    
    List<Payroll__c> payrollToInsert=new List<Payroll__c>();
    for(FTE_Details__c fte:[SELECT Activity_Description__c,Bill_Code__c,Career_Level_Bill_Code_Role__c,Career_Level__c,
    Career_Track__c,Costing_Type__c,Country_Dev__c,Country__c,CreatedById,CreatedDate,
    Economic_Profile__c,FTEMobTotals__c,FTEYr1__c,FTEYr2__c,FTEYr3__c,FTEYr4__c,FTEYr5__c,FTEYr6__c,FTEYr7__c,FTEYr8__c,FTEYr9__c,
    FTEYr10__c,FTE_Grand_Total_Cost__c,FTE_Type__c,Id,Load_Type__c,Location_typeCode__c,Location_typeName__c,
    M1__c,M2__c,M3__c,M4__c,M5__c,M6__c,M7__c,M8__c,M9__c,M10__c,M11__c,M12__c,M13__c,M14__c,M15__c,M16__c,M17__c,M18__c,M19__c,M20__c,
    M21__c,M22__c,M23__c,M24__c,M25__c,M26__c,M27__c,M28__c,M29__c,M30__c,M31__c,M32__c,M33__c,M34__c,M35__c,M36__c,M37__c,M38__c,M39__c,
    M40__c,M41__c,M42__c,M43__c,M44__c,M45__c,M46__c,M47__c,M48__c,M49__c,M50__c,M51__c,M52__c,M53__c,M54__c,M55__c,M56__c,M57__c,M58__c,
    M59__c,M60__c,M61__c,M62__c,M63__c,M64__c,M65__c,M66__c,M67__c,M68__c,M69__c,M70__c,M71__c,M72__c,M73__c,M74__c,M75__c,M76__c,M77__c,
    M78__c,M79__c,M80__c,M81__c,M82__c,M83__c,M84__c,M85__c,M86__c,M87__c,M88__c,M89__c,M90__c,M91__c,M92__c,M93__c,M94__c,M95__c,M96__c,
    M97__c,M98__c,M99__c,M100__c,M101__c,M102__c,M103__c,M104__c,M105__c,M106__c,M107__c,M108__c,M109__c,M110__c,M111__c,M112__c,M113__c,
    M114__c,M115__c,M116__c,M117__c,M118__c,M119__c,M120__c,Mob_Category__c,Mob_Cost__c,Mob_Sub_Category__c,Mob_Totals__c,
    Name,Non_Zero_Y1_Months__c,Non_Zero_Y2_Months__c,Non_Zero_Y3_Months__c,Non_Zero_Y4_Months__c,Non_Zero_Y5_Months__c,
    Non_Zero_Y6_Months__c,Non_Zero_Y7_Months__c,Non_Zero_Y8_Months__c,Non_Zero_Y9_Months__c,Non_Zero_Y10_Months__c,
    Opportunity__c,Phase__c,Pyramid_Richness__c,RateType_Load_Type__c,Rate_Type__c,Resource_Group_Career_Track_Economic__c,
    Resource_Group__c,Role_Master__c,Run_Yr1__c,Run_Yr2__c,Run_Yr3__c,Run_Yr4__c,Run_Yr5__c,Run_Yr6__c,Run_Yr7__c,Run_Yr8__c,
    Run_Yr9__c,Run_Yr10__c,Service_Component_Name__c,Service_Component__c,Service_Group__c,Service_Name__c,Service_Ops__c,
    Service__c,Sub_Service_Group_Name__c,Sub_Service_Group__c,SystemModstamp,Total_SDO_FTE__c,
    Y1_Y2_Y3_Y4_Y5__c,Y1__c,Y2__c,Y3__c,Y4__c,Y5__c,Y6_Y7_Y8_Y9_Y10__c,Y6__c,Y7__c,Y8__c,Y9__c,Y10__c,costing_request__c
    FROM FTE_Details__c where ID IN:fteDetailsList LIMIT 5000]){
        Payroll__c payroll =new Payroll__c();
        payroll.name=fte.name;
        payroll.Activity_Description__c=fte.Activity_Description__c;
        payroll.Bill_Code__c=fte.Bill_Code__c;
        payroll.Career_Level__c=fte.Career_Level__c;
        payroll.Career_Track__c=fte.Career_Track__c;
        payroll.Country_Master__c=fte.Country__c;
        payroll.Economic_Profile__c=fte.Economic_Profile__c;
        payroll.FTE_Details__c=fte.id;
        payroll.Load_Type__c=fte.Load_Type__c;
        payroll.M1__c=fte.M1__c;
        payroll.M2__c=fte.M2__c;
        payroll.M3__c=fte.M3__c;
        payroll.M4__c=fte.M4__c;
        payroll.M5__c=fte.M5__c;
        payroll.M6__c=fte.M6__c;
        payroll.M7__c=fte.M7__c;
        payroll.M8__c=fte.M8__c;
        payroll.M9__c=fte.M9__c;
        payroll.M10__c=fte.M10__c;
        payroll.M11__c=fte.M11__c;
        payroll.M12__c=fte.M12__c;
        payroll.M13__c=fte.M13__c;
        payroll.M14__c=fte.M14__c;
        payroll.M15__c=fte.M15__c;
        payroll.M16__c=fte.M16__c;
        payroll.M17__c=fte.M17__c;
        payroll.M18__c=fte.M18__c;
        payroll.M19__c=fte.M19__c;
        payroll.M20__c=fte.M20__c;
        payroll.M21__c=fte.M21__c;
        payroll.M22__c=fte.M22__c;
        payroll.M23__c=fte.M23__c;
        payroll.M24__c=fte.M24__c;
        payroll.M25__c=fte.M25__c;
        payroll.M26__c=fte.M26__c;
        payroll.M27__c=fte.M27__c;
        payroll.M28__c=fte.M28__c;
        payroll.M29__c=fte.M29__c;
        payroll.M30__c=fte.M30__c;
        payroll.M31__c=fte.M31__c;
        payroll.M32__c=fte.M32__c;
        payroll.M33__c=fte.M33__c;
        payroll.M34__c=fte.M34__c;
        payroll.M35__c=fte.M35__c;
        payroll.M36__c=fte.M36__c;
        payroll.M37__c=fte.M37__c;
        payroll.M38__c=fte.M38__c;
        payroll.M39__c=fte.M39__c;
        payroll.M40__c=fte.M40__c;
        payroll.M41__c=fte.M21__c;
        payroll.M42__c=fte.M42__c;
        payroll.M43__c=fte.M43__c;
        payroll.M44__c=fte.M44__c;
        payroll.M45__c=fte.M45__c;
        payroll.M46__c=fte.M46__c;
        payroll.M47__c=fte.M47__c;
        payroll.M48__c=fte.M48__c;
        payroll.M49__c=fte.M49__c;
        payroll.M50__c=fte.M50__c;
        payroll.M51__c=fte.M51__c;
        payroll.M52__c=fte.M52__c;
        payroll.M53__c=fte.M53__c;
        payroll.M54__c=fte.M54__c;
        payroll.M55__c=fte.M55__c;
        payroll.M56__c=fte.M56__c;
        payroll.M57__c=fte.M57__c;
        payroll.M58__c=fte.M58__c;
        payroll.M59__c=fte.M59__c;
        payroll.M60__c=fte.M60__c;
        payroll.M61__c=fte.M61__c;
        payroll.M62__c=fte.M62__c;
        payroll.M63__c=fte.M63__c;
        payroll.M64__c=fte.M64__c;
        payroll.M65__c=fte.M65__c;
        payroll.M66__c=fte.M66__c;
        payroll.M67__c=fte.M67__c;
        payroll.M68__c=fte.M68__c;
        payroll.M69__c=fte.M69__c;
        payroll.M70__c=fte.M70__c;
        payroll.M71__c=fte.M71__c;
        //payroll.is_transient__c = true;
        payroll.M72__c=fte.M72__c;
        payroll.M73__c=fte.M73__c;
        payroll.M74__c=fte.M74__c;
        payroll.M75__c=fte.M75__c;
        payroll.M76__c=fte.M76__c;
        payroll.M77__c=fte.M77__c;
        payroll.M78__c=fte.M78__c;
        payroll.M79__c=fte.M79__c;
        payroll.M80__c=fte.M80__c;
        payroll.M81__c=fte.M81__c;
        payroll.M82__c=fte.M82__c;
        payroll.M83__c=fte.M83__c;
        payroll.M84__c=fte.M84__c;
        payroll.M85__c=fte.M85__c;
        payroll.M86__c=fte.M86__c;
        payroll.M87__c=fte.M87__c;
        payroll.M88__c=fte.M88__c;
        payroll.M89__c=fte.M89__c;
        payroll.M90__c=fte.M90__c;
        payroll.M91__c=fte.M91__c;
        payroll.M92__c=fte.M92__c;
        payroll.M93__c=fte.M93__c;
        payroll.M94__c=fte.M94__c;
        payroll.M95__c=fte.M95__c;
        payroll.M96__c=fte.M96__c;
        payroll.M97__c=fte.M97__c;
        payroll.M98__c=fte.M98__c;
        payroll.M99__c=fte.M99__c;
        payroll.M100__c=fte.M100__c;
        payroll.M101__c=fte.M101__c;
        payroll.M102__c=fte.M102__c;
        payroll.M103__c=fte.M103__c;
        payroll.M104__c=fte.M104__c;
        payroll.M105__c=fte.M105__c;
        payroll.M106__c=fte.M106__c;
        payroll.M107__c=fte.M107__c;
        payroll.M108__c=fte.M108__c;
        payroll.M109__c=fte.M109__c;
        payroll.M110__c=fte.M110__c;
        payroll.M111__c=fte.M111__c;
        payroll.M112__c=fte.M112__c;
        payroll.M113__c=fte.M113__c;
        payroll.M114__c=fte.M114__c;
        payroll.M115__c=fte.M115__c;
        payroll.M116__c=fte.M116__c;
        payroll.M117__c=fte.M117__c;
        payroll.M118__c=fte.M118__c;
        payroll.M119__c=fte.M119__c;
        payroll.M120__c=fte.M120__c;
        payroll.Mob_Payroll_Ops__c=fte.Mob_Totals__c;
        payroll.Opportunity__c=fte.Opportunity__c;
        payroll.Phase__c=fte.Phase__c;
        payroll.Rate_Type__c=fte.Rate_Type__c;
        payroll.Resource_Group__c=fte.Resource_Group__c;
        payroll.Role__c=fte.Role_Master__c;
        payroll.Service__c=fte.Service__c;
        payroll.Service_Component__c=fte.Service_Component__c;
        payroll.Sub_Service_Group__c=fte.Sub_Service_Group__c;
        payroll.Y1_Ops__c=fte.Run_Yr1__c;
        payroll.Y2_Ops__c=fte.Run_Yr2__c;
        payroll.Y3_Ops__c=fte.Run_Yr3__c;
        payroll.Y4_Ops__c=fte.Run_Yr4__c;
        payroll.Y5_Ops__c=fte.Run_Yr5__c;
        payroll.Y6_Ops__c=fte.Run_Yr6__c;
        payroll.Y7_Ops__c=fte.Run_Yr7__c;
        payroll.Y8_Ops__c=fte.Run_Yr8__c;
        payroll.Y9_Ops__c=fte.Run_Yr9__c;
        payroll.Y10_Ops__c=fte.Run_Yr10__c;
        payroll.Service_Group__c=fte.Service_Group__c;
        payroll.Costing_Request__c = fte.costing_request__c;
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
            exlog.ClassName__c=UtilConstants.FTEDetailsTriggerOperations;
            exlog.ApexTrigger__c=UtilConstants.FTEDetailsTrigger;
            exlog.ContextUser__c=userinfo.getuserid();
            exceptions.add(exlog);
        
    }
    
  }
  
   /*************************
       @method Name: populateDeliveryLocationBPOSE
       @parameters : list<FTE_Details__c> ftedetails
       @output :populate Delivery Location BPOSE field after fte insert of fte records
       @returntype : void
       @Description: populate Delivery Location BPOSE field at Opportunity Delivery Location
       *****************************/
       public static void populateDeliveryLocationBPOSE(SET<ID> fterecords){
           //String deliverylocationbbose='';
           Map<ID,String> deliveryLocationBpose = new Map<Id,String>();
           Set<id> uniqueDeliveryLocation = new set<id>();
           Set<String> deliverylocationvalues =new set<String>();
           map<String,String> serviceNdeliverylocationMap= new map<String,String>();
      
           
           List<FTE_Details__c> fteRecordList =[Select id,Opportunity_Delivery_Location__r.Delivery_Location__r.name,Opportunity_Delivery_Location__c,
                               service__c,Delivery_Location_Dev__c,Load_Type_Dev__c from FTE_Details__c where id in:fterecords
                               and Opportunity_Delivery_Location__c!=null LIMIT 5000];
                               
             for(FTE_Details__c fte:fteRecordList){
             
             if(fte.Opportunity_Delivery_Location__c!=null){
               uniqueDeliveryLocation.add(fte.Opportunity_Delivery_Location__c);
             }
           }
                                
           for(FTE_Details__c fte:fteRecordList){
             serviceNdeliverylocationMap.put(fte.service__c+''+fte.Opportunity_Delivery_Location__c+''+fte.id,fte.Delivery_Location_Dev__c);
           }                    
            List<Opportunity_Delivery_Location__c> opportunityDeliveryLocationRecords=[Select id,
                                                                                       Delivery_Location__r.name,Delivery_Location__c,
                                                                                       Delivery_Location_BPOSE__c,
                                                    (Select id,Service__c,country__c,Opportunity_Delivery_Location__c,
                                                     Delivery_Location_Dev__c from FTE_Details__r where id in:fterecords)
                                                    from Opportunity_Delivery_Location__c  where id in:uniqueDeliveryLocation LIMIT 5000];  
              
              List<Opportunity_Delivery_Location__c> opportunityDeliveryLocationRecordstoUpdate=new List<Opportunity_Delivery_Location__c>();
              for(Opportunity_Delivery_Location__c oppdelloc:opportunityDeliveryLocationRecords){
                //deliveryLocationBpose.put(oppdelloc.id,oppdelloc.Delivery_Location_BPOSE__c);
                //deliverylocationbbose=oppdelloc.Delivery_Location_BPOSE__c;
                oppdelloc.Delivery_Location_BPOSE__c=UtillContstant_Novasuite.NULL_VALUE;
                for(FTE_Details__c fteRec:oppdelloc.FTE_Details__r){
                  system.debug('In for loop'+oppdelloc.FTE_Details__r.size());
                  system.debug('------ service map---'+serviceNdeliverylocationMap.get(fteRec.service__c+''+fteRec.Opportunity_Delivery_Location__c+''+fteRec.id));
                  if(serviceNdeliverylocationMap.get(fteRec.service__c+''+fteRec.Opportunity_Delivery_Location__c+''+fteRec.id)!=null){
                    //if(!deliverylocationbbose.containsignorecase((serviceNdeliverylocationMap.get(fteRec.service__c+''+fteRec.Opportunity_Delivery_Location__c+''+fteRec.id)))){
                        //oppdelloc.Delivery_Location_BPOSE__c+=fteRec.Delivery_Location_Dev__c+';';
                        system.debug('oppdelloc.Delivery_Location_BPOSE__c--------->'+fteRec.Delivery_Location_Dev__c);
                        deliverylocationvalues.add(fteRec.Delivery_Location_Dev__c);
                        oppdelloc.country__c=fteRec.country__c;
                    //}
                  }    
                }
                
                for(String s:deliverylocationvalues){
                    oppdelloc.Delivery_Location_BPOSE__c+=s+UtillContstant_Novasuite.SEMI_COLON;        
                    }
                oppdelloc.Delivery_Location_BPOSE__c=oppdelloc.Delivery_Location_BPOSE__c.remove(UtillContstant_Novasuite.NLL);
                oppdelloc.Delivery_Location_BPOSE__c=oppdelloc.Delivery_Location_BPOSE__c.remove(UtillContstant_Novasuite.ZERO_INT);
                oppdelloc.Delivery_Location_BPOSE__c=oppdelloc.Delivery_Location_BPOSE__c.removeEnd(UtillContstant_Novasuite.SEMI_COLON);
                system.debug('oppdelloc.at BPOSE-------------------->'+oppdelloc.Delivery_Location_BPOSE__c);
                system.debug('oppdelloc.at BPOSE-------------------->'+oppdelloc.id);
                opportunityDeliveryLocationRecordstoUpdate.add(oppdelloc);
                deliverylocationvalues.clear();
              }   
             system.debug('Updated  listt after for--------->'+opportunityDeliveryLocationRecordstoUpdate);
           
           if(!opportunityDeliveryLocationRecordstoUpdate.isEmpty()){
               try{
               SWBBPOSEIntegrationConstants.rundeliverylocationtrigger = false;
               SWBBPOSEIntegrationConstants.runservTrigger = false;
                    database.update(opportunityDeliveryLocationRecordstoUpdate,true);
                    system.debug('Updated--------->'+opportunityDeliveryLocationRecordstoUpdate);
                    system.debug('Queried List------>'+[Select id,Delivery_Location__r.name,Delivery_Location__c,Delivery_Location_BPOSE__c
                                                     from Opportunity_Delivery_Location__c  where id in:uniqueDeliveryLocation]);
                  }
                  catch(Exception e){
                    //system.debug('Exception--------->'+e);
                    ExceptionLog__c exlog =new ExceptionLog__c();
                  exlog.ExceptionDescription__c=e.getMessage().substring(0,100);
                  exlog.ExceptionDetails__c=String.valueof(e);
                  exlog.ExceptionLogTimestamp__c=system.now();
                  exlog.ExceptionType__c=e.getTypeName();
                  exlog.Application__c=UtilConstants.SWB;
                  exlog.WSCallingApplication__c=UtilConstants.BPOSE;
                  exlog.MethodName__c=UtillContstant_Novasuite.POPULATE_DELIVERY;
                  exlog.ClassName__c=UtilConstants.FTEDetailsTriggerOperations;
                  exlog.ApexTrigger__c=UtilConstants.FTEDetailsTrigger;
                  exlog.ContextUser__c=userinfo.getuserid();
                  exceptions.add(exlog);
                  }
           }
         
         
       }
            /*****************************************************************************************************************
       @method Name: insertDeliveryLocationIO
       @parameters : List<FTE_Details__c> ftedetails
       @output :insert delivery locations for IO Service Group
       @returntype : void
       @Description: populate Delivery Location BPOSE field at Opportunity Delivery Location
       ****************************************************************************************************************/
       public static void insertDeliveryLocationIO(List<FTE_Details__c> fterecords,ID OpportunityId){
            map<String,id>deliveryLocationMap=new Map<String,id>();
            List<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsert=new List<Opportunity_Delivery_Location__c>();
            Set<Opportunity_Delivery_Location__c> oppDeliveryLocationToInsertSet= new Set<Opportunity_Delivery_Location__c>();
            map<string,string> missingdeliverylocationmap=new map<string,string>();
            map<string,string> missingservicemap=new map<string,string>();
            List<FTE_Details__c> fteDataToUpdate=new List<FTE_Details__c>();
            Opportunity_Delivery_Location__c oppDelLocation;
            for(Delivery_Location_Masters__c deliveryloc :masterqueries.querydeliverymasters()){           
                     deliveryLocationMap.put(deliveryloc.name,deliveryloc.id);
            }
            for(FTE_Details__c fte :fterecords){
                if(fte.Opportunity_Delivery_Location__c ==null && fte.Country_Dev__c!=null){
                        system.debug('Buildinggg missingggg mappppp'+fte.Country_Dev__c+'======='+fte.service__c);
                        missingdeliverylocationmap.put(fte.Country_Dev__c+fte.service__c,fte.Country_Dev__c+' - IS');
                        missingservicemap.put(fte.Country_Dev__c+fte.service__c,fte.service__c);
                }
            }
            boolean isSuccess=false;
            if(missingdeliverylocationmap.keyset()!=null){
                for(String delloc:missingdeliverylocationmap.keySet()){
                    oppDelLocation =new Opportunity_Delivery_Location__c();
                    oppDelLocation.Offering_Service__c=missingservicemap.get(delloc);
                    oppDelLocation.Delivery_Location__c=deliveryLocationMap.get(missingdeliverylocationmap.get(delloc));
                    system.debug('oppDelLocation.Delivery_Location__c------------------'+delloc+'----------------------------------IO-->'+missingdeliverylocationmap.get(delloc));
                    oppDelLocation.active__c = true;
                    oppDeliveryLocationToInsert.add(oppDelLocation);
                }
                oppDeliveryLocationToInsertSet.addAll(oppDeliveryLocationToInsert);
                oppDeliveryLocationToInsert.clear();
                oppDeliveryLocationToInsert.addall(oppDeliveryLocationToInsertSet);
                try{
                     insert oppDeliveryLocationToInsert;
                     isSuccess=true;
                }
                catch(Exception e){
                    isSuccess=false;
                }
            }
            map<string,id> updatedOpportunityDeliveryLocation=new map<string,id>();
            if(isSuccess){
                for(Opportunity_Delivery_Location__c oppdelIO :[select id,Delivery_Location__c,Delivery_Location__r.name,Offering_Service__c
                                                                                            from Opportunity_Delivery_Location__c where 
                                                                                            Offering_Service__r.Solutionscope__r.opportunity__c=:opportunityId
                                                                                            limit 5000]){
                       updatedOpportunityDeliveryLocation.put(oppdelIO.Delivery_Location__r.name+oppdelIO.Offering_Service__c,oppdelIO.id);
                                                                                                
                }
                 
                for(FTE_Details__c fte :fterecords){
                    if(fte.Opportunity_Delivery_Location__c ==null && fte.Country_Dev__c!=null){
                        //if(updatedOpportunityDeliveryLocation.containsIgnorecase(fte.Country_Dev__c) && updatedOpportunityDeliveryLocation.containsIgnorecase(fte.Service__c)){
                            fte.Opportunity_Delivery_Location__c=updatedOpportunityDeliveryLocation.get(fte.Country_Dev__c+' - IS'+fte.Service__c);
                        //}
                    }
                }
                
            }
            
       }

}