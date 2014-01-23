package zhen.guo.yao.yloader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class YLoader extends EventDispatcher 
	{
		private var _loader:Loader;
		
		private var _urlArray:Array;//待加载地址的数组
		private var _contentArray:Array;//加载成功的对象的数组
		private var _notFoundUrlArray:Array;//加载失败的地址
		
		private var _contentCount:uint = 0;
		private var _currentLoadIndex:uint = 0;
		private var _isLoading:Boolean = false;
		
		public function YLoader():void
		{
			_contentArray = [];
			_notFoundUrlArray = [];
			
			_loader = new Loader();
		}
		private function loadComHandler(evn:Event):void
		{
			_contentArray.push(evn.target.content);
			judg();
		}
		private function loadErrHandler(evn:IOErrorEvent):void
		{
			_contentArray.push("null");
			_notFoundUrlArray.push(_urlArray[_currentLoadIndex]);
			judg();
		}
		private function judg():void
		{
			_currentLoadIndex++;
			if (_currentLoadIndex < _contentCount )
			{
				_loader.load(new URLRequest(_urlArray[_currentLoadIndex]),new LoaderContext(true));
			}
			else
			{
				removeListener();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function clear():void
		{
			_urlArray = [];
			_contentArray = [];
			_notFoundUrlArray = [];
			
			_contentCount = 0;
			_currentLoadIndex = 0;
			
			if (_isLoading)
			{
				_isLoading = false;
				_loader.close();
			}
			removeListener();
		}
		private function removeListener():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadErrHandler);
		}
		/**
		 * 加载
		 * @param	arr 地址的数组
		 */
		public function load(arr:Array):void
		{
			if (_isLoading)
			{
				clear();
			}
			_isLoading = true;
			_urlArray = arr;
			_contentCount = arr.length;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrHandler);
			_loader.load(new URLRequest(arr[_currentLoadIndex]),new LoaderContext(true));
		}
		/**
		 * 加载完毕的内容的数组。
		 */
		public function get contentArray():Array
		{
			return _contentArray;
		}
		/**
		 * 加载失败的地址的数组
		 */
		public function get notFoundUrlArray():Array
		{
			return _notFoundUrlArray;
		}
	}

}