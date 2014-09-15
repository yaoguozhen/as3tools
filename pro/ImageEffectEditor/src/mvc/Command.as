package mvc
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.zqvideo.loader.SWFLoader;
	import com.zqvideo.loader.XMLLoader;
	import com.zqvideo.view.EditorFacade;
	import com.zqvideo.view.PreviewSoundPlayer;
	import com.zqvideo.view.component.EffectPlayer;
	import com.zqvideo.view.core.PanelView;
	import com.zqvideo.view.core.View;
	import com.zqvideo.view.panel.AlertPanel;
	import com.zqvideo.view.panel.DeleteAlertPanel;
	import com.zqvideo.view.panel.EditorPanel;
	import com.zqvideo.view.panel.HomePagePanel;
	import com.zqvideo.view.panel.LoadingPanel;
	import com.zqvideo.view.panel.ShengChengPanel;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	/**
	 * 
	 * @author .....Li灬Star
	 */
	public class Command extends EventDispatcher
	{
		protected static var configXMLLoader:XMLLoader;
		
		protected static var assetsLoader:BulkLoader;
		
		public static var editorFacade:EditorFacade;
		
		public static var commandMap:Object={};
		
		protected static var viewList:Vector.<PanelView>=new Vector.<PanelView>();
		
		protected static var animationXMLLoader:XMLLoader;
		
		protected static var animationSWFLoader:SWFLoader;
		
		//protected static var homePagePanel:HomePagePanel;
		
		protected static var editorPanel:EditorPanel;
		
		protected static var loadingPanel:LoadingPanel;
		
		protected static var alertPanel:AlertPanel;
		
		protected static var shengChengPanel:ShengChengPanel;
		
		protected static var previewSoundPlayer:PreviewSoundPlayer;
		
		protected static var deleteAlertPanel:DeleteAlertPanel;

		public function Command()
		{

		}

		/**
		 * 
		 * @param screenMode
		 */
		public static function updateScreenMode(screenMode:String):void
		{
			updateControllerSize();
		}

		/**
		 * 
		 * @param widthNum
		 * @param heightNum
		 */
		public static function updateControllerSize(widthNum:Number=0, heightNum:Number=0):void
		{

		}

		/**
		 * 
		 * @param commandName
		 * @param classObj
		 */
		public function registerCommand(commandName:String, classObj:Class):void
		{
			if (commandMap[commandName] == null)
			{
				commandMap[commandName]=new (classObj)();
			}
		}

		/**
		 * 
		 * @param notificationName
		 * @param notificationObj
		 */
		public function sendNotification(notificationName:String, notificationObj:Object=null):void
		{
			if (commandMap[notificationName] != null)
			{
				ICommand(commandMap[notificationName]).execute(notificationName, notificationObj);
			}
		}

		/**
		 * 
		 * @param $status
		 */
		public function updateFlowStatus($status:String):void
		{

		}

		/**
		 * 
		 * @param $error
		 */
		protected function showErrorPanel($error:String):void
		{

		}

	}
}
