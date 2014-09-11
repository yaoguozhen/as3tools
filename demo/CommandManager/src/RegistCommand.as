package
{
	import commandManager.CommandManager;
    import commands.Test1Command;
	
	public class RegistCommand
	{
		public static function regist():void{
			CommandManager.registerCommand("TestCommand1",Test1Command);
		}
	}
}