/**
   @Author : Jyotsna Yadav
   @name   : BPOSECanvas
   @CreateDate : 12 June 2015 
   @Description : Controller class for page BPOSE Canvas.
   @Version : 1.0 
   */
public without sharing class BPOSECanvas {

    public String paramList{get;set;}
    
    /* Wraaper Class to get a Json Object of parameters */
    public without sharing class WrapperParamClass{
        private String enterpriseid;
        private String pagename;
       
       /* Constructor of Wrapper Class */ 
        public WrapperParamClass( String enterpriseId,String pageName){
            this.enterpriseId = enterpriseId;
            this.pagename= pageName;
           
        }
    }
   
   /* Method to generate the JSON that needs to be sent to BPOSE */ 
   public void generateJSONContent() {
        try{
            String emailId = userinfo.getUserEmail().split(UtilConstants.AT_THE_RATE_OF)[0];
            WrapperParamClass wC = new WrapperParamClass(emailId,'Admin' );
            JSONGenerator gen = JSON.createGenerator(true);       
            
            gen.writeStartObject();
            gen.writeFieldName(UtilConstants.CANVAS_REQUEST);
                 
            gen.writeObject(wC);
            
            gen.writeEndObject();
           
            
            paramList = gen.getAsString();
            
        }catch( Exception E ){
            ApexPages.addMessages(e);
        }
    }

/* Method to generate the JSON that needs to be sent to BPOSE */ 
   public void generateJSONContentResource() {
        try{
            String emailId = userinfo.getUserEmail().split(UtilConstants.AT_THE_RATE_OF)[0];
            WrapperParamClass wC = new WrapperParamClass(emailId,'Miscellaneous' );
            JSONGenerator gen = JSON.createGenerator(true);       
            
            gen.writeStartObject();
            gen.writeFieldName(UtilConstants.CANVAS_REQUEST);
                 
            gen.writeObject(wC);
            
            gen.writeEndObject();
           
            
            paramList = gen.getAsString();
            
            system.debug('SFDC: ' + paramList);
            
        }catch( Exception E ){
            ApexPages.addMessages(e);
        }
    }

}