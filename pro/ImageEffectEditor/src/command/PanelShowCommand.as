package command
{
	import com.zqvideo.view.core.View;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class PanelShowCommand extends Command implements ICommand
	{
		public function PanelShowCommand()
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
			var panelName:String=obj.panelName.toString();
			
			switch(panelName){
				/*case "HomePagePanel":
					homePagePanel.isShow=true;
					break;*/
				case "EditorPanel":
					/*if(homePagePanel){
						homePagePanel.isShow=false;
						homePagePanel.destory();
					}*/
					editorPanel.isShow=true;
					break;
				case "LoadingPanel":
					loadingPanel.isShow=true;
					break;
				case "ShengChengPanel":
					shengChengPanel.isShow=true;
					if(obj.inputView){
						shengChengPanel.editorImageAndEffectBox=obj.inputView;
					}
					if(obj.showType){
						shengChengPanel.showElement(obj.showType);
					}
					break;
				case "AlertPanel":
					alertPanel.isShow=true;
					if(obj.alertContent){
						alertPanel.updateAlertContent(obj.alertContent.toString());
					}
					break;
				case "DeleteAlertPanel":
					deleteAlertPanel.isShow=true;
					deleteAlertPanel.data=obj;
					break;
					
			}
		}
	}
}