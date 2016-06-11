public class DashboardTaskController {

    
    public String objectId {get; set;}
    //public Task currentObject {get; set;}    
    //public String updatedItemStatus{get; set;}    
    public Integer numLeft {get; set;}
    public Integer total {get; set;}    
    private Integer startNdx = 0;
    private static Integer PAGESIZE = 8;
    private List<Task> fullTaskList = new List<Task>();
    private List<Task> displayedTaskList = new List<Task>();
    
    
    public DashboardTaskController() {
       getTasks();
    }
    
    public PageReference refreshPage() {
        return null;
    }
   
    public List<Task> getTasks() {
        String ownerId = UserInfo.getUserId();
        String emailId=null;
        List<User> userList=[SELECT Email FROM User where id=:ownerId];
        if(userList.size()==1)
        {
            emailId=userList[0].Email;
            
        }
//select Email_ID_of_the_reviewer__c from Review_User_Master__c where  id='a1tL0000000CnYIIA0'

//SELECT Email FROM User where id='005L0000000KS4p'
        if (fullTaskList.isEmpty()) {
            fullTaskList = [Select t.WhatId,t.WhoId,t.subject,t.Title__c, t.TCV__c, t.Status__c, t.Solution_Specialist__c, t.Send_Email__c, t.Reviewer_Id__c, t.Review_Type__c, t.Requester__c, t.Request_Review_Id__c, t.Region__c, t.OwnerId, t.Opportunity_Solution_Lead__c, t.Opportunity_Name__c, t.Opportunity_ID__c, t.Opportunities_Rivew_And_Approval__c, t.Operating_Group__c, t.Offering__c, t.Meeting_Type__c, t.Meeting_Record_ID__c, t.Meeting_ID__c, t.IsClosed, t.Id, t.Client_Name__c, t.Approval_Status__c,t.Email_ID_of_the_reviewer__c From Task t  where t.Approval_Status__c !=null and  t.Approval_Status__c =:'Pending' and t.Email_ID_of_the_reviewer__c =:emailId ];
            
            if(fullTaskList.size() > 0)
            {
                //for(Task myT : fullTaskList )
               // {
                
                  // List<Review_User_Master__c> reviewUserList=[select Email_ID_of_the_reviewer__c from Review_User_Master__c where  id=:myT.Reviewer_Id__c];
                  // if(reviewUserList.size()>0)
                    //{
                  // for(Review_User_Master__c reviewList: reviewUserList)
              //  {
                    //String taskEmail=null;
                    
                     //   taskEmail=reviewList.Email_ID_of_the_reviewer__c;
                   
                 //  if(emailId == taskEmail)
                 //  {
                    
                        numLeft = fullTaskList.size();
                        total = numLeft;
                        this.objectId = ((Task) fullTaskList[0]).id;
                         displayedTaskList.clear();
                        Integer endNdx = startNdx + PAGESIZE;
                        if (endNdx > total)
                            endNdx = total;
                        if(fullTaskList.size() > 0){    
                            for (Integer i=startNdx; i<endNdx; i++)
                            displayedTaskList.add(fullTaskList.get(i));
                            }
                            else
                            {
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));  
                                return null;
                            }
                   // }else
                   // {
                    //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You have no open tasks scheduled for this period.'));  
                    //    return null;
                   // }
                   // }
                   // }
           // }            
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));  
            return null;
        }
        }
        return displayedTaskList;   
    }
 public PageReference showDetail() {
        // since I can't get the assignTo to work in the VF page/component
        this.objectId = System.currentPageReference().getParameters().get('objectId');

        /*
        bizarre ... if I call setObjectId, the id returned from the detailPage method is null
        but if I directly set the id in this method, everything works correctly
        setObjectId(System.currentPageReference().getParameters().get('objectId'));
        */
        return null;
    } 
 /*   private void updateTaskStatus() {
        System.debug('before : ' + fullTaskList);
        Integer i = 0;
        for (i=0; i<fullTaskList.size(); i++) {
            Task t = fullTaskList.get(i);
            if (this.objectId.equals(t.id)) {
                System.debug('updating status of ' + t);                                
                Task tmp = [select id, WhatId, WhoId, ActivityDate, subject, status, priority, Description, ReminderDateTime, IsReminderSet, isClosed from Task where id = :t.id];
                fullTaskList.set(i, tmp);
                System.debug('updated to ' + tmp);
                //this.updatedItemStatus = tmp.status;
                break;
            }
        }
        
        System.debug('after : ' + fullTaskList);               
    } */
    
    public void nextTask() {
        for (Task t : fullTaskList) {
            if (!t.isClosed) {
                
                this.objectId = t.id;
                break;
            }
        }
    }
  
    
    

    public void previous() {
        startNdx -= PAGESIZE;
    }
    
    public void next() {
        startNdx += PAGESIZE;
    }    
    
  /*  public void refreshNumbers() {
        // the only time this method should be called is when a submit is done
        // on a record -- we assume the submit closes the record (or at least
        // puts the record in a state where we are not interested in seeing
        // it in our todo list anymore
        updateTaskStatus();
        nextTask();
        this.numLeft = 0;
        for (Task t : fullTaskList) {
            if (!t.isClosed) {
                this.numLeft++;
            }
        }        
        //this.objectId = prefetchedNextObjectId;
    }*/
    
    public Boolean getHasNext() {
        return total > (startNdx + PAGESIZE);
    }
    
    public Boolean getHasPrevious() {
        return startNdx > 0;
    }    

    public Integer getNum() {
        return total;
    } 
    
    public PageReference save(){       
        for (Task t : fullTaskList) {
           update t;
        }
        return null;    
    }
    }