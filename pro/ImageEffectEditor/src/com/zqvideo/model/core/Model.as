package com.zqvideo.model.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class Model extends EventDispatcher
	{
		/**
		 * 
		 * @param target
		 */
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
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