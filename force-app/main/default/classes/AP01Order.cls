public class AP01Order {
   
    public class MyException extends Exception {}
    
    public static void checkOrderProduct(set<Id> OrdSetIds){
      
      // Vérifier s'il y a des order products rattaché à l'order. S'il existe, jeter une exception
      
      for(Order ord:[select Id,(select Id from OrderItems) from order Where Id IN :OrdSetIds])
      {
          if(ord.OrderItems.size()==0){
             
              Throw  new MyException('You must add order products before activating order.');
          }
      }
      
     
      
   }
    
    public static void checkActivAccount(set<Id> accIds){
        
        //récupérer la liste des accounts puis Mettre à jour le champ Active en false s'il n'y a pas des orders.
        // Sinon, le champ Active est true
        List<Account> accList=[select Id,Active__c,(select Id from Orders) from Account Where Id in :accIds];
        List<Account> accsToUpdat=new List<Account>();
        
        for(Account acc:accList){
            if(acc.Active__c==false){
                if(acc.Orders.size()>0){
                    acc.Active__c=true;
                    accsToUpdat.add(acc);
                }
            }
            else{
                if(acc.Orders.size()==0){
                    acc.Active__c=false;
                    accsToUpdat.add(acc);
                }
            }
        }
        if(accsToUpdat!=null && accsToUpdat.size()>0){
            update accsToUpdat;
        }
    }
}