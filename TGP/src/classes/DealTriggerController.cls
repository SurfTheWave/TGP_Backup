//***************************************************************************************************************
// Name       :  DealTriggerController 
// Description:  Class To Control all trigger calls for DEAL records 
//
//             
//               
// Created By :  Malkeet Singh
// Date       : 08/03/2013
// **************************************************************************************************************

public class DealTriggerController {
    
    /*
     * Name : beforeInsert
     * Desc : Invokes all the methods in sequence before inserting Deal.
     */
    
    
    public static void beforeInsert()
    { 
          //Below Flag is used to stop recursive method call
        
            if(Recursive.dealNameFlag!= true)
            PreventDuplicateDealName.dealNameCheckInsert();
        
     }
     
      /*
     * Name : beforeUpdate
     * Desc : Invokes all the methods in sequence before Updating a Deal.
     */
     public static void beforeUpdate()
    { 
       
       //Below Flag is used to stop recursive method call
        
            if(Recursive.dealNameFlag!= true || Test.isRunningTest())
            PreventDuplicateDealName.dealNameCheckUpdate();
        
     }
     }