public class PopUpController {
    public Map<String,String> Recordid = new Map<String,String>();
    public String costid{get;set;}
    public String opptid{get;set;}
    public Id userid{set;get;}
    public Integer count;
    public PopupController(){
        Recordid = ApexPages.CurrentPage().getParameters();
        opptid = Recordid.get('opptid');
        costid = Recordid.get('costid');
        userid =userinfo.getUserid();
        count=300;
        
    }
    
    
    public PageReference incrementCounter(){
        count= count -5;
        return null;
    }

    public Integer getCount(){
        return count;
    }

}