public with sharing class DevLubeController {
    public boolean dataDeletion {get; set;}
    public boolean customfieldsDeletion {get; set;}
    public boolean customPagesDeletion {get; set;}
    public boolean customLinksButtonsDeletion {get; set;}
    public boolean rulesDeletion {get; set;}
    public boolean class_PageDeletion {get; set;}
    public boolean customObjectDeletion {get; set;}
    public boolean addMyIP {get; set;}
    public Boolean batchStatusBool {get;set;}
    public String batchStatus {get;set;}
    public String rssname{get;set;}
    public String rssDescription{get;set;}
    Id batchId ;
    public Boolean pollerBool {get;set;}
    public Boolean showmg {get;set;}
    public String Host {get;set;}
    public String rssNameString {get;set;}
    public Map<String,Schema.SObjectType> gd = new Map<String,Schema.SObjectType>();
    public MetadataService.layout[] allReadLayouts = new List<MetadataService.layout>();

    public DevLubeController() {
       dataDeletion = true; 
       customfieldsDeletion = true;
       customPagesDeletion = true;
       customLinksButtonsDeletion = true;
       rulesDeletion = true;
       class_PageDeletion = true;
       customObjectDeletion = true;
       addMyIP = true;
        batchStatusBool = false;
        pollerBool = false;
        Host = ApexPages.currentPage().getHeaders().get('Host');
        rssname='My_Server';
        rssDescription = 'This remote site is to access the Metadata API';
        showmg = false;
        
        }

  
    public void listMetadata()
    {
      
        MetadataService.MetadataPort service = createService(); 
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();      
        List<MetadataService.ListMetadataQuery> queries1 = new List<MetadataService.ListMetadataQuery>(); 
        List<MetadataService.ListMetadataQuery> queries2 = new List<MetadataService.ListMetadataQuery>();  
        List<MetadataService.ListMetadataQuery> queries3 = new List<MetadataService.ListMetadataQuery>();
        List<MetadataService.ListMetadataQuery> queries4 = new List<MetadataService.ListMetadataQuery>(); 
        List<MetadataService.ListMetadataQuery> queries5 = new List<MetadataService.ListMetadataQuery>();    
           
        MetadataService.ListMetadataQuery queryCustomFields = new MetadataService.ListMetadataQuery();
        queryCustomFields.type_x = 'CustomField';
        queries.add(queryCustomFields); 
        MetadataService.ListMetadataQuery queryAssignmentRules = new MetadataService.ListMetadataQuery();
        queryAssignmentRules.type_x = 'AssignmentRule';
        queries1.add(queryAssignmentRules); 
        MetadataService.ListMetadataQuery queryEscalationRules = new MetadataService.ListMetadataQuery();
        queryEscalationRules.type_x = 'EscalationRule';
        queries2.add(queryEscalationRules); 
        MetadataService.ListMetadataQuery queryPageLayouts = new MetadataService.ListMetadataQuery();
        queryPageLayouts.type_x = 'Layout';
        queries3.add(queryPageLayouts); 
        MetadataService.ListMetadataQuery queryWebLinks = new MetadataService.ListMetadataQuery();
        queryWebLinks.type_x = 'WebLink';
        queries4.add(queryWebLinks);
        MetadataService.ListMetadataQuery querySecuritySettings = new MetadataService.ListMetadataQuery();
        querySecuritySettings.type_x = 'Settings';
        queries5.add(querySecuritySettings);
        
        String[] assignmentNameList = getFullNameList(service, queries1);
        String[] fieldNameList = getFullNameList(service, queries);
        String[] escalationNameList = getFullNameList(service, queries2);
        String[] pageLayoutsNameList = getFullNameList(service, queries3);
        Set<String> pageLayoutsNameset = new Set<String>();
        set<String> donotDeleteLayouts = new Set<String>{'CaseClose-Close Case Layout','DandBCompany-D%26B Company Layout','SocialPersona-Social Persona Layout','SocialPost-Social Post Layout','Global-Global Layout','CampaignMember-Campaign Member Page Layout'};
        for(string s : pageLayoutsNameList){
            pageLayoutsNameset.add(s);
            }
        Set<String> masterLayoutObjects = new Set<String>();
            
        for(String layoutName : pageLayoutsNameList){
            if(string.isNotBlank(layoutName) ){
                    List<String> parts = layoutName.split('-');
                        if(parts.size()>1){
                           if(parts[0].trim()!='CaseClose') masterLayoutObjects.add(parts[0].trim()); 
                        }
                }
            }
        List<String> masterLayouts = new List<String>(masterLayoutObjects);
        system.debug(masterLayouts);
       
        gd = Schema.getGlobalDescribe();
        for(String obj : masterLayouts){
            Schema.SObjectType sobjType = gd.get(obj);
            if(sobjType!=null){ 
                Schema.DescribeSObjectResult res =  sobjType.getDescribe();
                pageLayoutsNameset.remove(res.getName()+'-'+res.getLabel()+' Layout'); 
            }
        }
        pageLayoutsNameset.removeall(donotDeleteLayouts);    
        List<String> nonMasterLayoutObjects = new List<String>(pageLayoutsNameset); 
      
        if(assignmentNameList!=null && rulesDeletion==true) deleteMetadataComponents(service, 'AssignmentRule', assignmentNameList);
        if(escalationNameList!=null && rulesDeletion==true) deleteMetadataComponents(service, 'EscalationRule', escalationNameList);
       
        if(nonMasterLayoutObjects!=null && customPagesDeletion==true) deleteMetadataComponents(service, 'Layout', nonMasterLayoutObjects);
       
        if(customLinksButtonsDeletion==true){
            String[] updateLayoutNames = getFullNameList(service, queries3); 
            List<MetadataService.Layout> layouts = new List<MetadataService.Layout>();   
            MetadataService.layout[] s1 = readLayoutComponents(service, 'Layout',updateLayoutNames);
                for(MetadataService.Layout f : s1){
                    Boolean addd = false;
                    MetadataService.Layout newLayout = new MetadataService.Layout();   
                    MetadataService.LayoutSection[] layoutSec = f.layoutSections;
                    MetadataService.LayoutSection[] newlayoutSeclist = new List<MetadataService.LayoutSection>(); 
                    if(layoutSec!=null){   
                        for(MetadataService.LayoutSection layoutSec1 : layoutSec){
                            MetadataService.LayoutSection newlayoutSec = new MetadataService.LayoutSection();
                            MetadataService.LayoutColumn[] layoutColumn = layoutSec1.layoutColumns; 
                            MetadataService.LayoutColumn[] newlayoutColumnList = new List<MetadataService.LayoutColumn>();
                            for(MetadataService.LayoutColumn layoutColumn1 : layoutColumn){
                                MetadataService.LayoutColumn newColumn = new MetadataService.LayoutColumn();
                                MetadataService.LayoutItem[] layoutItem = layoutColumn1.LayoutItems;
                                MetadataService.LayoutItem[] newlayoutItemList = new List<MetadataService.LayoutItem>();
                                if(layoutItem!=null){
                                    for(MetadataService.LayoutItem layoutItem1 : layoutItem){
                                        if(layoutItem1!=null){                       
                                            if(layoutItem1.customlink!=null){                         
                                              layoutItem1 = null; 
                                              addd = true;                                              
                                            }
                                            else{                            
                                              newlayoutItemList.add(layoutItem1);  
                                            }
                                        }
                                    }
                                }
                                if(newlayoutItemList!=null){
                                    newColumn.layoutItems=newlayoutItemList;
                                    newColumn.reserved=layoutColumn1.reserved;
                                }
                                if(newColumn!=null) newlayoutColumnList.add(newColumn);
                            }
                            if(newlayoutColumnList!=null){
                                newlayoutSec.layoutColumns = newlayoutColumnList;
                                newlayoutSec.customLabel = layoutSec1.customLabel;
                                newlayoutSec.detailHeading = layoutSec1.detailHeading;
                                newlayoutSec.editHeading = layoutSec1.editHeading;
                                newlayoutSec.label = layoutSec1.label;
                                newlayoutSec.style = layoutSec1.style;
                            }
                            if(newlayoutSec!=null )  newlayoutSeclist.add(newlayoutSec);
                        }
                        if(newlayoutSeclist!=null) { 
                            newLayout.layoutSections = newlayoutSeclist;
                            newLayout.fullName =  f.fullName; 
                            newLayout.type = f.type;
                            if(f.customButtons!=null){
                                system.Debug(f.customButtons);
                                newLayout.customButtons = null;
                                addd = true;
                            } 
                            newLayout.customConsoleComponents = f.customConsoleComponents;
                            newLayout.emailDefault = f.emailDefault;
                            newLayout.excludeButtons = f.excludeButtons;
                            newLayout.feedLayout = f.feedLayout;
                            newLayout.miniLayout = f.miniLayout;
                            newLayout.multilineLayoutFields = f.multilineLayoutFields;
                            newLayout.platformActionList = f.platformActionList;
                            newLayout.quickActionList = f.quickActionList;
                            newLayout.relatedContent = f.relatedContent;
                            newLayout.relatedLists = f.relatedLists;
                            newLayout.relatedObjects = f.relatedObjects;
                            newLayout.runAssignmentRulesDefault = f.runAssignmentRulesDefault;
                            newLayout.showEmailCheckbox = f.showEmailCheckbox;
                            newLayout.showHighlightsPanel = f.showHighlightsPanel;
                            newLayout.showInteractionLogPanel = f.showInteractionLogPanel;
                            newLayout.showKnowledgeComponent = f.showKnowledgeComponent;
                            newLayout.showRunAssignmentRulesCheckbox = f.showRunAssignmentRulesCheckbox;
                            newLayout.showSolutionSection = f.showSolutionSection;
                            newLayout.showSubmitAndAttachButton = f.showSubmitAndAttachButton;
                            newLayout.summaryLayout = f.summaryLayout;
                        }
                    }    
                    if(newLayout!=null && addd == true)layouts.add(newLayout);
                    system.debug(layouts);
                }
                if(layouts!=null) {
                List<MetadataService.Metadata> metadataList = (List<MetadataService.Metadata>) layouts;
                updateMetadataComponents(service, metadataList);
                }
            }
        //==============================Delete WebLinks =============================//
        String[] webLinkNames = getFullNameList(service, queries4);
        if(webLinkNames!=null && customLinksButtonsDeletion==true){        
            deleteMetadataComponents(service, 'WebLink', webLinkNames);
        }
       
        //========================== Adding IP Address to WhiteListed IP Addresses ================//

        if(addMyIP == true){
           string IpAdd = '';
           IpAdd = ApexPages.currentPage().getHeaders().get('True-Client-IP');
           if (IpAdd == '') 
            IpAdd = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            String[] securitySettingsList = new List<string>{'Security'};
            List<MetadataService.SecuritySettings> updateSecuritySettings = new List<MetadataService.SecuritySettings>();   
            MetadataService.SecuritySettings[] securitySettingsInfo = readSecuritySettingsComponents(service, 'SecuritySettings',securitySettingsList);
            for(MetadataService.SecuritySettings sett : securitySettingsInfo){
                MetadataService.SecuritySettings newSett = new MetadataService.SecuritySettings();
                newSett = sett;
                MetadataService.NetworkAccess networkAcc= sett.networkAccess;
                if(networkAcc!=null){
                    MetadataService.IpRange[] ipRanges1 = networkAcc.ipRanges;
                    if(ipRanges1!=null){
                    MetadataService.IpRange newIp = new MetadataService.IpRange();
                    newIp.description = 'Added through DevLube';
                    newIp.start = IpAdd;
                    newIp.end_x = IpAdd;
                    ipRanges1.add(newIp);
                    newSett.networkAccess.ipRanges=ipRanges1;
                    newSett.sessionSettings.sessionTimeout='TwoHours';
                }
                
                else{
                    MetadataService.IpRange[] ipRanges2 = new List<MetadataService.IpRange>(); 
                    MetadataService.IpRange newIp = new MetadataService.IpRange();
                    newIp.description = 'Added through DevLube';
                    newIp.start = '49.206.51.251';
                    newIp.end_x = '49.206.51.251';
                    ipRanges2.add(newIp);
                    newSett.networkAccess.ipRanges=ipRanges2;
                    newSett.sessionSettings.sessionTimeout='TwoHours';
                }
            }
            updateSecuritySettings.add(newSett);

            }
            if(updateSecuritySettings!=null) {
            List<MetadataService.Metadata> metadataList = (List<MetadataService.Metadata>) updateSecuritySettings;
            updateMetadataComponents(service, metadataList);
            }
            
        } 

        //========================= Deletion of Custom Fields================================================//
         if(fieldNameList!=null && customfieldsDeletion==true) deleteMetadataComponents(service, 'CustomField', fieldNameList);
        
        //=========================Deletion of All Data Using Batch==========================================//
        if(dataDeletion && !test.isRunningTest()){
            batchStatusBool = true;
            batchId = Database.executeBatch(new DeleteAllRecords(), 1);
            checkBatchStatus();
            }

    }

public pagereference checkBatchStatus() {
        AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems FROM AsyncApexJob WHERE Id =: batchId];
        
        if(job.Status == 'Completed' || job.Status == 'Aborted') {
            showmg = true;
            batchStatus = job.Status;
           // batchStatusBool = false;
            pollerBool = false;
            
        } else {
            pollerBool = true;
            batchStatus = job.Status+' '+job.JobItemsProcessed+' of '+job.TotalJobItems+'. Please wait for 2 to 5 mins';
        }
        return null;
    }

    public List<MetadataService.SecuritySettings> readSecuritySettingsComponents(MetadataService.MetadataPort service, String metadataType, String[] fullNameList){
        MetadataService.SecuritySettings[] readSecuritySettings = new List<MetadataService.SecuritySettings>();
        if(!fullNameList.isEmpty()){
            List<String> tempList = new List<String>();
            for(integer i = 0; i< fullNameList.size(); i++){
                tempList.add(fullNameList.get(i));
                if(tempList.size() == 10){
                    readSecuritySettings.addall((List<MetadataService.SecuritySettings>) service.readMetadata(metadataType,tempList).getRecords());
                    tempList = new List<String>();
                }
            }
            if(tempList.size() != 10 || tempList.size() != 0)    readSecuritySettings.addall((List<MetadataService.SecuritySettings>) service.readMetadata(metadataType,tempList).getRecords());
        }
        return readSecuritySettings;
    }

    public List<MetadataService.CustomObject> readObjectComponents(MetadataService.MetadataPort service, String metadataType, String[] fullNameList){
        MetadataService.CustomObject[] readObjectResult = new List<MetadataService.CustomObject>();
        if(!fullNameList.isEmpty()){
            List<String> tempList = new List<String>();
            for(integer i = 0; i< fullNameList.size(); i++){
                tempList.add(fullNameList.get(i));
                if(tempList.size() == 10){
                    readObjectResult.addall((List<MetadataService.CustomObject>) service.readMetadata(metadataType,tempList).getRecords());
                    tempList = new List<String>();
                }
            }
            if(tempList.size() != 10 || tempList.size() != 0)    readObjectResult.addall((List<MetadataService.CustomObject>) service.readMetadata(metadataType,tempList).getRecords());
        }
        return readObjectResult;
    }

    public List<MetadataService.layout> readLayoutComponents(MetadataService.MetadataPort service, String metadataType, String[] fullNameList){
        MetadataService.layout[] readLayoutsResult = new List<MetadataService.layout>();
        if(!fullNameList.isEmpty()){
            List<String> tempList = new List<String>();
            for(integer i = 0; i< fullNameList.size(); i++){
                tempList.add(fullNameList.get(i));
                if(tempList.size() == 10){
                    readLayoutsResult.addall((List<MetadataService.Layout>) service.readMetadata(metadataType,tempList).getRecords());
                    tempList = new List<String>();
                }
            }
            if(tempList.size() != 10 || tempList.size() != 0)    readLayoutsResult.addall((List<MetadataService.Layout>) service.readMetadata(metadataType,tempList).getRecords());
        }
        return readLayoutsResult;
    }

    public void updateMetadataComponents(MetadataService.MetadataPort service, List<MetadataService.Metadata> metadataList){
        if(!metadataList.isEmpty()){
            List<MetadataService.Metadata> tempList = new List<MetadataService.Metadata>();
            for(integer i = 0; i< metadataList.size(); i++){
                tempList.add(metadataList.get(i));
                if(tempList.size() == 10){
                    System.debug(service.updateMetadata(metadataList));
                    tempList = new List<MetadataService.Metadata>();
                }
            }
            if(tempList.size() != 10 || tempList.size() != 0)   System.debug(service.updateMetadata(metadataList));
        }
    }

    public void deleteMetadataComponents(MetadataService.MetadataPort service, String metadataType, String[] fullNameList){
        if(!fullNameList.isEmpty()){
            List<String> tempList = new List<String>();
            for(integer i = 0; i< fullNameList.size(); i++){
                tempList.add(fullNameList.get(i));
                if(tempList.size() == 10){
                    System.debug(service.deleteMetadata(metadataType, tempList));
                    tempList = new List<String>();
                }
            }
            if(tempList.size() != 10 || tempList.size() != 0)   System.debug(service.deleteMetadata(metadataType, tempList));
        }
    }

    public List<String> getFullNameList (MetadataService.MetadataPort service, List<MetadataService.ListMetadataQuery> queries){
        String[] fullNameList = new List<String>();
        if(!queries.isempty()){
            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 36);
            if(fileProperties!= null){
                for(MetadataService.FileProperties fileProperty : fileProperties){
                    System.debug(fileProperty.fullName);
                    fullNameList.add(fileProperty.fullName);
                }
            return fullNameList;
            }
        }
        return null;
    }

    public MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}