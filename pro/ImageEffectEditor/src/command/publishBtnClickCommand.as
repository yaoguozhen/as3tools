package command
{
	import flash.events.Event;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class publishBtnClickCommand extends Command implements ICommand
	{
		public function publishBtnClickCommand()
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
			editorPanel.effect_Player.playState=false;
		}
	}
}