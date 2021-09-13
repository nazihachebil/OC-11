public class AP01Account {

    public static void createTasks(set<Id> accIds){
       
       //Créer les tâches de sujet'Call'et les rattacher aux accounts n'ayant ni order associés ni des tâches de rappel
        List<Task> tskList=new List<Task>();
        for(Account acc:[Select Id,OwnerId From Account Where Id IN :accIds]){
           
           Task newTask=new Task(WhatId=acc.Id,OwnerId=acc.OwnerId,Subject='Call',Status='New', Priority ='Normal',
                                      IsReminderSet = true,ReminderDateTime = System.now()+5);
           tskList.add(newTask);
            
        }
        if(tskList!=null && tskList.size()>0){
            insert tskList;
        }
    }
    
    public static void checkNoCallTask(set<Id> accIds){
        
        //Vérifier si parmi les tâches rattachées aux accounts, il y a des tâches de rappel. S'il y a des tâches de rappel, 
        //le champ No_call_tasks__c sera false. Sinon No_call_tasks__c restera true.
        List<Account> AcclistUpdat=new List<Account>();
        Boolean indiCallTasks;
        for(Account acc:[Select Id,No_call_tasks__c ,(SELECT Id,Subject FROM Tasks) From Account Where Id IN :accIds]){
            indiCallTasks=false; 
            for(task tsk:acc.Tasks){
                if(tsk.Subject=='Call'){
                    acc.No_call_tasks__c=false;
                    indiCallTasks=true;
                    AcclistUpdat.add(acc);
                    break;
                }
            }
            if(indiCallTasks==false){
                if(acc.No_call_tasks__c==false){
                   acc.No_call_tasks__c=true;
                   AcclistUpdat.add(acc); 
                }
            }
        }
        if(AcclistUpdat!=null && AcclistUpdat.size()>0){
            update AcclistUpdat;
        }
    }
}