@istest
private class MFSI_FormatDateTime_Test{
    static testMethod void test_Method(){
    MFSI_FormatDateTime MFSI=new MFSI_FormatDateTime ();
    MFSI.dateTimeValue=system.today(); 
    MFSI.whatyouwant='time';
    MFSI.getTimeZoneValue();
    }
    static testMethod void test_Method2(){
    MFSI_FormatDateTime MFSI=new MFSI_FormatDateTime ();
    MFSI.dateTimeValue=system.today(); 
    MFSI.whatyouwant='date';
    MFSI.getTimeZoneValue();
    }
    static testMethod void test_Method3(){
    MFSI_FormatDateTime MFSI=new MFSI_FormatDateTime ();
    MFSI.dateTimeValue=system.today(); 
    MFSI.whatyouwant='apactime';
    MFSI.getTimeZoneValue();
    }
    static testMethod void test_Method4(){
    MFSI_FormatDateTime MFSI=new MFSI_FormatDateTime ();
    MFSI.dateTimeValue=system.today(); 
    MFSI.whatyouwant='emeatime';
    MFSI.getTimeZoneValue();
    }
    static testMethod void test_Method5(){
    MFSI_FormatDateTime MFSI=new MFSI_FormatDateTime ();
    MFSI.dateTimeValue=system.today(); 
    MFSI.whatyouwant='latamtime';
    MFSI.getTimeZoneValue();
    }
}