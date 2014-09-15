package com.zqvideo.loader
{
	import com.zqvideo.event.LoadEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;


	/**
	 * XML加载类
	 * @author .....Li灬Star
	 */
	public class XMLLoader extends EventDispatcher
	{
		private var xmlLoader:URLLoader=null;
		private var xmlUrl:URLRequest=null;
		private var urlStr:String="";
		private var _data:XML=null;

		public function get data():XML
		{
			return _data;
		}

		public function set data(value:XML):void
		{
			_data=value;
		}

		public function XMLLoader()
		{
			xmlLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, completeHandler);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}

		public function load($urlStr:String):void
		{
			if ($urlStr)
			{
				urlStr=$urlStr;
				xmlUrl=new URLRequest(urlStr);
				xmlLoader.load(xmlUrl);
			}
		}

		private function completeHandler(e:Event):void
		{
			try
			{
				data=new XML(e.currentTarget.data);
				this.dispatchEvent(new LoadEvent(LoadEvent.XML_LOAD_COMPLETE));
				close();
			} 
			catch(error:Error) 
			{
				errorHandler(null);
			}
		}

		private function errorHandler(e:IOErrorEvent):void
		{
			var errorStr:String="动画库XML加载失败";
			this.dispatchEvent(new LoadEvent(LoadEvent.XML_LOAD_ERROR, errorStr));
			try
			{
				load(urlStr);
			} 
			catch(error:Error) 
			{
				trace(error.message);
			}
		}

		private function progressHandler(e:ProgressEvent):void
		{
			trace("正在加载XML...");
		}
		
		private function close():void
		{
			try
			{
				xmlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				xmlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				xmlLoader.close();
				xmlLoader=null;
			}
			catch (error:Error)
			{

			}
		}
	}
}
