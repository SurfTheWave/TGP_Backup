/*
This controller is to load current date and year for calendar
*/
public class ApprovalMeetingCalendarController {
 public Integer currentYear{set;get;}
 public integer currentmonth{set;get;} 

/*******
 * @method :ApprovalMeetingCalendarController 
 * @param : none
*****/
    public ApprovalMeetingCalendarController (){
      currentYear = System.Today().year();
      currentmonth = system.today().month()-1;
  }
}