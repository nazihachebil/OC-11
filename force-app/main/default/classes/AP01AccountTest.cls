@isTest
public class AP01AccountTest {

    @testsetup
    static void prepareDataForTest()
    {
         Account acc1 = new Account(Name = 'Test Account 1');
         insert acc1;
         User userToCreate = [Select id from user where profile.name='System Administrator' Limit 1];
        
         Task Task1=new Task(WhatId=acc1.Id,OwnerId=userToCreate.Id,Subject='Call',Status='New', Priority ='Normal');
         Task Task2=new Task(WhatId=acc1.Id,OwnerId=userToCreate.Id,Subject='Email',Status='New', Priority ='Normal');
         Task Task3=new Task(WhatId=acc1.Id,OwnerId=userToCreate.Id,Subject='Call',Status='New', Priority ='Normal');
          
         List<Task> tasks=new List<Task> {Task1,Task2,Task3};
         insert tasks;
        
         Task1.Subject='Email';
         update Task1;
         
         delete Task3;
    }
     @isTest
    static  void createTasksTest(){
        
        set<Id> accIdSet=new set<Id>();
        Account acc=[Select Id,Name From Account Where Name =: 'Test Account 1' Limit 1];
        accIdSet.add(acc.Id);
        
        Test.startTest();
           AP01Account.createTasks(accIdSet);
        Test.stopTest();
    }
    @isTest
    static  void checkNoCallTaskTest(){
        
        set<Id> accIdSet=new set<Id>();
        Account acc=[Select Id,Name From Account Where Name =: 'Test Account 1' Limit 1];
        accIdSet.add(acc.Id);
        
        Test.startTest();
           AP01Account.checkNoCallTask(accIdSet);
        Test.stopTest();
    }
}