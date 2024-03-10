/**
* @description       : Apex Class utility
* @author            : Lisandro Ortiz
* @group             : devOTZ
* @last modified on  : 03-10-2024
* @last modified by  : Lisandro Ortiz
* Modifications Log
* Ver   Date         Author            Modification        Email
* 1.0   03-10-2024   Lisandro Ortiz   Initial Version     lisandro.lor@gmail.com
**/
public with sharing class devOTZ_Data_cls {

    /**
    * @description       : Description
    * @Autor             : Lisandro Ortiz
    * @Date              : 03-10-2024
    * @Param Param1      : Country 
    * @Return            : List<Task>{[{"Id":"","Subject":"","ActivityDate":"","Priority":"","Status":"","Color__c":""}]}
    **/
    @AuraEnabled
    public static List<Task> getData(Id parentId) {
        return [SELECT Id, Subject, ActivityDate,Priority,Status,Color__c  FROM Task WHERE whoId=:parentId WITH SECURITY_ENFORCED ORDER BY ActivityDate DESC];    
    }

    /**
    * @description       : This method is executed by the flow ""devOTZ_Event_Platform" 
    * @Autor             : Lisandro Ortiz
    * @Date              : 03-10-2024
    * @Param Param1      : Request
    * @Return            : Issuccess[TRUE|FALSE] message['text']
    **/
    @InvocableMethod(label='Event Platform' description='' category='Task')
    public static List<Result> pushEvent(List<Request> request) {
        List<Result> isSucces = new List<Result>();
        Result response = new Result();
        response.Issuccess = true;
        response.message = '';

        try {
            Event__e event = new Event__e();
            event.recordId__c = request[0].recordId ;
            EventBus.publish(event);                
        } catch (Exception e) {
            response.Issuccess = false;
            response.message = e.getMessage();            
        }       
       
        isSucces.add(response);
        return isSucces;
    }

    public class Request {
        @InvocableVariable(label='Input Record Id' description='Record Id' required=true)
        public String recordId;
    }
    public class Result {
        @InvocableVariable(label='Boolean for Output' description='Is Success' required=true)
        public Boolean Issuccess;
        @InvocableVariable(label='Message for Output' description='Message' required=true)
        public String message;
    }

}