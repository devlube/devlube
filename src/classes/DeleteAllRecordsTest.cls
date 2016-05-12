@isTest
public class DeleteAllRecordsTest {
	static testmethod void testDeleteAllRecords() {
        Database.BatchableContext BC;
        list<string> deleteObjectList = new List<string>{'Account','Contact','Opportunity','Case'};
   		Test.startTest();
        DeleteAllRecords c = new DeleteAllRecords();
        c.start(BC);
        c.execute(BC,deleteObjectList);
        c.finish(BC);
        Test.stopTest();  
    }
}