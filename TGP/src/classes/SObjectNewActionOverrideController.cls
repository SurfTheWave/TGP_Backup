/**
   @Author :Apoorva Sharma
   @name   : SObjectNewActionOverrideController 
   @CreateDate : 27 January 20156
   @Description : This class is used for overide save and new button functionality.
   @Version : 1.0 
  */
public class SObjectNewActionOverrideController {
    public String debug{get;Set;}
    private String SObjectPrefix = null;
    public SObjectNewActionOverrideController(ApexPages.StandardController controller){
        this.SObjectPrefix = controller.getRecord().getSObjectType().getDescribe().getKeyPrefix();
         
    }
    public PageReference onLoadPage(){
        this.debug = JSON.serializePretty(ApexPages.currentPage().getParameters());
        system.debug('JSON.serializePretty(ApexPages.currentPage().getParameters())'+JSON.serializePretty(ApexPages.currentPage().getParameters()));
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('length of returl'+retURL.length());
        //these are the conditions to understand that this is actually a "new" page
        //that comes from a previously "save" page in which the user clicked on "Save & New"
        if(ApexPages.currentPage().getParameters().get('save_new')=='1'&& retURL != null
           /*&& retURL.startsWith('/'+SObjectPrefix) && retURL.indexOf('/', 4) < 0*/
           && !retURL.contains('?') && retURL.length() >= 15){
              system.debug('retURL------------------------------------->'+retURL+'   save_new'+ApexPages.currentPage().getParameters().get('save_new') );
               PageReference pg = new PAgeReference(retURL);
               pg.setRedirect(true);
               return pg;
           }else{
               system.debug('retURL'+retURL+'save_new'+ApexPages.currentPage().getParameters().get('save_new'));
               PageReference pg = new PAgeReference('/'+this.SObjectPrefix+'/e');
               for(String key : ApexPages.currentPage().getParameters().keyset()){
                   if(key == 'save_new' || key == 'sfdc.override') continue;
                   pg.getParameters().put(key, ApexPages.currentPage().getParameters().get(key));
               }
               pg.getParameters().put('nooverride','1');
               pg.setRedirect(true);
               return pg;
           }
    }
}