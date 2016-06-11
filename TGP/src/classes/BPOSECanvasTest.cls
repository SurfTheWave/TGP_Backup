/******************************
   @Author       : Jyotsna
   @Class name   : BPOSECanvasTest
   @CreateDate   : 1-July-2015
   @Description : Test class for BPOSECanvas Class
   @Version : 1.0 
*******************************/
@isTest

private class BPOSECanvasTest{
     /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON() {
        
        PageReference pg = Page.BPOSECanvas;
        Test.setCurrentPage(pg);
        BPOSECanvas bp = new BPOSECanvas();
        test.startTest();
            bp.generateJSONContent();
        test.stopTest();
        
    }
    
    /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON1() {
        PageReference pg = Page.BPOSECanvas;
        Test.setCurrentPage(pg);
        BPOSECanvas bp = new BPOSECanvas();
        test.startTest();
            bp.generateJSONContentResource();
        test.stopTest();
        
    }
    }