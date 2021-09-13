trigger taskTrigger on Task (after insert, after update, after delete) {

    if(trigger.isafter){
        //Après chaque insersion, update ou delete des tâches, Récupérer les Ids des accounts auquels elles sont rattachées
        //mettre à jour le champ No_call_tasks__c en false S'il y a des tâches de rappel. Sinon No_call_tasks__c restera true.
      
        set<id> accSetIds=new set<id>();
        if(trigger.isinsert){
            for(task tsk:trigger.new){
                if(tsk.WhatId!=NULL && string.ValueOf(tsk.WhatId).startsWith('001') ){
                    accSetIds.add(tsk.WhatId);
                }
            }
        }
        if(trigger.isupdate){
            for(task tsk:trigger.new){
                task NewEtat = trigger.newMap.get(tsk.Id);
                task OldEtat = trigger.oldMap.get(tsk.Id);
                if(NewEtat.WhatId!=Null && OldEtat.whatId!=Null){
                    if(string.ValueOf(NewEtat.WhatId).startsWith('001')  && string.ValueOf(OldEtat.WhatId).startsWith('001')){
                        if(NewEtat.Subject!=OldEtat.Subject){
                           accSetIds.add(NewEtat.WhatId); 
                           accSetIds.add(OldEtat.WhatId);
                        }
                    }
                }
            }
        }
        if(trigger.isdelete){
            for(task tsk:trigger.old){
                if(tsk.WhatId!=NULL && string.ValueOf(tsk.WhatId).startsWith('001')){
                    accSetIds.add(tsk.WhatId);
                }
            }
        }
        
        if(accSetIds!=null && accSetIds.size()>0){
            AP01Account.checkNoCallTask(accSetIds);
        }
    }
}