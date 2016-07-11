/**
 * Date  -  June 2016.
 * Developed by - Dhruvsoft Services Private Limited (www.dhruvsoft.com).          
 * Purpose of Code - This class is used to test the deleteAllRecords batch class which deletes 
 *                   all the records in an org.
 * Package Version - 1.3 
 **/
@isTest
public class DeleteAllRecordsTest {
    static testmethod void testDeleteAllRecords() {
        list<Object> deleteObjectList = new List<Object>{'PriceBook2', 'Account'};
        System.Test.startTest();
        DeleteAllRecords c = new DeleteAllRecords(deleteObjectList);
        Database.executeBatch(c);
        System.Test.stopTest();  
    }
    static testmethod void testDeleteAllRecords1() {
        System.Test.startTest();
        DeleteAllRecords c = new DeleteAllRecords();
        Database.executeBatch(c);
        System.Test.stopTest();  
    }
    
}