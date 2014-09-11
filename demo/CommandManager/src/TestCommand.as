package
{	
	import commandManager.CommandManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeStyle;
	import flash.globalization.LocaleID;
	import flash.net.InterfaceAddress;
	import flash.system.Capabilities;

	public class TestCommand extends Sprite
	{	
		public function TestCommand()
		{
			RegistCommand.regist();
			
			CommandManager.sendCommand("TestCommand1",1);
			
			trace(Capabilities.hasPrinting)

		}
		
	}
}