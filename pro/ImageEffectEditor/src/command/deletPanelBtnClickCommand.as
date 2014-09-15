package command
{
	import flash.events.Event;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class deletPanelBtnClickCommand extends Command implements ICommand
	{
		public function deletPanelBtnClickCommand()
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
			editorPanel.onSureDeleteCatalog(obj);
		}
	}
}