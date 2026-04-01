public with sharing class CustomSearchController {
    @AuraEnabled
    public static string searchRecords(String objName,String fieldName , String searchKey){
        String searchKeyword = searchKey + '*';
        String returningQuery = objName + '(Id ,'+fieldName+')';
        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+ 'LIMIT 2000';
        List<List<SObject>> SobjectList = Search.query(Query);
        return JSON.serialize(SobjectList);
    }
}