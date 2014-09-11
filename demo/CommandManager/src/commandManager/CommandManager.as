package commandManager
{
	public class CommandManager
	{		
		private static var commandAndListener:Object={};
		
		public function CommandManager()
		{

		}
		public static function registerCommand(commandName:String, ListenerClass:Class):void
		{
			if (commandAndListener[commandName] == null)
			{
				commandAndListener[commandName]=new ListenerClass();
			}
			else
			{
				throw new Error(commandName+" 命令已被注册");
			}
		}
		public static function sendCommand(commandName:String, paramObj:Object=null):void
		{
			if (commandAndListener[commandName] == null)
			{
				throw new Error(commandName+" 命令没有被注册");
			}
			else
			{
				ICommand(commandAndListener[commandName]).execute(paramObj);
			}
		}

	}
}
