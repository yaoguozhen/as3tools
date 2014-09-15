package command
{
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class SelectedEffectCommand extends Command implements ICommand
	{
		private var panelName:String="";
		
		public function SelectedEffectCommand()
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
			
			switch(panelName){
				case "EditorPanel":
					editorPanel.updateSelectedEffectBox(obj);
					break;
			}
			
		}
	}
}