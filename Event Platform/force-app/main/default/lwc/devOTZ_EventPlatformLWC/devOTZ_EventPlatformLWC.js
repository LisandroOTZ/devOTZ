/**
* @Develop By:       : devOTZ
* @author            : Lisandro Ortiz
* @last modified on  : 03-10-2024
* @last modified by  : Initial Version
* Modifications Log 
* Ver   Date         Author                        Modification
* 1.0   03-10-2024   Lisandro.lor@gmail.com   Initial Version
**/
import { LightningElement, track, api } from 'lwc';
import getData from "@salesforce/apex/devOTZ_Data_cls.getData";
import {subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled} from 'lightning/empApi';

export default class DevOTZ_EventPlatformLWC extends LightningElement {   
    ///Style
    @api scrollable_y;
    @api labelHeader;
    @api recordId;

    @track dataTask = [];
    @track data = [];
    @track datalength=0;
    @api channelName = '/event/Event__e';
    subscription = {};

    refreshData() {
        this.dataTask = [];
        this.datalength = 0;
        getData({ parentId: this.recordId }).then(data => {
            console.log(JSON.stringify(data));
                this.dataTask = data;
                this.datalength = data.length;
            }).catch(error => {
                console.error('Error: ' + JSON.stringify(error));
            }).finally(() => {
            
            });
    }

    connectedCallback(){
        this.refreshData();
        this.handleSubscribe();
    }

    proxyToObj(obj){
        return JSON.parse(JSON.stringify(obj));
    }

    handleSubscribe() {
        const self = this;
        const messageCallback = function (response) {
            var obj = JSON.parse(JSON.stringify(response));
            if(obj.recordId__c == this.recordId){
                self.refreshData();
            }
        }; 
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });
    }
}