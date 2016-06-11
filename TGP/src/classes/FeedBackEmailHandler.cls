/** Author-> Reena Thakre
Description:- To handle the inbound email coming as Feedback.
**/
global class FeedBackEmailHandler implements Messaging.InboundEmailHandler {
  
  /** Method to handle the inbound email **/
  global Messaging.InboundEmailResult handleInboundEmail(
  Messaging.InboundEmail email,
  Messaging.InboundEnvelope envelope)
  {
  Messaging.InboundEmailresult result = new Messaging.InboundEmailResult();
       try{  
    string html = email.htmlbody;

    //regular expression to match all HTML/XML tags
    string HTML_TAG_PATTERN = '<.*?>';
    // compile the pattern     
    pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
    matcher myMatcher = myPattern.matcher(html);
    //remove all tags and convert to plane
    String  result1 = myMatcher.replaceAll('');
    String[] emailBody= result1.split('\n', 0);
    result.success=true;
    String emailAddress = envelope.fromAddress;
    system.debug('emailBody>>>'+result1 );
    system.debug('htmlbody>>>'+email.htmlbody);
    for( integer i=0;i<emailBody.size();i++){
    
    system.debug('emailBody Array>>>>>>'+emailBody[i]+'--value of i--'+i);
    }
    // Retrieves the sender's first and last names
    //String fName = email.fromname.substring(0,email.fromname.indexOf(' '));
    //String lName = email.fromname.substring(email.fromname.indexOf(' '));   
    // String[] emailBody = email.plainTextBody.split('\n', 0);
    
    Client_Visit_Feedback__c fb = new Client_Visit_Feedback__c();
    String subject = email.subject;    
    List<Client_Visit_Feedback__c> feedback= new List<Client_Visit_Feedback__c>();
   
    map<String,String> emailBodyMap=new Map<String,String>();
     boolean flag=false;
     String Cname;
     String OppID;
    
    
    for(integer i=0;i<emailBody.size();i++){
    
    if(emailBody[i].trim()=='SWB Request ID'){ 
    String val='';
    integer y;
    for(y=i+1;emailBody[y].trim()!='SWB Opportunity ID';y++ ){
            
            val=val+emailBody[y].trim();
            
    }    
         
        Cname=val;
        
        i=y;
    }
    if(emailBody[i].trim()=='SWB Opportunity ID'){        
        String val='';
    integer y;
    for(y=i+1;emailBody[y].trim()!='Did the visit meet your expectations?';y++ ){
            
            val=val+emailBody[y].trim();
            system.debug('val.emailBody[y]..'+val+ emailBody[y]);
            
    }    
        System.debug(val);  
        OppID=val;
        
        i=y;
    }
    
    if(emailBody[i].trim()=='Did the visit meet your expectations?'){  
    String val='';
    integer y;
    
    for(y=i+1;emailBody[y].trim()!='Did the visit meet your expectations of what you';y++ ){
            
            val=val+emailBody[y]+'\n';
            }    
        fb.Did_the_visit_meet_your_expectations__c=val;
        System.debug(val);
        i=y;
    }
    if(emailBody[i].trim()=='wanted to communicate to the client/ have the client see?'){  
    String val='';
    integer y;
    for(y=i+1;emailBody[y].trim()!='Did the visit contribute to our ability to win the deal?';y++ ){           
            val=val+emailBody[y]+'\n';
    }     
        fb.Did_the_Communication_was_as_expected__c=val;
        System.debug(val);
        i=y;            
    }
    if(emailBody[i].trim()=='Did the visit contribute to our ability to win the deal?'){  
    String val='';
    integer y;
    for(y=i+1;emailBody[y].trim()!='Did the floor walk go to the appropriate level of detail?';y++ ){          
            val=val+emailBody[y]+'\n';
    }   
        fb.Visit_contributed_to_win_the_deal__c=val;
        System.debug(val);
        i=y;
            
    }
    if(emailBody[i].trim()=='Did the floor walk go to the appropriate level of detail?'){  
    String val='';
    integer y;
    for(y=i+1;emailBody[y].trim()!='Were the right experts available at the delivery location?';y++ ){         
            val=val+emailBody[y]+'\n';
    }    
        fb.Did_the_floor_walk_got_detailed__c=val;
        System.debug(val);
        i=y;
    }
    if(emailBody[i].trim()=='Were the right experts available at the delivery location?'){  
    String val='';
    integer y;
    for(y=i+1;emailBody[y].trim()!='What went especially well on this visit?';y++ ){           
            val=val+emailBody[y]+'\n';
    }   
        fb.Expert_were_available_at_Delivery_Loc__c=val;
        System.debug(val);
        i=y;    
    }
    if(emailBody[i].trim()=='What went especially well on this visit?'){  
    String val='';
    integer y;
    for(y=i+1;emailBody[y].trim()!='What did not go as planned on this visit?';y++ ){          
            val=val+emailBody[y]+'\n';
    }    
        fb.What_went_especially_well_on_this_visit__c=val;
        System.debug(val);
        i=y;    
            
    }
    if(emailBody[i].trim()=='What did not go as planned on this visit?'){              
        String val='';
        integer y;
    for(y=i+1;emailBody[y].trim()!='How can we improve the Client visit process/tools/etc.?';y++ ){            
            val=val+emailBody[y]+'\n';
    }     
        fb.What_did_not_go_as_planned_on_this_visit__c=val; 
        System.debug(val);
        i=y;
    }
    if(emailBody[i].trim()=='How can we improve the Client visit process/tools/etc.?'){  
    String val='';  
    integer y;
    for(y=i+1;emailBody[y].trim()!='On a scale of 1 to 5 please indicate the overall level';y++ ){           
            val=val+emailBody[y]+'\n';
    }    
        fb.How_to_improve_the_Client_visit_process__c=val;  
        System.debug(val);
        i=y;

    }
    if(emailBody[i].trim()=='of satisfaction with the Client visit'){  
        fb.Overall_satisfaction_with_Client_Visit__c=emailBody[i+1];  
         system.debug(emailBody[i].trim());
       
    }
    
    }
    
    
    system.debug('CNAME>>>'+cname);
    
    if(Cname!=null || Cname!=''){
    Client_Visit_Request__c req= [SELECT id FROM Client_Visit_Request__c WHERE name =:Cname limit 1];  
    fb.Client_Visit_Request__c= req.id;
     }

    
      
    
    
    feedback.add(fb);
    database.insert(feedback); 
    
    }   
    catch(Exception e){
    result.success=false;
    result.message='Feedback Not inserted.         '+e;         
    }
 
    return result;
    }
  
}