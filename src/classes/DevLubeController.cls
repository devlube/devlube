/**
 * Date  -  June 2016.
 * Developed by - Dhruvsoft Services Private Limited (www.dhruvsoft.com).         
 * Purpose of Code - This class is used to refresh the new developer org. It deletes all the Data, Assignment Rules,
 *                   Escalation Rules,all PageLayouts (Except Master Layouts), Custom Links, Custom Buttons,
 *                   Custom Fields, Custom Objects, Visualforce Pages, Apex Classes included in the org and 
 *                   adding IP Address to whitelisted IP Addresses.
 * Package Version - 1.3 
 **/
public with sharing class DevLubeController {
    public Boolean dataDeletion {get; set;}
    public Boolean remoteSite {get; set;}
    public Boolean customfieldsDeletion {get; set;}
    public Boolean customPagesDeletion {get; set;}
    public Boolean customLinksButtonsDeletion {get; set;}
    public Boolean rulesDeletion {get; set;}
    public Boolean class_PageDeletion {get; set;}
    public Boolean customObjectDeletion {get; set;}
    public Boolean addMyIP {get; set;}
    public String rssname{get;set;}
    public String rssDescription{get;set;}
    public Boolean showblock{get;set;}
    public Id batchId ;
    public Boolean showmg {get;set;}
    public Boolean showmg1 {get;set;}
    public String Host {get;set;}
    public String rssNameString {get;set;}
    public Map<String,Schema.SObjectType> gd = new Map<String,Schema.SObjectType>();
    public MetadataService.layout[] allReadLayouts = new List<MetadataService.layout>();
    public String destructiveChangesXml;
    Public String zipData {get;set;}
    public MetadataService.AsyncResult asyncResult{get; set;}
    public String ipAdd;
    public List<String> customObjectNameList;
    public Boolean stop {get; set;}
    public Boolean deployError { get; set;}
    public String deployErrorMsg { get; set;} 
    public Boolean showblock1 {get;set;}
    public Integer calloutCount;
    public Set<String> deletedObjects;
    public String getDestructiveChangesXml1(){
        return destructiveChangesXml;
    }
    
    public String getPackageXml()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' + 
            '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
                '<version>35.0</version>' + 
            '</Package>';       
    }

    public DevLubeController() {
        deletedObjects = new set<String>();
        PermissionSet useracccess = [SELECT PermissionsModifyAllData, Id, Name, UserLicenseId, ProfileId FROM PermissionSet where profileId=:userinfo.getProfileId()];
        calloutCount = 1;
        deployError = false;
        remoteSite = true;
        Host = ApexPages.currentPage().getHeaders().get('Host');
        rssname='My_Server';
        rssDescription = 'This remote site is to access the Metadata API';
        showmg = false;
        showmg1 = false;
        showblock = false;
        IpAdd = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if(IpAdd==null)IpAdd = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        if(useracccess.PermissionsModifyAllData==false){
        showblock1 = true;
        
        }
        dataDeletion = true; 
       customfieldsDeletion = true;
       customPagesDeletion = true;
       customLinksButtonsDeletion = true;
       rulesDeletion = true;
       class_PageDeletion = true;
       customObjectDeletion = true;
       addMyIP = true;
    }
        
    public pagereference doReferesh(){
        pagereference pg = new pagereference('/apex/DevLube');
        pg.setredirect(true);
        return pg;
    } 
      
    public pagereference batchDelete(){
        doreferesh();
        showmg1 = false;
        if(dataDeletion){
        delete [SELECT id from solution limit 100];
        delete [SELECT id from Case limit 100];
        delete [SELECT id from Order limit 100];
        delete [SELECT id from contract limit 100];
        delete [SELECT id from opportunity limit 100];
        delete [SELECT id from pricebookentry limit 100];
        delete [SELECT id from Pricebook2 where isstandard=false limit 100];
        delete [SELECT id from product2 limit 100];
        delete [SELECT id from contact limit 100];
        delete [SELECT id from Account limit 100];
        delete [SELECT id from lead limit 100];
        delete [SELECT id from campaign limit 100];
        
           if(class_PageDeletion) 
            batchId = Database.executeBatch(new DeleteAllRecords(deletedObjects), 1);
            else
            batchId = Database.executeBatch(new DeleteAllRecords(), 1);
            showmg1 = true;
        }      
        return null;
    } 
    //=========== Once the page loads the Destructive Changes Zipfile is generated with the  ==============//
    //============== classes,visualforce pages and custom objects which are to be deleted =================//
    public void addDestructiveChanges(){
    //=========== Queries all the fullnames of classes,visualforce pages and custom objects.===============//
    //=========== It fails, if Salesforce Server Host is not addded to the remote site settings.===========//
    //=========== This Exception is handled and requests the user to add the remote site. =================//      
    try{
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries6 = new List<MetadataService.ListMetadataQuery>();
        List<MetadataService.ListMetadataQuery> queries7 = new List<MetadataService.ListMetadataQuery>();    
        List<MetadataService.ListMetadataQuery> queries8 = new List<MetadataService.ListMetadataQuery>();
        MetadataService.ListMetadataQuery queryApexClass = new MetadataService.ListMetadataQuery();
        queryApexClass.type_x = 'ApexClass';
        queries6.add(queryApexClass);
        MetadataService.ListMetadataQuery queryApexPage = new MetadataService.ListMetadataQuery();
        queryApexPage.type_x = 'ApexPage';
        queries7.add(queryApexPage);
        MetadataService.ListMetadataQuery queryCustomObject = new MetadataService.ListMetadataQuery();
        queryCustomObject.type_x = 'CustomObject';
        queries8.add(queryCustomObject);
        DestructiveChangesXml = '<?xml version="1.0" encoding="UTF-8"?>' + 
                                       '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' ;
        String[] apexClassNameList = new List<string>();
        String[] apexPageNameList = new List<string>();
                
        if(!queries6.isempty()){
            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries6,37);
            if(fileProperties!= null){
                for(MetadataService.FileProperties fileProperty : fileProperties){
                   if(fileProperty.manageableState=='unmanaged')
                    apexClassNameList.add(fileProperty.fullName);
                }
                }
        }  
        if(!queries7.isempty()){
            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries7,37);
            if(fileProperties!= null){
                for(MetadataService.FileProperties fileProperty : fileProperties){
                   if(fileProperty.manageableState=='unmanaged')
                    apexPageNameList.add(fileProperty.fullName);
                }    
            }
        }   
        if(apexClassNameList.size()>0){
            DestructiveChangesXml=DestructiveChangesXml+'<types>';
            for(String className : apexClassNameList){
                DestructiveChangesXml=DestructiveChangesXml+'<members>'+className+'</members>';
            }
            DestructiveChangesXml=DestructiveChangesXml+'<name>ApexClass</name>' + 
                                          '</types>' ;
        }
        if(apexPageNameList.size()>0){
            DestructiveChangesXml=DestructiveChangesXml+'<types>';
            for(String pageName : apexPageNameList){
                DestructiveChangesXml=DestructiveChangesXml+'<members>'+pageName+'</members>';
            }
            DestructiveChangesXml=DestructiveChangesXml+'<name>ApexPage</name>' + 
                                          '</types>' ;
        }
           
        customObjectNameList = new List<String>();
               
        if(!queries8.isempty()){
            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries8,37);
            if(fileProperties!= null){
                for(MetadataService.FileProperties fileProperty : fileProperties){
                   if(fileProperty.manageableState=='unmanaged')
                    customObjectNameList .add(fileProperty.fullName);
                    
                }
                deletedObjects.addall(customObjectNameList);
               
            }
        }    
        if(customObjectNameList.size()>0){
            DestructiveChangesXml=DestructiveChangesXml+'<types>';
            for(String objectName : customObjectNameList){
                DestructiveChangesXml=DestructiveChangesXml+'<members>'+objectName+'</members>';
                }
            DestructiveChangesXml=DestructiveChangesXml+'<name>CustomObject</name>' + 
                                          '</types>' ;
        }

        DestructiveChangesXml=DestructiveChangesXml+'<version>35.0</version>' + 
                              '</Package>'; 
                           
                              
    }
    catch(calloutException c){
          showblock = true;
          
    }                            
    }
  
    public void listMetadata()
    {  
        deployError = false;
        stop=false;
        showmg = false;
        showmg1 = false;
        if(dataDeletion==false && rulesDeletion==false && class_PageDeletion==false && customPagesDeletion==false && customLinksButtonsDeletion==false && customfieldsDeletion==false && addMyIP==false){
            
            stop=true;
        }
        else{
       if(!showblock){ 
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
        Set<String> donotDeleteLayouts = new Set<String>{'CaseClose-Close Case Layout','DandBCompany-D%26B Company Layout','SocialPersona-Social Persona Layout','SocialPost-Social Post Layout','Global-Global Layout','CampaignMember-Campaign Member Page Layout'};
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
       
        //=============== Removing Custom Buttons and Links from PageLayouts before deleting Buttons and Links =============//
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
                 
                }
                if(layouts!=null) {
                List<MetadataService.Metadata> metadataList = (List<MetadataService.Metadata>) layouts;
                updateMetadataComponents(service, metadataList);
                }
            }
        //================================== Deletion of WebLinks =================================//
        String[] webLinkNames = getFullNameList(service, queries4);
        if(webLinkNames!=null && customLinksButtonsDeletion==true){        
            deleteMetadataComponents(service, 'WebLink', webLinkNames);
        }
       
        //========================== Adding IP Address to WhiteListed IP Addresses ================//

        if(addMyIP == true){
         
            String[] securitySettingsList = new List<string>{'Security'};
            List<MetadataService.SecuritySettings> updateSecuritySettings = new List<MetadataService.SecuritySettings>();   
            MetadataService.SecuritySettings[] securitySettingsInfo = readSecuritySettingsComponents(service, 'SecuritySettings',securitySettingsList);
            for(MetadataService.SecuritySettings sett : securitySettingsInfo){
                MetadataService.SecuritySettings newSett = new MetadataService.SecuritySettings();
                newSett = sett;
                MetadataService.NetworkAccess networkAcc = sett.networkAccess;
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
                   
                    newIp.start = IpAdd;
                    newIp.end_x = IpAdd;
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
        
                
    }
    }
    }
    
    public pagereference licenceTxt(){
        pageReference pg = new pageReference('/apex/LicenseText');
        return pg;
    }
    
    public PageReference deployZip(){
    if(calloutCount<99){
        calloutCount = calloutCount+1;
        // Deploy zip file posted back from the page action function                
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = true;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = true;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = true;
        deployOptions.rollbackOnError = true;
        deployOptions.testLevel = 'NoTestRun';
        deployOptions.singlePackage = true;
          
        if(class_PageDeletion && ZipData!=null){
        asyncResult = service.deploy(ZipData, DeployOptions); 
        }
        showmg = true; 
      }  
           
        return null;
    }
    
    public PageReference checkAsyncRequest()
    {   
    if(calloutCount<99){
        calloutCount = calloutCount+1;
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(AsyncResult.Id, true);
        if(deployResult.done)
        {
           
            if(deployResult.details!=null && deployResult.details.componentFailures!=null)
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
                    if(deployMessage.problem!=null){
                            deployError = true;
                            deployErrorMsg = deployMessage.fileName +  deployMessage.problem;
                                 
                    }
            AsyncResult = null;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
        }
    }   
        return null;
        
    }
 
    public List<MetadataService.SecuritySettings> readSecuritySettingsComponents(MetadataService.MetadataPort service, String metadataType, String[] fullNameList){
    if(calloutCount<99){
        calloutCount = calloutCount+1;
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
     return null;   
    }

    public List<MetadataService.layout> readLayoutComponents(MetadataService.MetadataPort service, String metadataType, String[] fullNameList){
    if(calloutCount<99){
        calloutCount = calloutCount+1;
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
     return null;
    }

    public void updateMetadataComponents(MetadataService.MetadataPort service, List<MetadataService.Metadata> metadataList){
    if(calloutCount<99){
        calloutCount = calloutCount+1;
        if(!metadataList.isEmpty()){
            List<MetadataService.Metadata> tempList = new List<MetadataService.Metadata>();
            for(integer i = 0; i< metadataList.size(); i++){
                tempList.add(metadataList.get(i));
                if(tempList.size() == 10){
                    service.updateMetadata(tempList);
                    tempList = new List<MetadataService.Metadata>();
                }
            }
            if(tempList.size() != 10 || tempList.size() != 0)   service.updateMetadata(tempList);
        }
     }   
    }

    public void deleteMetadataComponents(MetadataService.MetadataPort service, String metadataType, String[] fullNameList){
    if(calloutCount<99){
        calloutCount = calloutCount+1;
        if(!fullNameList.isEmpty()){
            List<String> tempList = new List<String>();
            for(integer i = 0; i< fullNameList.size(); i++){
                tempList.add(fullNameList.get(i));
                if(tempList.size() == 10){
                    service.deleteMetadata(metadataType, tempList);
                    tempList = new List<String>();
                }
            }
            if(tempList.size() != 10 || tempList.size() != 0)   service.deleteMetadata(metadataType, tempList);
        }
     }
    }

    public List<String> getFullNameList (MetadataService.MetadataPort service, List<MetadataService.ListMetadataQuery> queries){
    if(calloutCount<99){
        calloutCount = calloutCount+1;
        String[] fullNameList = new List<String>();
        if(!queries.isempty()){
            MetadataService.FileProperties[] fileProperties = service.listMetadata(queries,37);
            if(fileProperties!= null){
                for(MetadataService.FileProperties fileProperty : fileProperties){
                    fullNameList.add(fileProperty.fullName);
                }
            return fullNameList;
            }
        }
      }  
        return null;
    
    }

    public MetadataService.MetadataPort createService()
    { 
     if(calloutCount<99){
        calloutCount = calloutCount+1;
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
    return null;
    }
}