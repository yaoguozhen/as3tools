package command
{
	import com.zqvideo.view.PreviewSoundPlayer;
	
	import flash.events.Event;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class controlSoundCommand extends Command implements ICommand
	{
		public function controlSoundCommand()
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
			previewSoundPlayer=PreviewSoundPlayer.instance;
			if(Root.soundPlayURL!=""&&Root.useSound)
			{
				if(obj.play)
				{
					previewSoundPlayer.play();
				}
				else
				{
					previewSoundPlayer.stop();
				}
			}
		}
	}
}