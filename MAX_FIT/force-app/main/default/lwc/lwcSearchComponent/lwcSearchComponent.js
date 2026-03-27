import { LightningElement } from 'lwc';

export default class LwcSearchComponent extends LightningElement {
    @track searchKeyword;
    @api isrequired = false;
    @api searchLabel = 'Search Account';
    @api showLabel = true;
    /* Check the isrequired property is set to true then set it to true */
    renderedCallback(){
        if(this.isrequired === false) return;
        if(this.isrequired === true){
            let picklistInfo = this.template.querySelector('lightning-input');
            picklistInfo.required = true;
            this.isrequired = false;
        }
    }
    handleChange(event){
        let keyword  = event.target.value;
        /* Create and dispatch the search keyword to parent component */
        if(keyword && keyword.length >=2){
            let searchEvent = new CustomEvent("search",{
                deatil : {value : keyword}
            });
            this.dispatchEvent(searchEvent);
        }
    }

}