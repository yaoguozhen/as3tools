package zhen.guo.yao.yloader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * 
	 * @author yaoguozhen
	 */
	public class YURLLoader 
	{
		public static const GET:String = "get";
		public static const POST:String = "post";
		
		public static const SEND_SUCCESS:String="success";
		public static const SEND_FAIL_IO:String="fail_io";
		public static const SEND_FAIL_SEC:String="fail_sec";
		
		private var _onResult:Function = null;
		private var _url:String;
		private var _loader:URLLoader;
		
		/**
		 * 
		 * @param	url 请求地址
		 * @param	methord post或get
		 * @param	param 要发送的参数
		 * @param	onResult 请求结果回调函数.
		 */
		public function YURLLoader(url:String, methord:String=YURLLoader.GET, param:Object=null, onResult:Function=null):void
		{
			_onResult = onResult;
			_url=url;
			
			if (param)
			{
				var urlVal:URLVariables = new URLVariables()
				for (var item in param)
				{
					urlVal[item] = param[item];
				}
			}
			
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = _url;
			urlRequest.method = methord;
			if (param)
			{
				urlRequest.data = urlVal;
			}
			
			_loader = new URLLoader();
			if (_onResult!=null)
			{
				_loader.addEventListener(Event.COMPLETE, loadComHandler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, loadIOErrHandler);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSECErrHandler);
			}
			_loader.load(urlRequest);
		}
		private function loadComHandler(evn:Event):void
		{
			removeListeners();
			
			var data:String = URLLoader(evn.target).data;
			
			var obj:Object = new Object();
			obj.result = SEND_SUCCESS;
			obj.data = data;
			obj.url=_url;
			
		    _onResult(obj);
		}
		private function loadIOErrHandler(evn:IOErrorEvent):void
		{
			removeListeners();
			
            var obj:Object = new Object();
			obj.result = SEND_FAIL_IO;
			obj.data = evn.text;
			obj.url=_url;
			
		    _onResult(obj);
		}
		private function loadSECErrHandler(evn:IOErrorEvent):void
		{
			removeListeners();
			
            var obj:Object = new Object();
			obj.result = SEND_FAIL_SEC;
			obj.data = evn.text;
			obj.url=_url;
			
		    _onResult(obj);
		}
		private function removeListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, loadComHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, loadIOErrHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadSECErrHandler);
		}
	}

}