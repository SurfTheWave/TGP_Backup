/*
This controller is to load current date and year for calendar
*/
public without sharing class ClientVisitCalendarController {
 public Integer currentYear{set;get;}
 public integer currentmonth{set;get;} 

/*******
 * @method :ClientVisitCalendarController
 * @param : none
*****/
    public ClientVisitCalendarController (){
      currentYear = System.Today().year();
      currentmonth = system.today().month()-1;
  }
}