package command
{
	import com.zqvideo.model.data.DataCenter;
	import com.zqvideo.model.data.LanguageParser;
	import com.zqvideo.view.LayerManager;
	import com.zqvideo.view.panel.AlertPanel;
	import com.zqvideo.view.panel.DeleteAlertPanel;
	import com.zqvideo.view.panel.EditorPanel;
	import com.zqvideo.view.panel.HomePagePanel;
	import com.zqvideo.view.panel.LoadingPanel;
	import com.zqvideo.view.panel.ShengChengPanel;
	
	import mvc.Command;
	import mvc.ICommand;
	
	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class InitViewCommand extends Command implements ICommand
	{
		public function InitViewCommand()
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
			LayerManager.init();
			Root.initDataUrl();
			DataCenter.getInstance().addEventListenrs();
			initViewHandler();
		}
		
		private function initViewHandler():void{
			loadingPanel=new LoadingPanel();
			shengChengPanel=new ShengChengPanel();
			alertPanel=new AlertPanel();
			//homePagePanel=new HomePagePanel();
			editorPanel=new EditorPanel();
			deleteAlertPanel=new DeleteAlertPanel();
			
			viewList.push(loadingPanel);
			viewList.push(shengChengPanel);
			viewList.push(alertPanel);
			//viewList.push(homePagePanel);
			viewList.push(editorPanel);
			viewList.push(deleteAlertPanel);
			
			for(var i:int=0;i<viewList.length;i++){
				viewList[i].initShowView();
			}
			//sendNotification("panelShowCommand",{panelName:"LoadingPanel"});
			//sendNotification("panelShowCommand",{panelName:"HomePagePanel"});
			sendNotification("panelShowCommand",{panelName:"EditorPanel"});
		}
	}
}