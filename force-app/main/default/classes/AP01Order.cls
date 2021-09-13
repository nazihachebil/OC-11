public class AP01Order {
   
    public static boolean checkOrderProduct(Id OrdId){
      
      // Vérifier s'il y a des order products rattaché à l'order. S'il existe, return false sinon return true
      Order ordRecord=[select Id,(select Id from OrderItems) from order Where Id = :OrdId LIMIT 1 ];
      
      if(ordRecord.OrderItems.size()==0)  return true;
      else return false;
      
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