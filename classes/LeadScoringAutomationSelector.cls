public class LeadScoringAutomationSelector {
    public static Map<String, Lead_Scoring_Rule__mdt> getMapLeadScoringRules() {
        Map<String, Lead_Scoring_Rule__mdt> mLeadScoringRule = new  Map<String, Lead_Scoring_Rule__mdt>();
        for (Lead_Scoring_Rule__mdt tmpLSR : [Select Developername, Field_Name__c, Score__c, Value__c  from Lead_Scoring_Rule__mdt where isActive__c =  true]) {
            mLeadScoringRule.put(tmpLSR.Field_Name__c + '_' + tmpLSR.Value__c, tmpLSR);
        }
        return mLeadScoringRule;
    }
    
    public static List<Lead_Scoring_Value_Rule__mdt> getLstLeadScoringValueRules() {
        List<Lead_Scoring_Value_Rule__mdt> lstLeadScoringValueRule = new List<Lead_Scoring_Value_Rule__mdt>();
        for (Lead_Scoring_Value_Rule__mdt tmpLSVR : [Select Developername, Field_Name__c, Min__c, Max__c, Value_Return__c   from Lead_Scoring_Value_Rule__mdt where isActive__c =  true]) {
            lstLeadScoringValueRule.add(tmpLSVR);
        }
        return lstLeadScoringValueRule;
    }


}