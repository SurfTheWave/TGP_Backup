@isTest
/*
@name : DevTestClassForCoverage
@Description : 
@Version : 
*/
public class DevTestClassForCoverage {
/*
@name : testCoverage
@Description : 
@Version : 
*/
  static testmethod void testCoverage()
    {
        DevClassForTestCoverage.addString(UtilConstants.OU);
        DevClassForTestCoverageLatestOne.addString(UtilConstants.OU);
        DevClassForTestCoverageLatestTwo.addString(UtilConstants.OU);
        DevClassForTestCoverageLatesThree.addString(UtilConstants.OU);
        DevClassForTestCoverage1.addString(UtilConstants.OU);
        DevClassForTestCoverage2.addString(UtilConstants.OU);
    }
 /*
@name : testbatchCoverage
@Description : 
@Version : 
*/   
    static testmethod void testbatchCoverage()
    {
        DevClassForBatch.addString(UtilConstants.OU);
    }
/*
@name : testbatchCoverageSRAT
@Description : 
@Version : 
*/    
    static testmethod void testbatchCoverageSRAT()
    {
        DevClassForSRATOpexBatch.addString(UtilConstants.OU);
    }
}