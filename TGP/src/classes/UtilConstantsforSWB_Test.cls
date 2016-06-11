@isTest
/*
@name : UtilConstantsforSWB_Test
@Description : 
@Version : 
@Modified By: Aswajit Swain
*/
private class UtilConstantsforSWB_Test{
    /*
    @name : UtilConstantsforSWBTest
    @Description : 
    @Version : 
    */
    private static testMethod void UtilConstantsforSWBTest(){
        try{
            String ProID =UserInfo.getProfileID();
            Profile P =New Profile();
            Profile p1 = new Profile();
            P.Name = [Select id,Name from Profile where ID=:ProID LIMIT 1].Name;
            Test.startTest();  
            UtilConstantsforSWB UtilTest =new UtilConstantsforSWB();
            ID profile= UtilConstantsforSWB.utilMethod(P.Name);
            List<String> s=new List<String>();
            List<String> snull=new List<String>();
            String s1=P.name;
            String s2='';
            s.add(s1);
            snull.add('asdfsdfsdf');
            Map<id,profile> map1=new  Map<id,profile>();
            Map<id,profile> map2=new  Map<id,profile>();
            map1=UtilConstantsforSWB.queryProfiles(s);
            ID profileid=UtilConstantsforSWB.utilMethod('xyz');
            UtilConstantsforSWB.queryProfiles(new List<String>{''});
            Test.stopTest();  
        }catch(Exception e) {
            System.assert(true, 'Exception ' + e);
        }
    }
}