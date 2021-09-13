global class Batch01Account implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext info){ 
       //Requeter seulement les comptes qui n'ont pas d’order associés ni des tâches de rappel 
       return Database.getQueryLocator([SELECT Id,Active__c,No_call_tasks__c FROM Account WHERE Active__c=false AND No_call_tasks__c=true]);

   }
    
   global void execute(Database.BatchableContext info, List<Account> scope){
       Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
       AP01Account.createTasks(setAccountIds);
   }    
    
   global void finish(Database.BatchableContext info){     
       
   } 
}