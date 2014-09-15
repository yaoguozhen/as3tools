package mvc
{
	import flash.events.EventDispatcher

	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class Facade extends EventDispatcher
	{

		/**
		 * 
		 * @param commandName
		 * @param classObj
		 */
		public function registerCommand(commandName:String, classObj:Class):void
		{
			if (Command.commandMap[commandName] == null)
			{
				Command.commandMap[commandName]=new (classObj)();
			}
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

		/**
		 * 
		 * @param widthNum
		 * @param heightNum
		 */
		public function updateControllerSize(widthNum:Number=0, heightNum:Number=0):void
		{
			Command.updateControllerSize(widthNum, heightNum);
		}

		/**
		 * 
		 * @param screenMode
		 */
		public function updateScreenMode(screenMode:String):void
		{
			Command.updateScreenMode(screenMode);
		}
	}
}
