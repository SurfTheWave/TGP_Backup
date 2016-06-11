/*
@Author :  Ezdhan.hus
@name : MFSI_FormatDateTime
@CreateDate : 4/2/2015 10:51 AM
@Description : 
@Version : 
*/
public with sharing class MFSI_FormatDateTime {
    public DateTime dateTimeValue {
        get;
        set;
    }
    public string whatyouwant {
        set;
        get;
    }
    public string userslocale{Set;get;}

        /*
    @Author :  Ezdhan.hus
    @name : MFSI_FormatDateTime
    @CreateDate : 4/2/2015 10:51 AM
    @Description : 
    @Version : 
    */
    public String getTimeZoneValue() {
        try {
            String localeFormatDT;
            if (dateTimeValue != null) {

                if (whatyouwant.equalsignorecase(UtilConstants.timestr)) {
                    localeFormatDT = dateTimeValue.format(UtilConstants.hoursformat);
                } else if (whatyouwant.equalsignorecase(UtilConstants.Datestr)) {
                    localeFormatDT = dateTimeValue.format(UtilConstants.Dateformat, UtilConstants.GMT);
                }else if(whatyouwant.equalsignorecase(UtilConstants.apacuserzonetime)){
                    localeFormatDT = dateTimeValue.format(UtilConstants.hoursformatwithtimezone ,userslocale);
                } 
                else if(whatyouwant.equalsignorecase(UtilConstants.emeauserzonetime)){
                    localeFormatDT = dateTimeValue.format(UtilConstants.hoursformatwithtimezone ,userslocale);
                } 
                else if(whatyouwant.equalsignorecase(UtilConstants.latamuserzonetime)){
                    localeFormatDT = dateTimeValue.format(UtilConstants.hoursformatwithtimezone ,userslocale);
                } 
                else {
                    localeFormatDT = dateTimeValue.format(label.Datetime_format);
                }
                return localeFormatDT;
            }
            return null;
        } Catch(Exception e) {
            String str = e.getmessage();
            return null;
        }
    }
}