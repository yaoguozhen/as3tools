package com.zqvideo.loader
{
	import com.zqvideo.event.LoadEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.System;
	
	/**
	 * SWF加载类
	 * @author .....Li灬Star
	 */
	public class SWFLoader extends EventDispatcher
	{
		private var _swfUrlArr:Array=[];
		private var _allClipData:Array=[];
		private var urlLoader:URLLoader=new URLLoader();
		private var swfUrl:URLRequest=null;
		private var swfLoader:Loader=null;
		private var loaderContext:LoaderContext=null;
		private var clip:MovieClip=null;
		private var _currentClip:MovieClip=null;
		private var index:int=0;
		
		public function get swfUrlArr():Array{
			return _swfUrlArr;
		}
		
		public function set swfUrlArr(value:Array):void{
			_swfUrlArr=value;
		}
		
		public function get allClipData():Array
		{
			return _allClipData;
		}
		
		public function set allClipData(value:Array):void
		{
			_allClipData=value;
		}
		
		public function get currentClip():MovieClip
		{
			return _currentClip;
		}
		
		public function set currentClip(value:MovieClip):void
		{
			_currentClip=value;
		}
		
		public function SWFLoader()
		{
			
		}
		
		public function loadSwfData():void
		{
			if (swfUrlArr.length > 0)
			{
				var str:String=swfUrlArr.shift();
				loadSwf(str);
			}
		}
		
		private function loadSwf(str:String):void
		{
			swfLoader=new Loader();
			swfUrl=new URLRequest(str);
			loaderContext=new LoaderContext();
			loaderContext.applicationDomain=new ApplicationDomain();
			swfLoader.load(swfUrl,loaderContext);
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
		}
		
		private function loaderCompleteHandler(e:Event):void
		{
			clip=e.currentTarget.content as MovieClip;
			_allClipData.push(clip);
			
			/*var obj:Object=new Object();
			obj.clip=clip;
			this.dispatchEvent(new LoadEvent(LoadEvent.SWF_LOAD_COMPLETE, obj));*/
			
			try
			{
				swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
				swfLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
				swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
				swfLoader.unload();
				swfLoader=null;
			} 
			catch(error:Error) 
			{
				trace(error.toString());
			}
			
			
			if (swfUrlArr.length < 1)
			{
				this.dispatchEvent(new LoadEvent(LoadEvent.SWF_ALL_COMPLTE)); //发送图片全部加载完成事件 
			}
			else
			{
				loadSwfData();
				index++;
			}
		}
		
		private function loaderProgressHandler(e:ProgressEvent):void
		{
			//trace(Math.round(e.bytesLoaded/e.bytesTotal*100)+"%");
		}
		
		private function loaderErrorHandler(e:IOErrorEvent):void
		{
			var obj:Object=new Object();
			obj.errTxt=e.text;
			this.dispatchEvent(new LoadEvent(LoadEvent.SWF_LOAD_ERROR, obj));
		}
	}
}
