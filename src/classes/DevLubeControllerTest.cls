/**
 * Date  -  June 2016.
 * Developed by - Dhruvsoft Services Private Limited (www.dhruvsoft.com).          
 * Purpose of Code - This class is used to test the webservices callouts in DevLubeController.
 * Package Version - 1.3 
 **/
@isTest
public class DevLubeControllerTest{
    public static testMethod void testDevLubeController() {
        PageReference pageRef = Page.DevLube;
        System.Test.setCurrentPage(pageRef);
        System.Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        DevLubeController con = new DevLubeController();
        System.test.startTest();
        con.addDestructiveChanges();
        con.listMetadata();
        con.doReferesh();
        con.deployZip();
        System.test.stopTest();
    }
}