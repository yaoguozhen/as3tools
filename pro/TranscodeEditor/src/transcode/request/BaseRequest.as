package transcode.request
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import transcode.EventManager;
	import transcode.event.NetEvent;

	public class BaseRequest
	{
		protected var _urlloader:URLLoader;
		protected var _request:URLRequest;
		protected var _result:*;
		protected var _data:Object;
		public var API:String;
		/**
		 * 协议类型
		 */
		protected var _type:String;
		public var targetName:String="";
		
		public function BaseRequest()
		{
			_request = new URLRequest();
			_urlloader = new URLLoader();
			_urlloader.addEventListener(Event.COMPLETE, onComplete);
			_urlloader.addEventListener(Event.OPEN, onOpen);
			_urlloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_urlloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		public function get result():*
		{
			return _result;
		}
		
		protected function validateResult():void
		{
			_result = _data;
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			App.log.error(event);
		}

		private function onProgress(event:ProgressEvent):void
		{
		}

		protected function onIoError(event:IOErrorEvent):void
		{
			App.log.error(event);
		}

		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			App.log.info(event);
		}

		private function onOpen(event:Event):void
		{
		}

		private function onComplete(event:Event):void
		{
			if(_urlloader.data==null){
				return;
			}
			var str:String = _urlloader.data;
			trace("base JSON:"+_urlloader.data.toString());
			_data = com.adobe.serialization.json.JSON.decode(_urlloader.data);
			
			validateResult();
			if(_type == null){
				throw new Error("事件类型未定义");
			}
			var evt:NetEvent = new NetEvent(_type);
			evt.targetName=targetName;
			evt.data = _result;
			EventManager.instance.dispatchEvent(evt);
		}
		
		protected function init():void
		{
			
		}
		
		public function get request():URLRequest{
			return _request;
		}
		
		public function get type():String{
			return _type;
		}
		
		public function send(search:Boolean=false):void
		{
			_request.url = EditorConfig.host + this.API;
			init();
			try
			{
				_urlloader.close();
			} 
			catch(error:Error) 
			{
				
			}
			_urlloader.load(_request);
		}
	}
}