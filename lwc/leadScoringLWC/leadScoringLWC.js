import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/LeadScoringAutomationCtrl.getContacts';

import getLeads from '@salesforce/apex/LeadScoringAutomationCtrl.getLeadandCalculation';
import searchLeads from '@salesforce/apex/LeadScoringAutomationCtrl.searchLeads';
import calculateAllLeads from '@salesforce/apex/LeadScoringAutomationCtrl.calculateAllLeads';

import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
 
// columns
const columns = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
    }, {
        label: 'Company Size',
        fieldName: 'Company_Size__c',
        type: 'text',
        editable: true,
    }, {
        label: 'Industry',
        fieldName: 'Industry',
        type: 'text',
        editable: true,
    }, {
        label: 'AnnualRevenue',
        fieldName: 'AnnualRevenue',
        type: 'number',
        editable: true
    }, {
        label: 'Number Of Employees',
        fieldName: 'NumberOfEmployees',
        type: 'number',
        editable: true
    }, {
        label: 'Recent Website Activity',
        fieldName: 'Recent_website_activity__c',
        type: 'text',
        editable: true
    }
    , {
        label: 'Form Submissions',
        fieldName: 'Form_submissions__c',
        type: 'text',
        editable: true
    }, {
        label: 'Lead Scoring',
        fieldName: 'Lead_Scoring__c',
        type: 'number',
        editable: true
    }
];

export default class LWCInline extends LightningElement {
    columns = columns;
    @track searchKey;
    @track fieldName;
	@track leads;
    @track returnValue;

    valueField      = 'Name';
    valueOperator   = 'Like';
    textValue;
    @track operationValues = [];


    get options() {
        return [
            { label: 'Name', value: 'Name' },
            { label: 'Company Size', value: 'Company_Size__c' },
            { label: 'Industry', value: 'Industry' },
            { label: 'Annual Revenue', value: 'AnnualRevenue' },
            { label: 'Number Of Employees', value: 'NumberOfEmployees' },
            { label: 'Recent Website Activity', value: 'Recent_website_activity__c' },
            { label: 'Form Submissions', value: 'Form_submissions__c' },
        ];
    }

    get operators() {
        if (this.valueField != 'AnnualRevenue' && this.valueField != 'NumberOfEmployees') {
            this.operationValues = [
                { label: 'Equal', value: '=' },
                { label: 'Contains', value: 'Like' }
            ];
        } else {
            this.operationValues = [
                { label: 'Equal', value: '=' },
                { label: 'Less Than', value: '<' },
                { label: 'More Than', value: '>' },
                { label: 'Less Than or Equal', value: '<=' },
                { label: 'More Than or Equal', value: '>=' },
            ];
        }
        return this.operationValues;
        
    }

    handleChangeSearch (event) {
        this.searchKey     = event.detail.value;
    }

    handleChange(event) {
        this.valueField     = event.detail.value;
        if (this.valueField != 'AnnualRevenue' && this.valueField != 'NumberOfEmployees') {
            this.operationValues = [
                { label: 'Equal', value: '=' },
                { label: 'Contains', value: 'Like' }
            ];
        } else {
            this.operationValues = [
                { label: 'Equal', value: '=' },
                { label: 'Less Than', value: '<' },
                { label: 'More Than', value: '>' },
                { label: 'Less Than or Equal', value: '<=' },
                { label: 'More Than or Equal', value: '>=' },
            ];
        }
    }
    handleChangeOperator (event) {
        this.valueOperator = event.detail.value;
    }
    
    handleGetLeads(){
        getLeads({ inputFieldName: this.valueField, inputValue : this.searchKey, inputOperators : this.valueOperator})
        .then(result =>{
            
            if (result.Status == 'Success') {
                this.ShowToast('Success', result.Message , 'success', 'dismissable');
                this.leads = result.lstLeadRerturn;
            } else if (result.Status == 'No Leads Return') {
                this.ShowToast('Warning', result.Message , 'warning', 'dismissable');
            } else {
                this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
                console.log(result.Messag);

            }

        })
        .catch(error =>{
            console.log(error);
            //this.errorMsg = error;
        })
    }

    handleSearchLeads () {
        searchLeads({ inputFieldName: this.valueField, inputValue : this.searchKey, inputOperators : this.valueOperator})
        .then(result =>{
            if (result.Status == 'Success') {
                this.ShowToast('Success', result.Message , 'success', 'dismissable');
                this.leads = result.lstLeadRerturn;
            } else if (result.Status == 'No Leads Return') {
                this.ShowToast('Warning', result.Message , 'warning', 'dismissable');
            } else {
                this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
                console.log(result.Messag);

            }

            
        })
        .catch(error =>{
            this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
            console.log(error);
        })
    }

    handleCalculateAllLeads () {
        calculateAllLeads()
        .then(result =>{
            if (result.Status == 'Success') {
                this.ShowToast('Success', result.Message , 'success', 'dismissable');
            } else {
                this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
                console.log(result.Messag);

            }
        })
        .catch(error =>{
            this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
            console.log(error);
        })
    }

    handleSave(event) {
        this.saveDraftValues = event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        // Updateing the records using the UiRecordAPi
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.ShowToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.saveDraftValues = [];
            return this.refresh();
        }).catch(error => {
            this.ShowToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.saveDraftValues = [];
        });
    }
 
    ShowToast(title, message, variant, mode){
        const evt = new ShowToastEvent({
                title: title,
                message:message,
                variant: variant,
                mode: mode
            });
            this.dispatchEvent(evt);
    }
 
    // This function is used to refresh the table once data updated
    async refresh() {
        await refreshApex(this.contacts);
    }
}