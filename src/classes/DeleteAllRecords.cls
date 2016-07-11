public class DeleteAllRecords implements Database.Batchable<string> {
public list<String> deleteObjectList = new List<string>();

    public DeleteAllRecords(List<String> objectList){
        deleteObjectList.addall(objectList);
    }

    public DeleteAllRecords(){
        
    }


    public Iterable<string> start(Database.BatchableContext bc) {
        Map<String, Schema.SObjectType> describeAll = Schema.getGlobalDescribe(); 
        set<String> allObjectSet = describeAll.keySet();
        set<String> undeleteableObjects = new set<String>{'vote', 'contentdocumentlink', 'profile', 'objectpermissions', 'permissionset', 'emailtemplate', 'group', 'permissionsetassignment', 'fieldpermissions', 'setupentityaccess', 'collaborationgrouprecord', 'ideacomment', 'authsession'};
        
        for(String ss : allObjectSet){          
           Schema.DescribeSObjectResult d =  Schema.getGlobalDescribe().get(ss).getDescribe();
             if(d.isQueryable() && d.isdeletable() && !undeleteableObjects.contains(ss.toLowerCase())){
                deleteObjectList.add(ss);            
             }
        }
        deleteObjectList.addall(deleteObjectList);
        return deleteObjectList;	
    }         
    
    public void execute(Database.BatchableContext BC, List<String> sc){
        list<sobject> deleteRows = new list<sobject>();
      
        if(sc.size()>0){  
            String query = 'select id from ';
            if(sc[0] == 'PriceBook2'){
                query = query + sc[0] +' where IsStandard = false';
            }
            else
            query = query + sc[0];
            
            list<sobject> objectRows = database.query(query);
            if(objectRows.size()>0) deleteRows.addall(objectRows); 
        }
    	
      if(deleteRows.size()>0) delete deleteRows;
    }
    
    public void finish(Database.BatchableContext BC){
    
    }
 }