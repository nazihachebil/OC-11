global class Batch01AccountSchedulabler implements Schedulable{

    global void execute(SchedulableContext SC) { 
        database.executeBatch(new Batch01Account());
    }
    // Pour planifier l'execution de batch le premier Lundi de chaque mois , ouvrir juste "Execute Anonymous Window" dans console develop et écrire: 
    // string timeinterval = '0 0 8 ? * 2#1' ;
   //  System.schedule('BatchAccount-Monthly',timeinterval, new Batch01AccountSchedulabler());
   //  Puis cliquer sur "execute"
}