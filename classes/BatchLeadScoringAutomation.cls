public class BatchLeadScoringAutomation implements Database.Batchable<SObject>, Database.Stateful {
    public String fieldName = '';
    public String value = '';
    public String operator;
    public DateTime runTime;
    public String userId;
    public String stringError;
    
    
    
    public BatchLeadScoringAutomation () {
        
    }
    
    public BatchLeadScoringAutomation (String fieldName, String value, String operator, DateTime runTime, String userId) {
        this.fieldName 	= fieldName;
        this.value 		= value;
        this.operator 	= operator;
        this.runTime	= runTime;
        this.userId	= userId;
        this.stringError = '';
        
    }
    
    public Database.QueryLocator start (Database.BatchableContext context) {
        String query = Label.LS_SOQL_GET_LEADS;
        String searchValue =  '';
        Integer searchNumber;
        if (!String.isBlank(fieldName) && !String.isBlank(value)) {
            if (operator == 'Like') {
                searchValue =  '%' + value + '%';
                query += ' Where ' + fieldName + ' like: searchValue';
            } else {
                if (value.isNumeric()) {
                    searchNumber = Integer.valueOf(value);
                    query += ' Where ' + fieldName + ' ' + operator + ': searchNumber';
                } else {
                    searchValue = value;
                    query += ' Where ' + fieldName + ' ' + operator + ': searchValue';
                }
            }
        } 
        return Database.getQueryLocator(query);
    }
    
    public void execute (Database.BatchableContext context, List<Lead> records) {
        try {
            List<Lead> lstLead = new List<Lead>();
            lstLead = LeadScoringAutomationHandler.leadScoring(records);   
            update lstLead;
            
        } catch (Exception ex) {
            stringError += 'Message: ' + ex.getMessage() + ' StackTraceString: ' + ex.getStackTraceString() + '\n';
        }
    }
    
    public void finish (Database.BatchableContext context) {
        User runUser = [Select Id, Name, Email From User Where Id =: userId];
        try {
            String subjectEmail = 'BatchLeadScoringAutomation Run By ' + runUser.Name + ' DateTime ' + runTime;//Can use custom label
            String bodyEmail = '';
            If (String.isBlank(stringError)) {
                bodyEmail += ' Status : Successfull';
            } else {
                bodyEmail += ' Status : Not Success' + '\n' + stringError;
            }
            List<String> toEmails = new List<String>();
            toEmails.add(runUser.Email);
            SendEmailMessages.sendSingleEmailMessage(subjectEmail, toEmails, bodyEmail);

        } catch (Exception ex) {
            String subjectEmail = 'Error in Finish BatchLeadScoringAutomation Run By ' + runUser.Name + ' DateTime ' + runTime;//Can use custom label
            String[] toEmails = new String[] {'huynhduyphuc1994@gmail.com', runUser.Email}; 
            String bodyEmail = 'Message: ' + ex.getMessage() + ' StackTraceString: ' + ex.getStackTraceString() + '\n';
            SendEmailMessages.sendSingleEmailMessage(subjectEmail, toEmails, bodyEmail);
        }
               
        
    }
	
}