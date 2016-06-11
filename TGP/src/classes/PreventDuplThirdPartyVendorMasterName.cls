// Created By: Manik Chaudhary
// Story: Story-276/Sol_127_a
// Updated by:Shridhar Patankar
public class PreventDuplThirdPartyVendorMasterName
{
//***************************************************************************************************************
    // Method Name: ThirdPartyvendorMasterCheckInsert
    // Description: Before Inserting Records,Checks whether Name  is already present with other Third Party Vendor Master Record or not
    
    
    public static void ThirdPartyVendorMasterNameCheckInsert()
    {
          List<Third_Party_Vendor_Master_Custom__c  > triggernew = (List<Third_Party_Vendor_Master_Custom__c>)Trigger.new;
          Map<Id,Third_Party_Vendor_Master_Custom__c > newMap = (Map<Id,Third_Party_Vendor_Master_Custom__c>)Trigger.NewMap;
          Map<Id,Third_Party_Vendor_Master_Custom__c  > oldMap = (Map<Id,Third_Party_Vendor_Master_Custom__c>)Trigger.OldMap;
          List<Third_Party_Vendor_Master_Custom__c  > Namecheck = new List<Third_Party_Vendor_Master_Custom__c>();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingThirdPartyVendorMastermap =  new Map<String,String>();
          // below flag is used to stop recursive call of method
          Recursive.ThirdPartyVendorNameFlag= true;
          Integer i=0;
          Integer j=0;
        
          
        if(trigger.isBefore && trigger.isInsert) 
        { 
               
                // Below section filterates duplicate ThirdpartyVendorMaster names in the list of ThirdPartyVendorMaster names coming in bulk mode from data loader
                for(i=0;i<triggernew.size();i++)
                {
                    Boolean intriggernew = false;
                    for(j=0;j<Namecheck.size();j++)
                    {    // Matching names of entries in the list coming in bulk mode                   
                        if((triggernew[i].Third_Party_Vendor_Name__c.toLowerCase()==Namecheck[j].Third_Party_Vendor_Name__c.toLowerCase()) && (triggernew[i].Offering_Master__c==Namecheck[j].Offering_Master__c) )                            
                        {
                            // Associating error with the duplicate 'Third Party Vendor Master name' record in the list 
                            triggernew[i].addError('Third Party Vendor Master Name already exists');
                            intriggernew = true;                                                        
                        }                       
                        
                    }
                   
                    if(!intriggernew)
                    {
                        // Making List of names and Set of names to check Whether Third Party Vendor Master Name already exists in Database or not.
                        Namecheck.add(triggernew[i]);
                        Namesets1.add(triggernew[i].Third_Party_Vendor_Name__c);
                        Namesets2.add(triggernew[i].Offering_Master__c);
                        
                    }  
                }
                          
                if(Namecheck != null && Namecheck.size()>0)
                {
                    List<Third_Party_Vendor_Master_Custom__c> ThirdPartyVendorMaster=[select id,Offering_Master__c, Third_Party_Vendor_Name__c from Third_Party_Vendor_Master_Custom__c where Third_Party_Vendor_Name__c=:Namesets1 and Offering_Master__c=:Namesets2 ];
                    if(ThirdPartyVendorMaster.size()>0)
                    {
                    for(Third_Party_Vendor_Master_Custom__c existingName: ThirdPartyVendorMaster)
                    {
                        //existingThirdPartyVendormap.put(existingName.Third_Party_Vendor_Name__c.toLowerCase(),existingName.Offering_Master__c);
                                        
                    for(Third_Party_Vendor_Master_Custom__c ThirdPartyVendorMasterRec : Namecheck) 
                    {                     
                       if(existingName.Offering_Master__c==ThirdPartyVendorMasterRec .Offering_Master__c && existingName.Third_Party_Vendor_Name__c.toLowerCase()==ThirdPartyVendorMasterRec .Third_Party_Vendor_Name__c.toLowerCase())//existingThirdPartyVendormap.containsKey(ThirdPartyVendorRec.Name.toLowerCase()))
                        {
                           //Associating error with duplicate 'ThirdPartyVendor name' records
                            ThirdPartyVendorMasterRec .addError('Third Party Vendor Name already exists');
                        } 
                    }    
                    }
                }
            }
        }   
    }
        
        
        //***************************************************************************************************************
    // Method Name: ThirdPartyVendorMasterNameCheckUpdate
    // Description: Before Updating Records,Checks whether Name  is already present with Other ThirdPartyVendorMaster Record or not
    // Created By: Manik Chaudhary
    // 
    
