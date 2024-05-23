@isTest
public class TestFactoryLS {
    public static List<Lead> createLeads (Integer max) {
        List<Lead> lstLeadTest = new List<Lead>();
        Lead tmpLead;
        Integer i;
        for (i = 1 ; i < max; i++) {
            tmpLead = new Lead();
            
            tmpLead.AnnualRevenue = i * 100000000;
            tmpLead.NumberOfEmployees = (i + i) * 100;
            tmpLead.Company = 'ABC' + i;
            
            if (i < 4) {
                tmpLead.FirstName 	= 'a';
            	tmpLead.LastName 	= 'a';
                tmpLead.Company_Size__c = 'Small';
                tmpLead.Recent_website_activity__c  = 'Home Page';
                tmpLead.Industry = 'Agriculture';
                tmpLead.Form_submissions__c  = 'Engagement';
            }
            
            if (i >= 4 && i <8) {
                tmpLead.FirstName 	= 'b';
            	tmpLead.LastName 	= 'b';
                tmpLead.Company_Size__c = 'Medium';
                tmpLead.Recent_website_activity__c  = 'Pricing Page';
                tmpLead.Industry = 'Bank';
                tmpLead.Form_submissions__c  = 'Submitted Form';
            }
            
            if (i >= 8) {
                tmpLead.FirstName 	= 'c';
            	tmpLead.LastName 	= 'c';
                tmpLead.Company_Size__c = 'Large';
                tmpLead.Recent_website_activity__c  = 'Product Page';
                tmpLead.Industry = 'Technology';
                tmpLead.Form_submissions__c  = 'Download Document';
            }
            lstLeadTest.add(tmpLead);
        }
        insert lstLeadTest;
        return lstLeadTest;
        
    }
    
}