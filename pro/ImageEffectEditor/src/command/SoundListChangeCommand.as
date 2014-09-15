package command
{
	import com.zqvideo.view.PreviewSoundPlayer;
	
	import flash.events.Event;
	
	import flashx.textLayout.elements.BreakElement;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class SoundListChangeCommand extends Command implements ICommand
	{
		private var panelName:String="";
		private var soundURL:String
		
		public function SoundListChangeCommand()
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
			soundURL=obj.soundURL;
			
			if(soundURL)
			{
				previewSoundPlayer=PreviewSoundPlayer.instance;
				previewSoundPlayer.removeEventListener("soundPlayComplete",soundPlayCompleteHandler);
				previewSoundPlayer.addEventListener("soundPlayComplete",soundPlayCompleteHandler);
				previewSoundPlayer.play(Root.soundPlayURL);
				trace("Root.soundPlayURL:",Root.soundPlayURL)
				if(Root.previewPlayerState=="pause")
				{
					previewSoundPlayer.stop();
				}
			}
		}
		
		protected function soundPlayCompleteHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			if(soundURL)
			{
				previewSoundPlayer.play(soundURL);
			}
		}
	}
}