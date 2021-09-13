@isTest
public class AP01OrderTest {

    @testsetup
    static void prepareDataForTest()
    {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;
        
        Account acc2 = new Account(Name = 'Test Account 2');
        insert acc2;
        
        //Create the Product
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        
        Insert pbe;
        
        //Create  orders
        Order ordTest1=new Order(AccountId=acc1.Id,Pricebook2Id=Test.getStandardPricebookId(),Status='Draft',EffectiveDate=System.Today()+7);
        insert ordTest1;
        
        try{
            ordTest1.Status='Activated';
            update ordTest1;
           
        }catch(exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('You must add order products before activating Order.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
         }
        
        Order ordTest2=new Order(AccountId=acc1.Id,Status='Draft',Pricebook2Id=Test.getStandardPricebookId(),EffectiveDate=System.Today()+14);
        insert ordTest2; 
        
        ordTest2.AccountId=acc2.Id;
        update ordTest2;
        
        delete ordTest2;
        
        //Create  orderItems
        OrderItem ordItem1 = new OrderItem (OrderId = ordTest1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert ordItem1;
        
     
    }
     @isTest
    static  void checkOrderProductTest(){
        
        set<Id> OrdIdSet=new set<Id>();
        Order ord=[Select Id,Account.Name From Order Where Account.Name =: 'Test Account 1' Limit 1];
        Test.startTest();
           AP01Order.checkOrderProduct(ord.Id);
        Test.stopTest();
    }
    
    @isTest
    static  void checkActivAccountTest(){
        set<Id> accIdSet=new set<Id>();
        Account acc=[Select Id,Name From Account Where Name =: 'Test Account 1' Limit 1];
        accIdSet.add(acc.Id);
        
        Test.startTest();
           AP01Order.checkActivAccount(accIdSet);
        Test.stopTest();
    }
}