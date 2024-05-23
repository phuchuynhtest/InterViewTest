public class LeadScoringAutomationHandler {
    private static List<Lead_Scoring_Value_Rule__mdt> lstAnnualRevenue;
    private static List<Lead_Scoring_Value_Rule__mdt> lstNoOfEmployees;
    
    private static String strCompanySize 	= Label.LS_COMPANY_SIZE;
    private static String strIndustry 		= Label.LS_INDUSTRY;
    private static String strAnnualRevenue 	= Label.LS_ANNUAL_REVENUE ;
    private static String strNumberOfEmployees 		= Label.LS_NO_OF_EMPLOYEES;
    private static String strRecentWebsiteActivity 	= Label.LS_RECENT_WEBSITE_ACTIVITY;
    private static String strFormSubmission 		= Label.LS_FORM_SUBMISSIONS;
   
    public static List<Lead> leadScoring(List<Lead> inputLstLead) {
        Map<String, Lead_Scoring_Rule__mdt> mLeadScoringRule 		= LeadScoringAutomationSelector.getMapLeadScoringRules();
        List<Lead_Scoring_Value_Rule__mdt > lstLeadScoringValueRule = LeadScoringAutomationSelector.getLstLeadScoringValueRules();
        lstAnnualRevenue = getLSVRByFieldName(strAnnualRevenue, lstLeadScoringValueRule);
        lstNoOfEmployees = getLSVRByFieldName(strNumberOfEmployees, lstLeadScoringValueRule);
        
        
        List<Lead> lstLeadUpdate = new List<Lead>();
        for (Lead tmpLead : inputLstLead) {
            lstLeadUpdate.add(calculateLeadScoring(tmpLead, mLeadScoringRule));
        }
        
        return lstLeadUpdate;
    }
    
    public static Lead calculateLeadScoring(Lead inputLead, Map<String, Lead_Scoring_Rule__mdt> inputMLeadScoringRule) {
        Lead leadReturn =  inputLead;
        leadReturn.Lead_Scoring__c = 0;
        String keyCompanySize 			= strCompanySize + '_' +inputLead.Company_Size__c;
        if (inputMLeadScoringRule.containsKey(keyCompanySize)) {
            leadReturn.Lead_Scoring__c += inputMLeadScoringRule.get(keyCompanySize).Score__c;
        }
        String keyIndustry 				= strIndustry + '_' +inputLead.Industry;
        if (inputMLeadScoringRule.containsKey(keyIndustry)) {
            leadReturn.Lead_Scoring__c += inputMLeadScoringRule.get(keyIndustry).Score__c;
        }
        String keyAnnualRevenue 		= strAnnualRevenue + '_' + getLeadScoringValueConvert(Integer.valueOf(inputLead.AnnualRevenue), lstAnnualRevenue);
        if (inputMLeadScoringRule.containsKey(keyAnnualRevenue)) {
            leadReturn.Lead_Scoring__c += inputMLeadScoringRule.get(keyAnnualRevenue).Score__c;
        }
        String keyNumberOfEmployees 	= strNumberOfEmployees + '_' + getLeadScoringValueConvert(inputLead.NumberOfEmployees, lstNoOfEmployees);
        if (inputMLeadScoringRule.containsKey(keyNumberOfEmployees)) {
            leadReturn.Lead_Scoring__c += inputMLeadScoringRule.get(keyNumberOfEmployees).Score__c;
        }
        String keyRecentWebsiteActivity = strRecentWebsiteActivity + '_' +inputLead.Recent_website_activity__c;
        if (inputMLeadScoringRule.containsKey(keyRecentWebsiteActivity)) {
            leadReturn.Lead_Scoring__c += inputMLeadScoringRule.get(keyRecentWebsiteActivity).Score__c;
        }
        String keyFormSubmission 		= strFormSubmission + '_' +inputLead.Form_submissions__c ;
        if (inputMLeadScoringRule.containsKey(keyFormSubmission)) {
            leadReturn.Lead_Scoring__c += inputMLeadScoringRule.get(keyFormSubmission).Score__c;
        }
        return leadReturn;
    } 
    
    private static List<Lead_Scoring_Value_Rule__mdt> getLSVRByFieldName(String fieldName, List<Lead_Scoring_Value_Rule__mdt> lstLSVR){
        List<Lead_Scoring_Value_Rule__mdt> lstLSVRReturn = new List<Lead_Scoring_Value_Rule__mdt>();
        for (Lead_Scoring_Value_Rule__mdt tmpLSVR : lstLSVR) {
            if (tmpLSVR.Field_Name__c == fieldName){
                lstLSVRReturn.add(tmpLSVR);
            }
        }
        return lstLSVRReturn;
    }
    
    private static String getLeadScoringValueConvert(Integer inputNumber, List<Lead_Scoring_Value_Rule__mdt> lstLSVR) {
        for (Lead_Scoring_Value_Rule__mdt tmpLSVR : lstLSVR) {
            if ((inputNumber >= tmpLSVR.Min__c && inputNumber < tmpLSVR.Max__c) || (tmpLSVR.Max__c == null && inputNumber >= tmpLSVR.Min__c) ) {
                return tmpLSVR.Value_Return__c;
            }
        }
        return '';
    }
    
    

}