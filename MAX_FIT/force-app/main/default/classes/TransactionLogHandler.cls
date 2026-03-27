public class TransactionLogHandler {
    public static void doHandleExpection(System.Exception ex,String processName){
        Error_Log__c transactionLog = new Error_Log__c(
        Log_Details__c = ex.getStackTraceString() + '<br/>' + ex.getMessage()
         + '<br/>' + ex.getCause() + '<br/>' + ex.getTypeName() + '<br/>' + ex.getLineNumber(),
         Lod_DateTime__c = System.Now(),
         Process_Name__c = processName
         );
        if(Schema.sObjectType.Error_Log__c.isCreateable()){
            insert transactionlog;
        }
        
 
    }
    
    public static void doHandleExpectionWithError(String errors,String processName){
        Error_Log__c transactionLog = new Error_Log__c(
        Log_Details__c = errors,
         Lod_DateTime__c = System.Now(),
         Process_Name__c = processName
         );
        if(Schema.sObjectType.Error_Log__c.isCreateable()){
            insert transactionlog;
        }
        
 
    }
}