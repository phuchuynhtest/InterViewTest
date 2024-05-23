@isTest
public class LeadScoringAutomationCtrlTest {
    
    @testSetup static void testData() {
        List<Lead> lstLeads = TestFactoryLS.createLeads(15);
        
	}
    
    @isTest static void testcalculateAllLeads(){
        Test.startTest();
        LeadScoringAutomationCtrl.calculateAllLeads();
        Test.stopTest();
    }
    
    @isTest static void testGetLeadandCalculationName(){
        Test.startTest();
        LeadScoringAutomationCtrl.getLeadandCalculation('Name', 'a', 'Like');
        LeadScoringAutomationCtrl.searchLeads('Name', 'a', 'Like');
        Test.stopTest();
    }
    
    @isTest static void testGetLeadandCalculationAnnualRevenue(){
        Test.startTest();
        LeadScoringAutomationCtrl.getLeadandCalculation('AnnualRevenue', '1000000', '>=');
        LeadScoringAutomationCtrl.searchLeads('AnnualRevenue', '1000000', '>=');
        Test.stopTest();
    }
    
    @isTest static void testGetLeadandCalculationNoRecord(){
        Test.startTest();
        LeadScoringAutomationCtrl.getLeadandCalculation('Name', 'a1223333', 'Like');
        LeadScoringAutomationCtrl.searchLeads('Name', 'a1223333', 'Like');
        Test.stopTest();
    }
    
    @isTest static void testBatchLeadScoring(){
        Test.startTest();
        String userID = UserInfo.getUserId();
        Datetime runTime = Datetime.Now();
        BatchLeadScoringAutomation batchJob = new BatchLeadScoringAutomation('Name', 'aa', '=', runTime, userID);
        Id batchJobId = Database.executeBatch(batchJob, Integer.valueOf(Label.LS_BATCH_SIZE));
        Test.stopTest();
    }
    
    @isTest static void testBatchLeadScoringLike(){
        Test.startTest();
        String userID = UserInfo.getUserId();
        Datetime runTime = Datetime.Now();
        BatchLeadScoringAutomation batchJob = new BatchLeadScoringAutomation('Name', 'aa', 'Like', runTime, userID);
        Id batchJobId = Database.executeBatch(batchJob, Integer.valueOf(Label.LS_BATCH_SIZE));
        Test.stopTest();
    }

}