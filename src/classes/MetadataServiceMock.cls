/**
 * Date  -  June 2016.
 * Developed by - Dhruvsoft Services Private Limited.         
 * Purpose of Code - This class is used to generate the mock response test the webservices callouts 
 *                   made from the DevLubeContollerTest.
 * Package Version - 1.3 
 **/
public class MetadataServiceMock implements WebServiceMock {
    public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName,String responseType) {
        if (request instanceof MetadataService.readMetadata_element) {
            MetadataService.readMetadata_element rm =  (MetadataService.readMetadata_element) request;
            if(rm.type_x == 'Layout'){
            MetadataService.LayoutItem item1 = new MetadataService.LayoutItem();
            item1.customLink = 'billing';
            MetadataService.LayoutItem item2 = new MetadataService.LayoutItem();
            item2.customLink = 'bill';
            MetadataService.LayoutColumn LayoutColumn = new MetadataService.LayoutColumn();
            LayoutColumn.layoutItems = new MetadataService.LayoutItem[]{item1,item2};
            MetadataService.LayoutSection LayoutSection1 = new MetadataService.LayoutSection();
            LayoutSection1.layoutColumns = new MetadataService.LayoutColumn[]{LayoutColumn}; 
            MetadataService.Layout r1 = new MetadataService.Layout();
            r1.type = 'Layout';
            r1.fullName = 'case-CaseLayout';
            r1.layoutSections = new MetadataService.LayoutSection[]{LayoutSection1};    
            MetadataService.ReadLayoutResult rr = new MetadataService.ReadLayoutResult();
            rr.records = new MetadataService.Layout[]{r1};

      MetadataService.readLayoutResponse_element responseElement = new  MetadataService.readLayoutResponse_element();
            responseElement.result = rr;
       response.put('response_x', responseElement);
            }
            
           
              
             else if(rm.type_x == 'CustomField'){
                MetadataService.CustomField r1 = new MetadataService.CustomField();
                  r1.type = 'CustomField';
                r1.fullName = 'case';
                MetadataService.ReadCustomFieldResult rr = new MetadataService.ReadCustomFieldResult();
                rr.records = new MetadataService.CustomField[]{r1};

        MetadataService.readCustomFieldResponse_element responseElement = new  MetadataService.readCustomFieldResponse_element();
              responseElement.result = rr; 
                 response.put('response_x', responseElement);
            }
            else if(rm.type_x == 'AssignmentRule'){
                MetadataService.AssignmentRule r1 = new MetadataService.AssignmentRule();
                  r1.type = 'AssignmentRule';
                r1.fullName = 'case';
                MetadataService.ReadAssignmentRuleResult rr = new MetadataService.ReadAssignmentRuleResult();
                rr.records = new MetadataService.AssignmentRule[]{r1};

        MetadataService.readAssignmentRuleResponse_element responseElement = new  MetadataService.readAssignmentRuleResponse_element();
              responseElement.result = rr;
                response.put('response_x', responseElement);
            }
            else if(rm.type_x == 'EscalationRule'){
                MetadataService.EscalationRule r1 = new MetadataService.EscalationRule();
                  r1.type = 'AssignmentRule';
                r1.fullName = 'case';
                MetadataService.ReadEscalationRuleResult rr = new MetadataService.ReadEscalationRuleResult();
                rr.records = new MetadataService.EscalationRule[]{r1};

        MetadataService.readEscalationRuleResponse_element responseElement = new  MetadataService.readEscalationRuleResponse_element();
              responseElement.result = rr; 
                response.put('response_x', responseElement);
            }
            else if(rm.type_x == 'WebLink'){
                MetadataService.WebLink r1 = new MetadataService.WebLink();
                  r1.type = 'WebLink';
                r1.fullName = 'case';
                MetadataService.ReadWebLinkResult rr = new MetadataService.ReadWebLinkResult();
                rr.records = new MetadataService.WebLink[]{r1};

        MetadataService.readWebLinkResponse_element responseElement = new  MetadataService.readWebLinkResponse_element();
              responseElement.result = rr;
                response.put('response_x', responseElement);
            }
            else if(rm.type_x == 'SecuritySettings'){
                MetadataService.IpRange ip = new MetadataService.IpRange();
                ip.end_x = '';
                ip.start = '';
                MetadataService.NetworkAccess na = new MetadataService.NetworkAccess();
                MetadataService.IpRange[] iprangess = new list<MetadataService.IpRange>{ip};
                na.ipranges = iprangess;
                MetadataService.SecuritySettings r1 = new MetadataService.SecuritySettings();
                MetadataService.SessionSettings sset = new MetadataService.SessionSettings();
                sset.sessionTimeout='TwoHours';
                  r1.type = 'SecuritySettings';
                r1.fullName = 'Security';
                  r1.networkAccess = na;
                  r1.sessionSettings = sset;
                MetadataService.ReadSecuritySettingsResult rr = new MetadataService.ReadSecuritySettingsResult();
                rr.records = new MetadataService.SecuritySettings[]{r1};

        MetadataService.readSecuritySettingsResponse_element responseElement = new  MetadataService.readSecuritySettingsResponse_element();
              responseElement.result = rr; 
                response.put('response_x', responseElement);

            }
            else {
                
            }
            
        } else if (request instanceof MetadataService.updateMetadata_element) {

            MetadataService.SaveResult result = new MetadataService.SaveResult();
            result.success = true;

            MetadataService.updateMetadataResponse_element responseElement = new MetadataService.updateMetadataResponse_element();
            responseElement.result = new MetadataService.SaveResult[] {result};

            response.put('response_x', responseElement);

        } else if (request instanceof MetadataService.upsertMetadata_element) {

            MetadataService.UpsertResult result = new MetadataService.UpsertResult();
            result.success = true;

            MetadataService.upsertMetadataResponse_element responseElement = new MetadataService.upsertMetadataResponse_element();
            responseElement.result = new MetadataService.UpsertResult[] {result};

            response.put('response_x', responseElement);

        } else if(request instanceof MetadataService.listMetadata_element){
            
           MetadataService.FileProperties result = new MetadataService.FileProperties();
            result.fileName = 'file1';
            result.fullName = 'case';
            result.type_x = 'AssignmentRule';
           
            MetadataService.listMetadataResponse_element responseElement = new MetadataService.listMetadataResponse_element();
            responseElement.result = new MetadataService.FileProperties[] {result};

            response.put('response_x', responseElement); 
            
        } else if(request instanceof MetadataService.deleteMetadata_element){
            
           MetadataService.DeleteResult result = new MetadataService.DeleteResult();
            result.success = true;
            result.fullName = 'case';
            //result.errors = '';
           
            MetadataService.deleteMetadataResponse_element responseElement = new MetadataService.deleteMetadataResponse_element();
            responseElement.result = new MetadataService.DeleteResult[] {result};

            response.put('response_x', responseElement); 
        }
          else {
            System.assert(false, 'Unexpected request ' + request);
        }
    }
}