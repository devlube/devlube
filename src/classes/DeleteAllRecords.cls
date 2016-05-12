public class DeleteAllRecords implements Database.Batchable<string> {

    public Iterable<string> start(Database.BatchableContext bc) {
        Map<String, Schema.SObjectType> describeAll = Schema.getGlobalDescribe(); 
        set<string> allObjectSet = describeAll.keySet();
        list<string> deleteObjectList = new List<string>();
        for(string ss : allObjectSet){          
           Schema.DescribeSObjectResult d =  Schema.getGlobalDescribe().get(ss).getDescribe();
             if(d.isQueryable() && d.isdeletable() && ss!='vote' && ss!='ContentDocumentLink' && ss!='profile' && ss!='objectpermissions' && ss!='PermissionSet' && ss!='emailtemplate'&& ss!='Group' && ss!='permissionsetassignment' && ss!='fieldpermissions'&&ss!='setupentityaccess'&&ss!='CollaborationGroupRecord'&&SS!='ideacomment'&&ss!='AuthSession'){
                deleteObjectList.add(ss);            
             }
        }
        deleteObjectList.addall(deleteObjectList);
        return deleteObjectList;	
    }         
    
    public void execute(Database.BatchableContext BC, list<string> sc){
        list<sobject> deleteRows = new list<sobject>();
        for(string s : sc){
            string query = 'select id from ';
            if(s == 'PriceBook2'){
                query = query + s +' where IsStandard = false';
            }
            else
            query = query + s;
            
            list<sobject> objectRows = database.query(query);
            if(objectRows.size()>0) deleteRows.addall(objectRows); 

    	}
      if(deleteRows.size()>0) delete deleteRows;
    }
    
    public void finish(Database.BatchableContext BC){
    
    }
 }