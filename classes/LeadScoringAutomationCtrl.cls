public with sharing class LeadScoringAutomationCtrl {
	
    @AuraEnabled
    public static WrapperToLWC getLeadandCalculation(String inputFieldName, String inputValue, String inputOperators) {
        WrapperToLWC wrapperReturn = new WrapperToLWC();
        try {
            List<Lead> lstLead = new List<Lead>();
            
            String query = Label.LS_SOQL_GET_LEADS;
            String queryCount = 'Select Count() From Lead';
            String searchValue =  '';
            Integer searchNumber;
            if (!String.isBlank(inputFieldName) && !String.isBlank(inputValue)) {
                if (inputOperators == 'Like') {
                    searchValue =  '%' + inputValue + '%';
                    query += ' Where ' + inputFieldName + ' like: searchValue';
                    queryCount += ' Where ' + inputFieldName + ' like: searchValue';
                } else {
                    if (inputValue.isNumeric()) {
                        searchNumber = Integer.valueOf(inputValue);
                        query += ' Where ' + inputFieldName + ' ' + inputOperators + ': searchNumber';
                        queryCount += ' Where ' + inputFieldName + + ' ' + inputOperators + ': searchNumber';
                    } else {
                        searchValue = inputValue;
                        query += ' Where ' + inputFieldName + ' ' + inputOperators + ': searchValue';
                        queryCount += ' Where ' + inputFieldName + + ' ' + inputOperators + ': searchValue';
                    }
                }
                
            } 
            Integer countLead =  Database.countQuery(queryCount);
            Integer maxRecordsReturn = Integer.valueOf(Label.LS_MAX_RECORDS_RETURN) ;
            if (countLead > 0 && countLead <= maxRecordsReturn) {
                lstLead = LeadScoringAutomationHandler.leadScoring((List<Lead>)Database.query(query));
            } else if (countLead > maxRecordsReturn) {
                String userID = UserInfo.getUserId();
                Datetime runTime = Datetime.Now();
                BatchLeadScoringAutomation batchJob = new BatchLeadScoringAutomation(inputFieldName,inputValue, inputOperators, runTime, userID);
                Id batchJobId = Database.executeBatch(batchJob, Integer.valueOf(Label.LS_BATCH_SIZE));
                wrapperReturn.Message = 'Lead Records are ' + countLead + '. So the calculate will be run with Batchable. A email will send to you when this process complete.';
                 
            }
            
            if (lstLead.size() > 0) {
                update lstLead;
                wrapperReturn.Status = 'Success';
                wrapperReturn.Message = 'Records Updated Successfully!';
                wrapperReturn.lstLeadRerturn = lstLead;
            } else {
                wrapperReturn.Status 	= 'No Leads Return';
                wrapperReturn.Message 	= 'No Leads Return!';
            	wrapperReturn.lstLeadRerturn = null;
            }
            
        } catch (Exception ex) {
            wrapperReturn.Status = 'Failed';
            wrapperReturn.Message = 'Message: ' + ex.getMessage() + ' StackTraceString: ' + ex.getStackTraceString() + '\n';

        }
        
        return wrapperReturn;
        
        
    }
    
    @AuraEnabled
    public static WrapperToLWC searchLeads(String inputFieldName, String inputValue, String inputOperators) {
        WrapperToLWC wrapperReturn = new WrapperToLWC();
        try {
            List<Lead> lstLead = new List<Lead>();
            String query = Label.LS_SOQL_GET_LEADS;
            String queryCount = 'Select Count() From Lead';
            String searchValue =  '';
            Integer searchNumber;
            if (!String.isBlank(inputFieldName) && !String.isBlank(inputValue)) {
                if (inputOperators == 'Like') {
                    searchValue =  '%' + inputValue + '%';
                    query += ' Where ' + inputFieldName + ' like: searchValue';
                    queryCount += ' Where ' + inputFieldName + ' like: searchValue';
                } else {
                    if (inputValue.isNumeric()) {
                        searchNumber = Integer.valueOf(inputValue);
                        query += ' Where ' + inputFieldName + ' ' + inputOperators + ': searchNumber';
                        queryCount += ' Where ' + inputFieldName + + ' ' + inputOperators + ': searchNumber';
                    } else {
                        searchValue = inputValue;
                        query += ' Where ' + inputFieldName + ' ' + inputOperators + ': searchValue';
                        queryCount += ' Where ' + inputFieldName + + ' ' + inputOperators + ': searchValue';
                    }
                    
                }
                
            } 
            Integer countLead =  Database.countQuery(queryCount);
            lstLead = (List<Lead>)Database.query(query);
            
            
            if (lstLead.size() > 0) {
                wrapperReturn.Status 	= 'Success';
                wrapperReturn.Message 	= 'Successfully!';
            	wrapperReturn.lstLeadRerturn = lstLead;
            } else {
                wrapperReturn.Status 	= 'No Leads Return';
                wrapperReturn.Message 	= 'No Leads Return!';
            	wrapperReturn.lstLeadRerturn = null;
            }
            
            
            
            
        } catch (Exception ex) {
            wrapperReturn.Status = 'Failed';
            wrapperReturn.Message = 'Message: ' + ex.getMessage() + ' StackTraceString: ' + ex.getStackTraceString() + '\n';

        }
        
        return wrapperReturn;
        
        
    }
    
    @AuraEnabled
    public static WrapperToLWC calculateAllLeads() {
        WrapperToLWC wrapperReturn = new WrapperToLWC();
        try {
            List<Lead> lstLead = new List<Lead>();
            String query = Label.LS_SOQL_GET_LEADS;
            String userID = UserInfo.getUserId();
            Datetime runTime = Datetime.Now();
            BatchLeadScoringAutomation batchJob = new BatchLeadScoringAutomation(null,null, null, runTime, userID);
            Id batchJobId = Database.executeBatch(batchJob, Integer.valueOf(Label.LS_BATCH_SIZE));
            
            wrapperReturn.Status 	= 'Success';
            wrapperReturn.Message = 'The calculate will be run with Batchable. A email will send to you when this process complete.';

            
        } catch (Exception ex) {
            wrapperReturn.Status = 'Failed';
            wrapperReturn.Message = 'Message: ' + ex.getMessage() + ' StackTraceString: ' + ex.getStackTraceString() + '\n';

        }
        
        return wrapperReturn;
        
        
    }
   
    public class WrapperToLWC{
    @AuraEnabled public String Status {get;set;}
    @AuraEnabled public String Message {get;set;}
    @AuraEnabled public List<Lead> lstLeadRerturn {get;set;}
        
	}
}