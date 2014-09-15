package command
{
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class UpdateEffectPlayCommand extends Command implements ICommand
	{
		private var panelName:String="";
		
		public function UpdateEffectPlayCommand()
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
					editorPanel.updateEffectPlay(obj);
					break;
				case "EffectPlayer":
					if(obj.message=="PauseRightNow"){
						editorPanel.effect_Player.pauseRightNow();
					}
					break;
			}
			
		}
	}
}