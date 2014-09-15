package command
{
	import mvc.Command;
	import mvc.ICommand;
	
	public class ImgAndEffSelectCommand extends Command implements ICommand
	{
		public function ImgAndEffSelectCommand()
		{
			super();
		}
		
		public function execute(type:String, obj:Object=null):void
		{
			if(obj.hasSelected==true){
				editorPanel.imgAndEffCanSelect=false;
			}else{
				editorPanel.imgAndEffCanSelect=true;
			}
		}
	}
}