package command
{
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class PanelHideCommand extends Command implements ICommand
	{
		
		public function PanelHideCommand()
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
			var panelName:String=obj.panelName.toString();
			
			switch(panelName){
				/*case "HomePagePanel":
					homePagePanel.isShow=false;
					break;*/
				case "LoadingPanel":
					loadingPanel.isShow=false;
					break;
				case "AlertPanel":
					alertPanel.isShow=false;
					break;
				
			}
		}
	}
}