trigger preventDuplicateLocationFacilities on Deal_Location_Facility__c (before Insert, before Update) {
    List<Deal_Location_Facility__c> opt1=System.Trigger.new;
    List<Deal_Location_Facility__c> opt2=System.Trigger.new;
    Integer i=0, j=0;
    if(Trigger.IsUpdate)
    {
     for(;i<opt1.size();i++)
     {
        for(;j<opt2.size();j++)
        {
            if(i!=j)
            {
              if(opt1[i].Facility_Master__c == opt2[j].Facility_Master__c)
              {              
                opt1[i].Facility_Master__c.addError('Facility for this Location already exists!');
                                                   
              }
            }
        }
     }
   }
 else{ 
     for (Deal_Location_Facility__c oppOffer : System.Trigger.new) {
           for(Deal_Location_Facility__c oppNew : [Select Facility_Master__c,ID from Deal_Location_Facility__c where Deal_Home_Location__c =:oppOffer.Deal_Home_Location__c])
           {
              if(oppOffer.Facility_Master__c == oppNew.Facility_Master__c)
              {              
                oppOffer.Facility_Master__c.addError('Facility for this Location already exists!');                                                   
              }          
           } 
        }                                         
    }
}