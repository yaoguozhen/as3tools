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
		
		private var _onResult:Function = null;
		
		/**
		 * 
		 * @param	url 请求地址
		 * @param	methord post或get
		 * @param	param 要发送的参数
		 * @param	onResult 请求结果回调函数
		 */
		public function YURLLoader(url:String, methord:String=YURLLoader.GET, param:Object=null, onResult:Function=null):void
		{
			_onResult = onResult;
			
			if (param)
			{
				var urlVal:URLVariables = new URLVariables()
				for (var item in param)
				{
					urlVal[item] = param[item];
				}
			}
			
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = url;
			urlRequest.method = methord;
			if (param)
			{
				urlRequest.data = urlVal;
			}
			
			var loader:URLLoader = new URLLoader();
			if (_onResult)
			{
				loader.addEventListener(Event.COMPLETE, loadComHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrHandler);
			}
			loader.load(urlRequest);
		}
		private function loadComHandler(evn:Event):void
		{
			var data:String = URLLoader(evn.target).data;
			
			var obj:Object = new Object();
			obj.result = "success";
			obj.data = data;
			
		    _onResult(obj);
		}
		private function loadErrHandler(evn:IOErrorEvent):void
		{
            var obj:Object = new Object();
			obj.result = "fail";
			obj.data = evn.text;
			
		    _onResult(obj);
		}
	}

}