 package com.zqvideo.view.core
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import mvc.Command;
	import mvc.ICommand;

	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class View extends MovieClip
	{
		protected var stageWidth:Number=0;
		protected var stageHeight:Number=0;
		
		public function View()
		{
			
		}
		
		/**
		 * 
		 * @param notificationName
		 * @param notificationObj
		 */
		public function sendNotification(notificationName:String, notificationObj:Object=null):void
		{
			if (Command.commandMap[notificationName] != null)
			{
				ICommand(Command.commandMap[notificationName]).execute(notificationName, notificationObj);
			}
		}
	}
}
