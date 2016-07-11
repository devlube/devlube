@isTest
public class DeleteAllRecordsTest {
	static testmethod void testDeleteAllRecords() {
        list<string> deleteObjectList = new List<string>{'Account'};
        Test.startTest();
        DeleteAllRecords c = new DeleteAllRecords(deleteObjectList);
        Database.executeBatch(c);
        
        Test.stopTest();  
    }
}