package com.zqvideo.model.data
{
	
	
	import com.zqvideo.model.core.Model;
	
	import flash.display.Sprite;
	
	import mvc.Command;

	/**
	 * 数据解析类
	 * @author .....Li灬Star
	 */
	public class DataCenter extends Model
	{
		private static var instance:DataCenter=new DataCenter();

		public function DataCenter()
		{
			if (instance)
			{
				throw new Error("DataCenter.getInstance()获取实例");
			}
		}
		
		public function addEventListenrs():void
		{
			this.addEventListener(DataLoader.HOME_PAGE_FENYE, dataCompleteHandler);
			this.addEventListener(DataLoader.EDITOR_PAGE_FENYE,dataCompleteHandler);
			this.addEventListener(DataLoader.SEND_IMAGE,dataCompleteHandler);
			this.addEventListener(DataLoader.GENERATE_FENYE,dataCompleteHandler);
			
			this.addEventListener(DataLoader.LOADERROR, loadErrorHandler);
		}

		public function removeEventListeners():void
		{
			this.removeEventListener(DataLoader.HOME_PAGE_FENYE, dataCompleteHandler);
			this.removeEventListener(DataLoader.EDITOR_PAGE_FENYE,dataCompleteHandler);
			this.removeEventListener(DataLoader.SEND_IMAGE,dataCompleteHandler);
			this.removeEventListener(DataLoader.GENERATE_FENYE,dataCompleteHandler);
			
			this.removeEventListener(DataLoader.LOADERROR, loadErrorHandler);
		}

		private function dataCompleteHandler(e:DataEvent):void
		{
			/*var dataEvent:DataEvent;
			
			switch (e.type)
			{
				case "HOME_PAGE_FENYE":
					dataEvent=new DataEvent(DataEvent.GET_HOME_PAGE_FENYE_DATA, e.obj);
					break;
			}*/
			
			sendNotification("updatePanelCommand",e.obj);
			
            
		}

		private function loadErrorHandler(e:DataEvent):void
		{
			//var loadEvent:DataEvent=new DataEvent(DataEvent.LOAD_ERROR, e.obj);
			sendNotification("panelShowCommand",{panelName:"AlertPanel",alertContent:e.obj.errorTxt});
		}

		public static function getInstance():DataCenter
		{
			return instance;
		}
	}
}
