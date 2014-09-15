package command
{
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class TiaoHuanSelectedImageCommand extends Command implements ICommand
	{
		private var panelName:String="";
		private var updateType:String="";
		
		public function TiaoHuanSelectedImageCommand()
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
			
			if(obj.updateType){
				updateType=obj.updateType;
			}
			
			switch(panelName){
				case "EditorPanel":
					if(updateType=="tiaoHuanImage"){
						editorPanel.tiaoHuanImageBox(obj.idObj);
					}
					break;
			}
		}
	}
}