package commands
{
	import commandManager.ICommand;

	public class Test1Command implements ICommand
	{
		private var alertType:String="";
		
		public function Test1Command()
		{
			super();
		}
		
		public function execute(paramObj:Object=null):void
		{
			trace("Test1Command 命令处理器.", String(paramObj));
		}
	}
}