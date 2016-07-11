/**
 * Date  -  June 2016.
 * Developed by - Dhruvsoft Services Private Limited (www.dhruvsoft.com).          
 * Purpose of Code - This class is used to refresh the new developer org. It deletes all the Data, except few Object data.
 *                   In this all the Objects are iterated to delete maximum of 10000 records in a batch,
 *                   if there are more than 10000 records these objects are iterated in next batch or
 *                   if there is any dependency, the parent data is deleted for the first time and 
 *                   the child data in the next iteration. 
 * Package Version - 1.3 
 **/
public class DeleteAllRecords implements Database.Batchable<Object>, Database.Stateful {
public list<Object> deleteObjectList = new List<Object>();
public list<Object> undeletedObjects = new list<Object>();
public Boolean moreRecords;
    public DeleteAllRecords(List<Object> objectList){
        moreRecords = false;
        deleteObjectList.addall(objectList);
    }
    
      public DeleteAllRecords(set<String> objectList){
        moreRecords = false;  
        Map<String, Schema.SObjectType> describeAll = Schema.getGlobalDescribe(); 
        set<String> allObjectSet = describeAll.keySet();
        set<Object> undeleteableObjects = new set<Object>{'vote', 'contentdocumentlink', 'groupsubscription', 'profile', 'objectpermissions', 'permissionset', 'emailtemplate', 'group', 'permissionsetassignment', 'fieldpermissions', 'setupentityaccess', 'collaborationgrouprecord', 'ideacomment', 'authsession','loginip','clientbrowser'};
        set<Object> newSet = new  set<Object>();
        for(String ss : allObjectSet){          
           Schema.DescribeSObjectResult d =  Schema.getGlobalDescribe().get(ss).getDescribe();
             if(d.isQueryable() && d.isdeletable() && !undeleteableObjects.contains(ss.toLowerCase()) && !objectList.contains(ss.toLowerCase())){
                 if(!objectList.isempty()){
                 Boolean tt = true;
                 for(String s : objectList){
                   
                 s=s.toLowerCase();
                    if(ss.contains(s.replace('__c','')))
                       tt=false;
                    }
                  if(tt) newSet.add(ss);  
                    }
                  else{
                  newSet.add(ss);
                  } 
                              
             }
        }
        deleteObjectList.addall(newSet); 
       // deleteObjectList.addall(deleteObjectList);
        if(system.test.isRunningTest())deleteObjectList = new List<Object>{deleteObjectList[0]};
    }
    
    public DeleteAllRecords(){
        moreRecords = false;
        Map<String, Schema.SObjectType> describeAll = Schema.getGlobalDescribe(); 
        set<String> allObjectSet = describeAll.keySet();
        set<Object> undeleteableObjects = new set<Object>{'vote', 'contentdocumentlink', 'groupsubscription', 'profile', 'objectpermissions', 'permissionset', 'emailtemplate', 'group', 'permissionsetassignment', 'fieldpermissions', 'setupentityaccess', 'collaborationgrouprecord', 'ideacomment', 'authsession','loginip','clientbrowser'};
        
        for(String ss : allObjectSet){          
           Schema.DescribeSObjectResult d =  Schema.getGlobalDescribe().get(ss).getDescribe();
             if(d.isQueryable() && d.isdeletable() && !undeleteableObjects.contains(ss.toLowerCase())){
                deleteObjectList.add(ss);            
             }
        }
        //deleteObjectList.addall(deleteObjectList);
        if(system.test.isRunningTest())deleteObjectList = new List<Object>{deleteObjectList[0]};
    }

    public Iterable<Object> start(Database.BatchableContext bc) {
       
        return deleteObjectList;  
    }         
    
    public void execute(Database.BatchableContext BC, List<Object> sc){
        list<sObject> deleteRows = new list<sObject>();
        String s;
        if(sc.size()>0){  
            s = (String) sc.get(0);
            String query = 'select id FROM ';
            if(s == 'PriceBook2'){
                query = query + s +' where IsStandard = false LIMIT 10000';
            }
            else
            query = query + s +' LIMIT 10000';
            
            list<sObject> objectRows = database.query(query);
            if(objectRows.size()>0) deleteRows.addall(objectRows);
            if(objectRows.size()==10000)
            {
             moreRecords =true;
             undeletedObjects.add(s);
             }
        
      
            if(deleteRows.size()>0) {
          try{
          delete deleteRows;
          }
        catch(exception e){
            undeletedObjects.add(s);
        }
        }
        }
    }
    
    public void finish(Database.BatchableContext BC){
    if(deleteObjectList.size()>undeletedObjects.size()||moreRecords)Database.executeBatch(new DeleteAllRecords(undeletedObjects),1);
    }
 }