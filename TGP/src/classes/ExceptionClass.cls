/*
  @Author: Ezdhan
  @Name: ExceptionClass
  @Created Date: 
  @Description:
  @version: 1.0
*/
public with sharing class ExceptionClass {
    /*
      @Author: Ezdhan
      @Name: logException
      @Created Date: 
      @Description:
      @version: 1.0
    */
    public static void logException(String className,string MethodName,exception e,string appName,string CallingAppName){
          List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
          ExceptionLog__c exlog =new ExceptionLog__c();
          if(e.getMessage().length() > 99){
              exlog.ExceptionDescription__c=e.getMessage().substring(0,99);
          }
          else{
              exlog.ExceptionDescription__c=e.getMessage().substring(0,e.getMessage().length());
          }
          exlog.ExceptionDetails__c=String.valueof(e)+e.getStackTraceString();
          exlog.ExceptionLogTimestamp__c=system.now();
          exlog.ExceptionType__c=e.getTypeName();
          exlog.Application__c=appName;
          exlog.WSCallingApplication__c=CallingAppName;
          exlog.MethodName__c=MethodName;
          exlog.ClassName__c=className;
          exlog.ContextUser__c=userinfo.getuserid();
          exceptions.add(exlog);
          if(!test.isrunningtest()){
            database.insert(exceptions,true);
          }
    }
    
    /*
      @Author: Aswajit Swain
      @Name: logError
      @Created Date: 04 Sep 2015
      @Description:
      @version: 1.0
    */
    public static void logError(String className,String MethodName,String exMsg,String expDetail,String appName,String callingAppName){
          List<ExceptionLog__c> exceptions=new list<ExceptionLog__c>();
          ExceptionLog__c exlog =new ExceptionLog__c();
          exlog.ExceptionDescription__c=exMsg;
          if(expDetail.length() <= 32765){
              exlog.ExceptionDetails__c=expDetail;
          }else
              exlog.ExceptionDetails__c=expDetail.substring(0, 32765);
          
          exlog.ExceptionLogTimestamp__c=system.now();
          exlog.ExceptionType__c='';
          exlog.Application__c=appName;
          exlog.WSCallingApplication__c=CallingAppName;
          exlog.MethodName__c=MethodName;
          exlog.ClassName__c=className;
          exlog.ContextUser__c=userinfo.getuserid();
          exceptions.add(exlog);
          if(!Test.isRunningTest()){
              Database.insert(exceptions,true);
          }
    }
    
}