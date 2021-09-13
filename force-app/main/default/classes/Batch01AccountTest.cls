@isTest
public class Batch01AccountTest {

    @testsetup
    static void prepareDataForTest()
    {
         List<Account> accounts = new List<Account>();
         for (Integer i=0;i<20;i++) {
            accounts.add(new Account(name='Account '+i));
         }
         insert accounts;
    }
    
    @isTest
    static void executeBatchtest(){
        
        Test.startTest();
           Batch01Account accBat=new Batch01Account();
           Id batchId = Database.executeBatch(accBat);
        Test.stopTest();
        
    }
}