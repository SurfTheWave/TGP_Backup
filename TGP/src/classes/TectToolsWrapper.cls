/*
  @Author: Rishab
  @Name: TectToolsWrapper
  @Created Date: 
  @Description:
  @version: 1.0
*/
public with sharing class TectToolsWrapper {
    public Boolean checked{ get; set; }
    public Tech_tools__C techTool{ get; set;}
    /*
  @Author: Rishab
  @Name: TectToolsWrapper
  @Created Date: 
  @Description:
  @version: 1.0
*/
    public TectToolsWrapper(){
        techTool = new Tech_tools__C();
        checked = false;
    }
    /*
  @Author: Rishab
  @Name: TectToolsWrapper
  @Created Date: 
  @Description:
  @version: 1.0
*/
    public TectToolsWrapper(Tech_tools__C c){
        techTool = c;
        checked = false;
    }
}