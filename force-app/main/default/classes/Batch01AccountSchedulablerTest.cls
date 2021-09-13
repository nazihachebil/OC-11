@isTest
public class Batch01AccountSchedulablerTest {
    
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
    static  void ScheduleBatchTest(){
        Test.startTest();
           String jobId = System.schedule('ScheduledApexTest','0 3 * * * ?',new Batch01AccountSchedulabler());
        Test.stopTest();
        
    }
}