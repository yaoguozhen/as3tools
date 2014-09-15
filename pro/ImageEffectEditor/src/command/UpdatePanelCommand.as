package command
{
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class UpdatePanelCommand extends Command implements ICommand
	{
		private var panelName:String="";
		private var dataType:String="";
		private var xml:XML;
		
		public function UpdatePanelCommand()
		{
			super();
		}
		
		/**
		 * 
		 * @param type
		 * @param obj
		 */
		public function execute(type:String, obj:Object=null):void
		{
			
			if(obj.panelName){
				panelName=obj.panelName;
			}
			
			if(obj.dataType){
				dataType=obj.dataType;
			}
			
			if(obj.xml){
				xml=obj.xml;
			}
			
			switch(panelName){
				/*case "HomePagePanel":
					homePagePanel.updatePanel(obj);
					break;*/
				case "EditorPanel":
					editorPanel.updateList(obj);
					break;
				case "Editor_GENERATE":
					editorPanel.updatePanel(obj);
					break;
				case "SendPanel":
					/*alertPanel.isShow=true;
					trace(">>>生成返回XML:"+obj.xml.toXMLString());
					if(Boolean(obj.xml.@result)==true){
						alertPanel.updateAlertContent(Root.LANGUAGE_DATA.sendSucceed[0]);
					}else{
						alertPanel.updateAlertContent(Root.LANGUAGE_DATA.sendShiBai[0]);
					}*/
					shengChengPanel.isShow=true;
					if(Boolean(obj.xml.@result)==true){
						shengChengPanel.showElement("chengGongBigMC");
					}else{
						shengChengPanel.showElement("loseMC");
					}
					break;
			}
		}
	}
}