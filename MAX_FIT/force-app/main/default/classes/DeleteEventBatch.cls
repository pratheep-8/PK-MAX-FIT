public class DeleteEventBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        String Query = 'SELECT Id,Name FROM Event__c WHERE Live__c= true AND End_Date_Time__c< LAST_N_MONTHS:2';
        return Database.getQueryLocator(Query);
    }
    public void execute(Database.BatchableContext batchContext,List<Event__c> eventlists ){
        if(!eventlists.isEmpty()){
            List<Database.DeleteResult> deleteResult = Database.delete(eventlists);
            for(Database.DeleteResult dr : deleteResult){
                if(!dr.isSuccess()){
                    List<Database.Error> errors = dr.getErrors();
                    String errorInString = String.join(errors,',');
                    TransactionLogHandler.doHandleExpectionWithError(errorInString, 'DeleteEventBatch');
                }
            }
        }
    }
    public void finish(Database.BatchableContext batchContext){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
            mail.setSubject('Batch Processing Completed');
            List<String> toAddress = new List<String>();
        	toAddress.add('pratheepkumar752@gmail.com');
        	mail.setToAddresses(toAddress);
            mail.setSenderDisplayName('Pratheep Kumar ');
            mail.setHtmlBody('The DeleteEventBatch Batch Processing has been Completed');
       	 Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail} );
    }
}