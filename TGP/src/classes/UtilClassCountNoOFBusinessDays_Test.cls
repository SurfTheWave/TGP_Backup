@isTest
private class UtilClassCountNoOFBusinessDays_Test{
    
    private static testmethod void test1(){
    Date enddt=Date.newInstance(2016, 3, 3);

    Date startdt=enddt.addDays(5);
    Date tempdt;
    //system.assert();
    test.starttest();
    
    UtilClassCountNoOFBusinessDays.getDiffBusinessDays(startdt,enddt);
    test.stoptest();
    
    }
    }