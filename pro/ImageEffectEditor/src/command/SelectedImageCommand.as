package command
{
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class SelectedImageCommand extends Command implements ICommand
	{
		private var imageType:String="";
		
		public function SelectedImageCommand()
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
			if(obj.imageType){
				imageType=obj.imageType;
			}
			
			//trace(obj.selectedData.toXMLString()+"//////");
			
			switch(imageType){
				/*case "HomePageImage":
					homePagePanel.updateSelectedImageBox(obj);
					break;*/
				case "EditorEffectImage":
					editorPanel.updateSelectedImageBox(obj);
					break;
			}
		}
	}
}