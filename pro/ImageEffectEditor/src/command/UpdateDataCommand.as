package command
{
	import com.zqvideo.model.data.DataLoader;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class UpdateDataCommand extends Command implements ICommand
	{
		private var dataType:String="";
		private var pageNum:int=1;
		private var pageName:String="";
		
		public function UpdateDataCommand()
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
			if(obj.dataType){
				dataType=obj.dataType.toString();
			}
			
			if(obj.pageNum){
				pageNum=obj.pageNum;
			}
			
			if(obj.pageName){
				pageName=obj.pageName;
			}
			
			switch(dataType){
				/*case "HOME_PAGE_FENYE":
					DataLoader.getInstance().loadXML("HOME_PAGE_FENYE",obj);
					break;*/
				case "EDITOR_PAGE_FENYE":
					DataLoader.getInstance().loadXML("EDITOR_PAGE_FENYE",obj);
					break;
				case "GENERATE_FENYE":
					DataLoader.getInstance().loadXML("GENERATE_FENYE",obj);
					break;
				case "SEND_IMAGE":
					DataLoader.getInstance().loadXML("SEND_IMAGE",obj);
					break;
			}
			
		}
	}
}