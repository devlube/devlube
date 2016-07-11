@isTest
public class DevLubeControllerTest{
    public static testMethod void testDevLubeController() {
        PageReference pageRef = Page.DevLube;
        Test.setCurrentPage(pageRef);
      	Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        DevLubeController con = new DevLubeController();
        test.startTest();
        con.listMetadata();
        test.stopTest();
    }
}