public class LocationTriggerHandler {
    @future(callout=true)
    public static void verifyAddress(String recordId){
        Location__c loc = [SELECT Id,Verified__c,Name,Street__c,City__c,State__c,Postal_Code__c 
                           FROM Location__c 
                           WHERE Id  =:recordId];
         
        String baseURL = 'https://us-street.api.smarty.com/street-address?auth-id=925f0e76-0141-30fc-6cac-1c20496f7d0f&auth-token=bQb3acbZcWKjDcDjXGdD';
        baseURL+= '&street='+EncodingUtil.urlEncode(loc.Street__c,'UTF-8')
            +'&city='+EncodingUtil.urlEncode(loc.City__c,'UTF-8')
            +'&state='+EncodingUtil.urlEncode(loc.State__c,'UTF-8')
            +'&zipcode='+EncodingUtil.urlEncode(loc.Postal_Code__c,'UTF-8')
            +'&match=invalid&candidates=10';
        System.debug('baseURL '+baseURL);
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(baseURL);
        httpReq.setHeader('Content-Type','application/json');
        Http http = new Http();
        HttpResponse httpRes = new HttpResponse();
        try{
            httpRes = http.send(httpReq);
            System.debug('Response '+ httpRes.getBody());
            if(httpRes.getStatusCode() == 200 && httpRes.getStatus() == 'OK'){
                String responseBody = httpRes.getBody();
                if(!String.IsBlank(responseBody) && responseBody.length() > 2 ){
                    loc.Verified__c = true;
                }
                else{
                    loc.Verified__c = false;
                }
                update loc;
            }
            else{
                TransactionLogHandler.doHandleExpectionWithError(httpRes.getBody(), 'LocationTriggerHandler');
            }
            
        }catch(System.CalloutException ex){
            System.debug('Exception Executed '+ex.getStacktraceString());
            TransactionLogHandler.doHandleExpection(ex, 'LocationTriggerHandler');
        }
        
    }

}