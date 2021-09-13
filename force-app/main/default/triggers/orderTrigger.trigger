trigger orderTrigger on Order (before update,after insert, after update, after delete) {
   
    if(trigger.isbefore){
       //Avant chaque update de status des orders de Draft à Active, vérifier s'il y a des order products rattachés.
       // S'il n'y a pas, afficher un message d'erreur "You must add order products before activating Order" 
       
        set<Id> ordsetIds=new set<Id>();
        boolean ordCheck;
        if(trigger.isupdate){
           for(order ord:trigger.new){
               order NewEtat = trigger.newMap.get(ord.Id);
               order OldEtat = trigger.oldMap.get(ord.Id);
               if(NewEtat.Status!=OldEtat.Status){
                 if(NewEtat.Status=='Activated' && OldEtat.Status=='Draft'){
                     ordCheck=AP01Order.checkOrderProduct(NewEtat.Id); 
                     if(ordCheck==true){
                         NewEtat.addError('You must add order products before activating Order.');
                     }
                 }
               }
               
           }
        }
        
   }
     if(trigger.isafter){
        //Après chaque insert update ou delete des orders ,Récupérer les Ids des accounts auxquels ils sont rattachés
        //Mettre à jour le champ Active en false s'il n'y a pas des orders. Sinon, le champ Active est true
       
        set<Id> accsetIds=new set<Id>();
        if(trigger.isinsert){
           for(order ord:trigger.new){
              accsetIds.add(ord.AccountId);
           }
        }
        if(trigger.isupdate){
           for(order ord:trigger.new){
               order NewEtat = trigger.newMap.get(ord.Id);
               order OldEtat = trigger.oldMap.get(ord.Id);
              
               if(NewEtat.AccountId!=OldEtat.AccountId){
                   accsetIds.add(NewEtat.AccountId);
                   accsetIds.add(OldEtat.AccountId);
               }
           }
        }
         if(trigger.isdelete){
             for(order ord:trigger.old){
                 accsetIds.add(ord.AccountId);
             }
         }
        if(accsetIds!=null && accsetIds.size()>0){
             AP01Order.checkActivAccount(accsetIds);
        }
    }
}