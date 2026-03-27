import { LightningElement } from 'lwc';

export default class Lwcrecordlist extends LightningElement {
    @api rec;
    @api iconname = "standard:account";
    @api parentidfield;
    handleSelect(){
        let selectEvent = new CustomEvent("select",{
            detail : {
                selRec : this.rec,
                parent : this.parentidfield
            }
        });
        this.dispacthEvent(selectEvent);
    }
    handleRemove(){
        let selectEvent = new CustomEvent("select",{
            detail : {
                selRec : undefined,
                parent : this.parentidfield
            }
        });
        this.dispacthEvent(selectEvent);
    }
}