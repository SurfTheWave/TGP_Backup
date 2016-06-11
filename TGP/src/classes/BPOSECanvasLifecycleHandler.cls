public class BPOSECanvasLifecycleHandler implements Canvas.CanvasLifecycleHandler {
        public Set<Canvas.ContextTypeEnum> excludeContextTypes(){
                Set<Canvas.ContextTypeEnum> excluded = new Set<Canvas.ContextTypeEnum>();
                
                //Code goes here to add items to excluded list
                //that should be excluded from Context data
                return excluded;
        }
        public void onRender(Canvas.RenderContext renderContext) {
                //Get the Application and Environment context from the RenderContext
                Canvas.ApplicationContext app = renderContext.getApplicationContext();
                Canvas.EnvironmentContext env = renderContext.getEnvironmentContext();
                
                //Get the current custom params
                /*Map<String, Object> mapParams =(Map<String, Object>)  
                    JSON.deserializeUntyped(env.getParametersAsJSON());*/
                
                //get the parameter value
                //system.debug('CanvURL---->>>>'+(String)mapParams.get('canvURL'));
                
                //Override app URL, replacing portion after domain with parameter
                //app.setCanvasUrlPath((String)mapParams.get('canvURL'));
                
                //app.setCanvasUrlPath('/E2E%20Workbench%20Shared%20Folders/Forms/AllItems.aspx?RootFolder=%2Fsites%2FTGP_for_BPO%2FE2EWorkbench%2FE2E%20Workbench%20Shared%20Folders%2FE2E%20Releases%2FRelease%201%2E7%2FSWB&FolderCTID=0x0120000B794C3146AA964AA411A4004347B8D8&View={2F884566-016B-4EBB-B0FC-853896C65BAE}');
                //app.setCanvasUrlPath('/Search/SearchCompare.aspx');
                //app.setCanvasUrlPath('/adfs/ls/?wa=wsignin1.0&wreply=https%3a%2f%2fbposolutionestimator.ciodev-at.accenture.com%2f&wct=2014-10-29T10%3a50%3a45Z&wctx=35c3df86-6bc3-4598-b4a1-9b0d90b4bfb4');   
                //app.setCanvasUrlPath('/adfs/ls');
                system.debug('CanvURL---->>>>'+app.getCanvasUrl());                 

                
    }    
}