        public static void ThirdPartyVendorMasterNameCheckUpdate()
        {
          List<Third_Party_Vendor_Master_Custom__c > triggernew = (List<Third_Party_Vendor_Master_Custom__c >)Trigger.new;
          List<Offerings_Master__c> triggernewOff = [select id, name from Offerings_Master__c];
          List<Third_Party_Vendor_Master_Custom__c > tpvList=[select id, name,Third_Party_Vendor_Name__c, Offering_Master__c from Third_Party_Vendor_Master_Custom__c];
          Map<Id,Third_Party_Vendor_Master_Custom__c > newMap = (Map<Id,Third_Party_Vendor_Master_Custom__c >)Trigger.NewMap;
          Map<Id,Third_Party_Vendor_Master_Custom__c > oldMap = (Map<Id,Third_Party_Vendor_Master_Custom__c >)Trigger.OldMap;
          List<Third_Party_Vendor_Master_Custom__c > Namecheck = new List<Third_Party_Vendor_Master_Custom__c >();
          Set<String> Namesets1 = new Set<String>();
          Set<String> Namesets2 = new Set<String>();
          Map<String,String> existingThirdPartyVendorMastermap=  new Map<String,String>();
         // below flag is used to stop recursive call of method 
          Recursive.ThirdPartyVendorNameFlag = true;
        
          
            if(trigger.isBefore && trigger.isUpdate) 
            { 
                //Check For Duplicate Offerings with third party name               
                // Below section filterates duplicate ThirdPartyVendor names in the list of ThirdPartyVendor names coming in bulk mode from data loader
                // Making list ThirdPartyVendorName1 with trigger.new enteries
                for(Third_Party_Vendor_Master_Custom__c ThirdPartyVendorMasterName1 : (List<Third_Party_Vendor_Master_Custom__c >)trigger.new)
                {
                    //&& ((ThirdPartyVendorMasterName1.Third_Party_Vendor_Name__c!= oldMap.get(ThirdPartyVendorMasterName1.id).Third_Party_Vendor_Name__c)))
                    if(trigger.isUpdate)
                    {   // variable used to track filtered records in the list
                        Boolean intriggernew = false;
                        // Making list ThirdPartyVendorName2 with trigger.new enteries
                        for(Third_Party_Vendor_Master_Custom__c ThirdPartyVendorMasterName2: tpvList)
                        {  
                         
                          // Comparing names in two lists ThirdPartyVendorName1 and ThirdPartyVendorName2 to filter duplicate names from the list
                          //ThirdPartyVendorMasterName1.id ==ThirdPartyVendorMasterName2.id &&
                            if( ThirdPartyVendorMasterName1.Third_Party_Vendor_Name__c.toLowerCase() == ThirdPartyVendorMasterName2.Third_Party_Vendor_Name__c.toLowerCase() && ThirdPartyVendorMasterName1.Offering_Master__c ==ThirdPartyVendorMasterName2.Offering_Master__c) 
                              {
                                intriggernew = true;
                                // Adding error to the duplicate record
                                ThirdPartyVendorMasterName1 .addError('Third Party Vendor Name for this Offering already exists!');
                              }
                        }
                        if(!intriggernew)
                        {
                        // Making List of names and Set of names to check Whether ThirdPartyVendor Name already exists in Database or not.
                            Namecheck.add(ThirdPartyVendorMasterName1 );
                            Namesets1.add(ThirdPartyVendorMasterName1 .Third_Party_Vendor_Name__c);
                            
                            Namesets2.add(ThirdPartyVendorMasterName1 .Offering_Master__c);
                        }
                    }
                }
            }                
                
            if(Namecheck != null && Namecheck.size()>0)
            {
                List<Third_Party_Vendor_Master_Custom__c > ThirdPartyVendorMaster=[select id,Offering_Master__c, Third_Party_Vendor_Name__c from Third_Party_Vendor_Master_Custom__c where Third_Party_Vendor_Name__c=:Namesets1 and Offering_Master__c=:Namesets2];
                if(ThirdPartyVendorMaster.size()>0)
                {
                    for(Third_Party_Vendor_Master_Custom__c existingName: ThirdPartyVendorMaster)
                    {
                        existingThirdPartyVendorMastermap.put(existingName.Third_Party_Vendor_Name__c.toLowerCase(),existingName.Offering_Master__c);
                        for(Third_Party_Vendor_Master_Custom__c ThirdpartyVendorMasterRec : Namecheck) 
                        {                     
                           //if(existingName.Offering_Master__c==ThirdpartyVendorMasterRec .Offering_Master__c && existingName.Third_Party_Vendor_Name__c.toLowerCase()==ThirdpartyVendorMasterRec .Third_Party_Vendor_Name__c.toLowerCase())
                           
                            if( existingThirdPartyVendorMastermap != null && existingThirdPartyVendorMastermap.size()>0 && existingThirdPartyVendorMastermap.containsKey(ThirdpartyVendorMasterRec.Name.toLowerCase()))                
                            {
                               //Associating error with duplicate 'ThirdPartyVendor name' records
                                ThirdpartyVendorMasterRec .addError('Third Party Vendor Name already exists');
                            } 
                        }    
                    }               
                }
            }
        }   
    }