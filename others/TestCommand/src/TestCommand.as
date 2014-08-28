package
{
	import RegistCommand;
	import commandManager.CommandManager;
	import flash.display.Sprite;
	
	public class TestCommand extends Sprite
	{
		public function TestCommand()
		{
			RegistCommand.regist();
			
			CommandManager.sendCommand("TestCommand1",1);
		}
	}
}