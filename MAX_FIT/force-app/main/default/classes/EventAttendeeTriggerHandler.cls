public class EventAttendeeTriggerHandler {
    
    public static void sendConfirmationEmail(List<Event_Attendee__c> newRecordList ) {
        Set<Id> attendeesIdsSet = new Set<Id>();
        Set<Id> eventIdsSet = new Set<Id>();
        for(Event_Attendee__c ea : newRecordList){
            attendeesIdsSet.add(ea.Attendee__c);
            eventIdsSet.add(ea.Event__c);
        }
        Map<Id,Attendee__c> attendeeMap = new Map<Id,Attendee__c>(
            [SELECT Id , Name , Email__c FROM Attendee__c WHERE Id IN : attendeesIdsSet] );
        
        Map<Id,Event__c> eventMap = new Map<Id,Event__c>([SELECT Id,Name__c,Start_DateTime__c,Event_Organizer__c,Event_Organizer__r.Name,
                                   Location__c,Location__r.Name,Location__r.City__c,Location__r.Country__c,
                                   Location__r.State__c,Location__r.Postal_Code__c,Location__r.Street__c
                                   FROM Event__c WHERE ID IN : eventIdsSet]);
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Event_Attendee__c ea : newRecordList){
            Attendee__c att = attendeeMap.get(ea.Attendee__c);
            Event__c evt = eventMap.get(ea.Event__c);
            // Preapre Email Template
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Pass for the '+evt.Name__c);
            String location =  'https://www.google.com/maps/place/' +evt.Location__r.Street__c + ' '+evt.Location__r.City__c + ' '+evt.Location__r.State__c+' '
                				+evt.Location__r.Country__c+' '+ evt.Location__r.Postal_code__c;
            String hrefLocation = '<a href ="'+location+'"'+'target="_blank">Here</a>';
            List<String> toAddressess = new List<String>();
            toAddressess.add(att.Email__c);
            mail.setToAddresses(toAddressess);
            mail.setSenderDisplayName(evt.Event_Organizer__r.Name);
            String EmailBody = ' Dear '+ ' '+att.Name + ' '+
								'Thank you for registering for '+evt.Name__c+'</br>'+' which will be Organized on '+evt.Start_DateTime__c+'</br>'+' & will be held in' 
											+evt.Location__r.Name +'. We are excited to have you, see you in the event.</br>'+
									'Find the Google Map Location for the Event Here.' +hrefLocation+ '</br>'+
								'Thanks,</br>'+
							evt.Event_Organizer__r.Name;
            mail.setHtmlBody(EmailBody);
            emailList.add(mail);
        }
        try{
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList,false);
            for(Messaging.SendEmailResult email : results){
                System.Debug(email.isSuccess());
                if(!email.isSuccess()){
            		List<Messaging.SendEmailError> errors = email.getErrors();
                    TransactionLogHandler.doHandleExpectionWithError(JSON.serialize(errors), 'EventAttendeeTriggerHandler');        
                }
            }
            Messaging.sendEmail(emailList);
        }catch(System.Exception ex){	
            TransactionLogHandler.doHandleExpection(ex, 'EventAttendeeTriggerHandler');
        }
    }
}